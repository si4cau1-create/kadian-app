import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../db/legacy_migration.dart';
import '../llm/models.dart';
import '../subject/subject.dart';

/// 本地设置：学科、代理地址、设备令牌、BYOK、隐私开关。
///
/// BYOK 的 Key 在真实分发版本里应写入 Android Keystore / Windows DPAPI；
/// 当前实现落在 SharedPreferences 并给出明确风险提示（见设置页）。
class SettingsStore {
  SettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kSubject = 'learner_subject';
  static const _kProxy = 'proxy_base_url';
  static const _kToken = 'device_token';
  static const _kByokBase = 'byok_base_url';
  static const _kByokKey = 'byok_api_key';
  static const _kByokModel = 'byok_model';
  static const _kLearner = 'learner_id';
  static const _kOnboard = 'onboarded';
  static const _kUploadDiagnostics = 'upload_diagnostics';
  static const _kEncryptDb = 'encrypt_db';
  static const _kLegacyMode = 'legacy_migration_mode';

  static Future<SettingsStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsStore(prefs);
  }

  /// 当前学科的原始值；未选择时为 null。
  ///
  /// 单学科实例没有默认学科：首次启动必须由用户显式选择，
  /// 未选择时不进入学习界面。
  String? get rawSubject {
    final value = _prefs.getString(_kSubject);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  /// 已选学科；未选择返回 null
  Subject? get subject => Subject.tryParse(rawSubject);

  /// 写入学科；传 null 表示清空（重置档案）
  set subject(Subject? value) {
    if (value == null) {
      _prefs.remove(_kSubject);
    } else {
      _prefs.setString(_kSubject, value.id);
    }
  }

  /// 清空学科选择（用于重置档案）
  Future<void> clearSubject() => _prefs.remove(_kSubject);

  /// 旧混合档案的处理策略：默认拆分导入；reset = 一键重置单学科档案（全部归档）。
  LegacyMode get legacyMigrationMode {
    final raw = _prefs.getString(_kLegacyMode);
    return LegacyMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => LegacyMode.split,
    );
  }

  set legacyMigrationMode(LegacyMode value) =>
      _prefs.setString(_kLegacyMode, value.name);

  String get proxyBaseUrl => _prefs.getString(_kProxy) ?? '';
  set proxyBaseUrl(String value) => _prefs.setString(_kProxy, value.trim());

  String get deviceToken => _prefs.getString(_kToken) ?? '';
  set deviceToken(String value) => _prefs.setString(_kToken, value.trim());

  String get byokBaseUrl => _prefs.getString(_kByokBase) ?? '';
  set byokBaseUrl(String value) => _prefs.setString(_kByokBase, value.trim());

  String get byokApiKey => _prefs.getString(_kByokKey) ?? '';
  set byokApiKey(String value) => _prefs.setString(_kByokKey, value.trim());

  String get byokModel => _prefs.getString(_kByokModel) ?? '';
  set byokModel(String value) => _prefs.setString(_kByokModel, value.trim());

  String get learnerId {
    final existing = _prefs.getString(_kLearner);
    if (existing != null && existing.isNotEmpty) return existing;
    final generated =
        'local-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}';
    _prefs.setString(_kLearner, generated);
    return generated;
  }

  bool get onboarded => _prefs.getBool(_kOnboard) ?? false;
  set onboarded(bool value) => _prefs.setBool(_kOnboard, value);

  bool get uploadDiagnostics => _prefs.getBool(_kUploadDiagnostics) ?? false;
  set uploadDiagnostics(bool value) =>
      _prefs.setBool(_kUploadDiagnostics, value);

  bool get encryptDb => _prefs.getBool(_kEncryptDb) ?? false;
  set encryptDb(bool value) => _prefs.setBool(_kEncryptDb, value);

  ProxyConfig get proxyConfig => ProxyConfig(
        baseUrl: proxyBaseUrl,
        deviceToken: deviceToken,
        byokBaseUrl: byokBaseUrl,
        byokApiKey: byokApiKey,
        byokModel: byokModel,
      );

  String exportSettingsJson() => const JsonEncoder.withIndent('  ').convert({
        'subject': subject?.id ?? 'unset',
        'proxy_base_url': proxyBaseUrl,
        'device_token': deviceToken.isEmpty ? '' : '***',
        'byok_enabled': proxyConfig.byokEnabled,
        'byok_model': byokModel,
        'upload_diagnostics': uploadDiagnostics,
        'encrypt_db': encryptDb,
      });
}
