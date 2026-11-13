import 'package:drift/drift.dart';

import '../core/app_info.dart';
import '../core/calibration/engine.dart';
import '../core/calibration/level.dart';
import '../core/calibration/params.dart';
import '../core/content_pack/loader.dart';
import '../core/content_pack/models.dart';
import '../core/db/database.dart';
import '../core/db/legacy_migration.dart';
import '../core/llm/proxy_client.dart';
import '../core/selection/selection_intent.dart';
import '../core/services/practice_service.dart';
import '../core/settings/settings_store.dart';
import '../core/subject/subject.dart';
import '../features/achievements/achievement_engine.dart';
import '../features/hints/hint_service.dart';

/// 启动时装配好的本地服务集：数据库、内容包、校准、攻略、成就。
///
/// 断网也照常构造——在线能力只是 llm 这一个出口。
///
/// 一整套服务只服务一个学科：内容包、数据库路径、成就定义都按
/// [subject] 选定，不存在「同一实例里混两科」的可能。
class AppServices {
  AppServices({
    required this.db,
    required this.loaded,
    required this.engine,
    required this.aggregator,
    required this.practice,
    required this.hints,
    required this.achievements,
    required this.settings,
    required this.llm,
    required this.packService,
    required this.learnerId,
    required this.subject,
  });

  final AppDatabase db;
  final LoadedPack loaded;
  final CalibrationEngine engine;
  final LevelAggregator aggregator;
  final PracticeService practice;
  final HintService hints;
  final AchievementEngine achievements;
  final SettingsStore settings;
  final LlmProxyClient llm;
  final ContentPackService packService;
  final String learnerId;

  /// 当前档案绑定的学科
  final Subject subject;

  ContentPack get pack => loaded.pack;
  CalibrationParams get params => loaded.calibration;

  bool get contentPackHealthy => loaded.validation.ok;
  List<String> get contentPackWarnings => loaded.validation.warnings;

  Future<void> dispose() => db.close();

  static Future<AppServices> bootstrap({
    required Subject subject,
    SettingsStore? settingsStore,
  }) async {
    final settings = settingsStore ?? await SettingsStore.load();
    final learnerId = settings.learnerId;

    // 3.x 的混合学科单库 → 4.0 的单学科分库。能归属的按 ja./en. 拆分导入，
    // 无法归属的标 legacy_mixed 归档，不进任何学科库。旧库迁移后改名，只跑一次。
    await LegacyMigrator.migrateIfPresent(
      learnerId: learnerId,
      mode: settings.legacyMigrationMode,
    );

    final packService = ContentPackService(
      subject: subject,
      learnerId: learnerId,
      appVersion: kAppVersion,
    );

    LoadedPack loaded;
    try {
      loaded = await packService.loadActive();
    } catch (_) {
      // 已安装包损坏 → 回退内置包，并把指针清掉，避免每次启动都踩同一个坑
      await packService.rollback();
      loaded = await packService.loadBase();
    }

    final db = AppDatabase(learnerId: learnerId, subject: subject);
    final engine = CalibrationEngine(loaded.calibration);
    final aggregator = LevelAggregator(loaded.calibration);

    final practice = PracticeService(
      db: db,
      pack: loaded.pack,
      engine: engine,
      aggregator: aggregator,
      learnerId: learnerId,
      subject: subject,
    );

    final llm = LlmProxyClient(settings.proxyConfig);

    final hints = HintService(
      practice: practice,
      llm: llm,
      pack: loaded.pack,
      policy: HintLevelPolicy(
        forceExplainAt: loaded.calibration.explainModeHintThreshold,
      ),
    );

    final achievements = AchievementEngine(
      db: db,
      pack: loaded.pack,
      requiredEngineVersion: loaded.calibration.engineVersion,
      subject: subject,
    );

    await db.recordPackVersion(ContentPackVersionsCompanion.insert(
      packId: loaded.pack.manifest.packId,
      version: loaded.pack.manifest.version,
      installedAt: DateTime.now(),
      checksum: Value(loaded.pack.manifest.checksum),
      active: const Value(true),
    ));

    return AppServices(
      db: db,
      loaded: loaded,
      engine: engine,
      aggregator: aggregator,
      practice: practice,
      hints: hints,
      achievements: achievements,
      settings: settings,
      llm: llm,
      packService: packService,
      learnerId: learnerId,
      subject: subject,
    );
  }
}
