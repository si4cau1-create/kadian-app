import 'package:drift/drift.dart';

import '../core/app_info.dart';
import '../core/calibration/engine.dart';
import '../core/calibration/level.dart';
import '../core/calibration/params.dart';
import '../core/content_pack/loader.dart';
import '../core/content_pack/models.dart';
import '../core/db/database.dart';
import '../core/llm/proxy_client.dart';
import '../core/selection/selection_intent.dart';
import '../core/services/practice_service.dart';
import '../core/settings/settings_store.dart';
import '../features/achievements/achievement_engine.dart';
import '../features/hints/hint_service.dart';

/// 启动时装配好的本地服务集：数据库、内容包、校准、攻略、成就。
///
/// 断网也照常构造——在线能力只是 llm 这一个出口。
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

  ContentPack get pack => loaded.pack;
  CalibrationParams get params => loaded.calibration;

  bool get contentPackHealthy => loaded.validation.ok;
  List<String> get contentPackWarnings => loaded.validation.warnings;

  static Future<AppServices> bootstrap() async {
    final packService = ContentPackService(appVersion: kAppVersion);
    LoadedPack loaded;
    try {
      loaded = await packService.loadActive();
    } catch (_) {
      // 已安装包损坏 → 回退内置包，并把指针清掉，避免每次启动都踩同一个坑
      await packService.rollback();
      loaded = await packService.loadBase();
    }

    final db = AppDatabase();
    final settings = await SettingsStore.load();
    final engine = CalibrationEngine(loaded.calibration);
    final aggregator = LevelAggregator(loaded.calibration);
    final learnerId = settings.learnerId;

    final practice = PracticeService(
      db: db,
      pack: loaded.pack,
      engine: engine,
      aggregator: aggregator,
      learnerId: learnerId,
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
    );
  }
}
