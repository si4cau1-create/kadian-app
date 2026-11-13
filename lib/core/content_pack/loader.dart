import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../calibration/params.dart';
import '../subject/subject.dart';
import 'models.dart';

class PackValidation {
  const PackValidation({
    required this.ok,
    this.errors = const [],
    this.warnings = const [],
  });

  final bool ok;
  final List<String> errors;
  final List<String> warnings;

  static const PackValidation valid = PackValidation(ok: true);

  PackValidation merge(PackValidation other) => PackValidation(
        ok: ok && other.ok,
        errors: [...errors, ...other.errors],
        warnings: [...warnings, ...other.warnings],
      );
}

class LoadedPack {
  const LoadedPack({
    required this.pack,
    required this.validation,
    required this.calibration,
    this.source = 'asset',
  });

  final ContentPack pack;
  final PackValidation validation;
  final CalibrationParams calibration;
  final String source;
}

/// 内容包解析：纯内存操作，可在 dart test 里直接跑。
class ContentPackLoader {
  const ContentPackLoader();

  static const List<String> requiredFiles = ['manifest.json', 'graph.json'];

  /// 校验和只覆盖内容文件，不含 manifest 自身（否则 manifest 写不进自己的哈希）
  static String computeChecksum(Map<String, String> files) {
    final keys = files.keys.where((k) => k != 'manifest.json').toList()..sort();
    final buffer = StringBuffer();
    for (final key in keys) {
      // 换行先归一成 LF 再算：Windows 上 core.autocrlf=true 会把检出文件
      // 变成 CRLF，直接用原始字节算会让同一份内容包在不同平台上得出不同
      // 校验和。Python 打包脚本用文本模式读文件，本身就是 LF 归一。
      final normalized = files[key]!.replaceAll('\r\n', '\n');
      final digest = sha256.convert(utf8.encode(normalized)).toString();
      buffer.writeln('$key:$digest');
    }
    return sha256.convert(utf8.encode(buffer.toString())).toString();
  }

  LoadedPack parse(
    Map<String, String> files, {
    String source = 'asset',
    bool verifyChecksum = true,
    String? currentAppVersion,
    Subject? expectedSubject,
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    for (final required in requiredFiles) {
      if (!files.containsKey(required)) {
        errors.add('缺少必需文件：$required');
      }
    }
    if (errors.isNotEmpty) {
      throw ContentPackException(errors.join('；'));
    }

    final manifest = ContentManifest.fromJson(
      jsonDecode(files['manifest.json']!) as Map<String, dynamic>,
    );

    // 校验和：OTA 包必须一致；内置包允许缺省（开发期）
    if (verifyChecksum && manifest.checksum.isNotEmpty) {
      final actual = computeChecksum(files);
      if (actual != manifest.checksum) {
        errors.add('校验和不匹配（期望 ${manifest.checksum.substring(0, 8)}…，'
            '实际 ${actual.substring(0, 8)}…）');
      }
    } else if (manifest.checksum.isEmpty) {
      warnings.add('内容包未声明 checksum，已按开发模式加载');
    }

    // 最低客户端版本
    if (currentAppVersion != null && manifest.minAppVersion.isNotEmpty) {
      if (compareSemver(currentAppVersion, manifest.minAppVersion) < 0) {
        errors.add('内容包需要客户端 ≥ ${manifest.minAppVersion}，'
            '当前 $currentAppVersion，请先升级');
      }
    }

    final graph = jsonDecode(files['graph.json']!) as Map<String, dynamic>;
    final subjects = (graph['subjects'] as List?)
            ?.whereType<Map>()
            .map((e) => SubjectDef.fromJson(e.cast<String, dynamic>()))
            .toList() ??
        const <SubjectDef>[];
    final tracks = (graph['tracks'] as List?)
            ?.whereType<Map>()
            .map((e) => TrackDef.fromJson(e.cast<String, dynamic>()))
            .toList() ??
        const <TrackDef>[];
    final clusters = (graph['clusters'] as List?)
            ?.whereType<Map>()
            .map((e) => ClusterDef.fromJson(e.cast<String, dynamic>()))
            .toList() ??
        const <ClusterDef>[];
    final nodes = (graph['nodes'] as List?)
            ?.whereType<Map>()
            .map((e) => NodeDef.fromJson(e.cast<String, dynamic>()))
            .toList() ??
        const <NodeDef>[];

    if (nodes.isEmpty) errors.add('graph.json 里没有任何节点');

    final items = _collectItems(files, warnings);
    final passages = _collectPassages(files);
    final vocab = _collectVocab(files);
    final achievements = _collectAchievements(files);

    if (items.isEmpty) warnings.add('内容包没有题目，做题与诊断会不可用');
    if (achievements.isEmpty) warnings.add('内容包没有成就定义');

    final calibrationJson = files.containsKey('calibration_params.json')
        ? jsonDecode(files['calibration_params.json']!) as Map<String, dynamic>
        : <String, dynamic>{};

    // 引用完整性：题目指向的节点/语篇必须存在
    final nodeIds = nodes.map((e) => e.id).toSet();
    final passageIds = passages.map((e) => e.id).toSet();
    for (final item in items) {
      if (item.nodeId.isNotEmpty && !nodeIds.contains(item.nodeId)) {
        warnings.add('题目 ${item.id} 指向不存在的节点 ${item.nodeId}');
      }
      if (item.passageId.isNotEmpty && !passageIds.contains(item.passageId)) {
        warnings.add('题目 ${item.id} 指向不存在的语篇 ${item.passageId}');
      }
    }

    final pack = ContentPack(
      manifest: manifest,
      subjects: subjects,
      tracks: tracks,
      clusters: clusters,
      nodes: nodes,
      passages: passages,
      items: items,
      vocab: vocab,
      achievements: achievements,
      calibrationJson: calibrationJson,
      sourcePath: source,
    );

    // 单学科实例：拒绝任何跨学科的包。宁可加载失败也不让两科数据混一个档案。
    if (expectedSubject != null) {
      final declared = pack.subject;
      if (declared != null && declared != expectedSubject) {
        errors.add('内容包属于「${declared.label}」，'
            '当前档案是「${expectedSubject.label}」，拒绝加载');
      }
      final foreignNodes = pack.foreignNodeIds(expectedSubject);
      if (foreignNodes.isNotEmpty) {
        errors.add('内容包含 ${foreignNodes.length} 个跨学科节点'
            '（${foreignNodes.take(3).join('、')}…）');
      }
      final foreignItems = pack.foreignItemIds(expectedSubject);
      if (foreignItems.isNotEmpty) {
        errors.add('内容包含 ${foreignItems.length} 道跨学科题目'
            '（${foreignItems.take(3).join('、')}…）');
      }
      final foreignClusters = pack.foreignClusterIds(expectedSubject);
      if (foreignClusters.isNotEmpty) {
        errors.add('内容包含 ${foreignClusters.length} 个跨学科簇');
      }
      final foreignAchievements =
          pack.foreignAchievementIds(expectedSubject);
      if (foreignAchievements.isNotEmpty) {
        errors.add('内容包含 ${foreignAchievements.length} 个跨学科成就');
      }
    }

    return LoadedPack(
      pack: pack,
      validation: PackValidation(
        ok: errors.isEmpty,
        errors: errors,
        warnings: warnings,
      ),
      calibration: calibrationJson.isEmpty
          ? CalibrationParams.fallback
          : CalibrationParams.fromJson(calibrationJson),
      source: source,
    );
  }

  List<ItemDef> _collectItems(
      Map<String, String> files, List<String> warnings) {
    final result = <ItemDef>[];
    void addJson(String raw, String label) {
      try {
        final json = jsonDecode(raw);
        if (json is Map<String, dynamic>) {
          final list = json['items'];
          if (list is List) {
            result.addAll(list
                .whereType<Map>()
                .map((e) => ItemDef.fromJson(e.cast<String, dynamic>())));
          } else if (json['id'] != null) {
            result.add(ItemDef.fromJson(json));
          }
        } else if (json is List) {
          result.addAll(json
              .whereType<Map>()
              .map((e) => ItemDef.fromJson(e.cast<String, dynamic>())));
        }
      } catch (e) {
        warnings.add('$label 解析失败：$e');
      }
    }

    files.forEach((path, content) {
      if (path == 'items.json') addJson(content, path);
      if (path.startsWith('items/') && path.endsWith('.json')) {
        addJson(content, path);
      }
    });
    return result;
  }

  List<PassageDef> _collectPassages(Map<String, String> files) {
    final result = <PassageDef>[];
    files.forEach((path, content) {
      if (path != 'passages.json' && path != 'items.json') return;
      if (!content.contains('"passages"')) return;
      try {
        final json = jsonDecode(content) as Map<String, dynamic>;
        final list = json['passages'];
        if (list is List) {
          result.addAll(list
              .whereType<Map>()
              .map((e) => PassageDef.fromJson(e.cast<String, dynamic>())));
        }
      } catch (_) {
        // 忽略
      }
    });
    return result;
  }

  List<VocabDef> _collectVocab(Map<String, String> files) {
    final result = <VocabDef>[];
    files.forEach((path, content) {
      if (path != 'vocab.json' &&
          !(path.startsWith('vocab/') && path.endsWith('.json'))) {
        return;
      }
      try {
        final json = jsonDecode(content);
        if (json is Map<String, dynamic> && json['vocab'] is List) {
          result.addAll((json['vocab'] as List)
              .whereType<Map>()
              .map((e) => VocabDef.fromJson(e.cast<String, dynamic>())));
        }
      } catch (_) {
        // 忽略
      }
    });
    return result;
  }

  List<AchievementDef> _collectAchievements(Map<String, String> files) {
    final raw = files['achievements.json'];
    if (raw == null) return const [];
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final list = json['achievements'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => AchievementDef.fromJson(e.cast<String, dynamic>()))
            .toList();
      }
    } catch (_) {
      // 忽略
    }
    return const [];
  }
}

class ContentPackException implements Exception {
  ContentPackException(this.message);

  final String message;

  @override
  String toString() => 'ContentPackException: $message';
}

/// 语义化版本比较：返回 -1 / 0 / 1
int compareSemver(String a, String b) {
  final pa = _parseVersion(a);
  final pb = _parseVersion(b);
  for (var i = 0; i < 3; i++) {
    if (pa[i] != pb[i]) return pa[i] > pb[i] ? 1 : -1;
  }
  return 0;
}

List<int> _parseVersion(String raw) {
  final cleaned = raw.split('+').first.split('-').first;
  final parts = cleaned.split('.');
  return [
    for (var i = 0; i < 3; i++)
      i < parts.length ? (int.tryParse(parts[i]) ?? 0) : 0,
  ];
}

/// 运行时内容包服务：内置包 → 已安装 OTA 包 → 校验失败回退。
///
/// 一个实例只服务一个学科，资产目录与 OTA 安装目录都按学科隔离，
/// 加载时还会拒绝跨学科的包。
class ContentPackService {
  ContentPackService({
    required this.subject,
    this.learnerId = 'local',
    this.appVersion = '4.0.0',
  });

  final Subject subject;
  final String learnerId;
  final String appVersion;

  static const List<String> assetFiles = [
    'manifest.json',
    'graph.json',
    'items.json',
    'vocab.json',
    'achievements.json',
    'calibration_params.json',
  ];

  /// 内置资产目录：assets/content_pack/<subject>/
  String get assetRoot => 'assets/content_pack/${subject.id}';

  final ContentPackLoader _loader = const ContentPackLoader();

  Future<LoadedPack> loadActive() async {
    final installed = await loadInstalled();
    if (installed != null) return installed;
    return loadBase();
  }

  Future<LoadedPack> loadBase() async {
    final files = <String, String>{};
    for (final name in assetFiles) {
      try {
        files[name] = await rootBundle.loadString('$assetRoot/$name');
      } catch (_) {
        // 允许缺失（例如没有 vocab.json）
      }
    }
    return _loader.parse(
      files,
      source: assetRoot,
      verifyChecksum: true,
      currentAppVersion: appVersion,
      expectedSubject: subject,
    );
  }

  Future<LoadedPack?> loadInstalled() async {
    final root = await _packsDir();
    final pointer = File(p.join(root.path, 'active.json'));
    if (!pointer.existsSync()) return null;
    try {
      final json =
          jsonDecode(await pointer.readAsString()) as Map<String, dynamic>;
      final packId = json['packId'] as String? ?? '';
      final version = json['version'] as String? ?? '';
      if (packId.isEmpty || version.isEmpty) return null;
      final dir = Directory(p.join(root.path, packId, version));
      if (!dir.existsSync()) return null;
      final files = await _readDirectory(dir);
      final loaded = _loader.parse(
        files,
        source: dir.path,
        verifyChecksum: true,
        currentAppVersion: appVersion,
        expectedSubject: subject,
      );
      // 校验不过就当没装过：宁可回到内置包，也不带着坏数据跑
      return loaded.validation.ok ? loaded : null;
    } catch (_) {
      // 已安装包损坏 → 回退内置包（不删除，留给用户手动回滚）
      return null;
    }
  }

  /// 安装 OTA 包：解压到临时目录 → 校验 → 原子替换 → 写指针。
  /// 任何一步失败都不动现有指针，因此天然回滚。
  Future<LoadedPack> installZip(String zipPath) async {
    final zipFile = File(zipPath);
    if (!zipFile.existsSync()) {
      throw ContentPackException('安装包不存在：$zipPath');
    }
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final files = <String, String>{};
    for (final entry in archive) {
      if (!entry.isFile) continue;
      final name = entry.name.replaceAll('\\', '/');
      if (name.contains('__MACOSX')) continue;
      final data = entry.content;
      if (data is List<int>) {
        files[name] = utf8.decode(data, allowMalformed: true);
      }
    }
    if (files.isEmpty) {
      throw ContentPackException('内容包为空');
    }

    final loaded = _loader.parse(
      files,
      source: zipPath,
      verifyChecksum: true,
      currentAppVersion: appVersion,
      expectedSubject: subject,
    );
    if (!loaded.validation.ok) {
      throw ContentPackException(loaded.validation.errors.join('；'));
    }

    final root = await _packsDir();
    final target = Directory(p.join(
      root.path,
      loaded.pack.manifest.packId,
      loaded.pack.manifest.version,
    ));
    final temp = Directory('${target.path}.tmp');
    if (temp.existsSync()) temp.deleteSync(recursive: true);
    temp.createSync(recursive: true);
    for (final entry in files.entries) {
      final file = File(p.join(temp.path, entry.key));
      await file.parent.create(recursive: true);
      await file.writeAsString(entry.value);
    }
    if (target.existsSync()) target.deleteSync(recursive: true);
    temp.renameSync(target.path);

    final pointer = File(p.join(root.path, 'active.json'));
    await pointer.writeAsString(jsonEncode({
      'packId': loaded.pack.manifest.packId,
      'version': loaded.pack.manifest.version,
      'installedAt': DateTime.now().toIso8601String(),
    }));

    return loaded;
  }

  /// 回滚到内置包
  Future<void> rollback() async {
    final root = await _packsDir();
    final pointer = File(p.join(root.path, 'active.json'));
    if (pointer.existsSync()) pointer.deleteSync();
  }

  /// OTA 包按档案与学科隔离：learners/<learnerId>/<subject>/content_packs/
  Future<Directory> _packsDir() async {
    final base = await getApplicationSupportDirectory();
    final packs = Directory(p.join(
      base.path,
      'learners',
      learnerId,
      subject.id,
      'content_packs',
    ));
    if (!packs.existsSync()) packs.createSync(recursive: true);
    return packs;
  }

  Future<Map<String, String>> _readDirectory(Directory dir) async {
    final result = <String, String>{};
    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.json')) continue;
      final relative = p.relative(entity.path, from: dir.path);
      result[relative.replaceAll('\\', '/')] = await entity.readAsString();
    }
    return result;
  }
}
