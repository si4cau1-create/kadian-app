import 'package:drift/drift.dart';

import '../../core/content_pack/models.dart';
import '../../core/db/database.dart';
import '../../core/db/tables.dart';
import '../../core/subject/subject.dart';

/// 成就结算：全本地、可重算。
///
/// 三段式（bronze/silver/gold）只是同一指标的三个门槛，不做「隐藏成就」，
/// 避免学习者为了解锁而刷。独立区与辅助区严格分开：independentOnly 的成就
/// 只吃 independent 证据。
///
/// 成就带学科命名空间（`japanese.first_step`），成就墙只展示当前学科，
/// XP 也只在本学科账上累加。
class AchievementEngine {
  AchievementEngine({
    required this.db,
    required this.pack,
    required this.requiredEngineVersion,
    required this.subject,
  });

  final AppDatabase db;
  final ContentPack pack;
  final String requiredEngineVersion;

  /// 当前档案绑定的学科
  final Subject subject;

  /// 本学科可结算的成就定义（防御层：包内混入外学科成就时直接剔除）
  Iterable<AchievementDef> get definitions sync* {
    for (final def in pack.achievements) {
      if (def.subjectId.isEmpty) {
        yield def;
        continue;
      }
      if (Subject.tryParse(def.subjectId) == subject) yield def;
    }
  }

  Future<AchievementSnapshot> settle({DateTime? now, Object? subject}) async {
    requireSameSubject(
      current: this.subject,
      requested: subject,
      operation: 'evaluate_achievement',
    );
    final at = now ?? DateTime.now();
    final metrics = await computeMetrics(now: at);
    final existing = {
      for (final row in await db.allAchievementStates()) row.achievementId: row
    };

    final unlocked = <AchievementUnlock>[];
    final states = <AchievementView>[];

    for (final def in definitions) {
      final value = metrics[def.metric] ?? 0;
      final prev = existing[def.id];
      var bestTier = prev?.tier ?? 'none';
      var xp = 0;
      DateTime? unlockedAt = prev?.unlockedAt;

      for (final stage in def.stages) {
        if (value + 1e-9 >= stage.target) {
          bestTier = _maxTier(bestTier, stage.tier);
          // XP 只奖励诊断行为；非诊断指标即使达成也不发
          if (def.xpEligible) xp += stage.xp;
          unlockedAt ??= at;
        }
      }

      final alreadyUnlocked = prev?.tier != null && prev!.tier != 'none';
      final nowUnlocked = bestTier != 'none';
      if (nowUnlocked && !alreadyUnlocked) {
        unlocked.add(AchievementUnlock(
          achievementId: def.id,
          title: def.title,
          tier: bestTier,
          xp: def.xpEligible ? xp : 0,
        ));
      }

      await db.upsertAchievement(AchievementStatesCompanion.insert(
        achievementId: def.id,
        tier: Value(bestTier),
        progress: Value(value),
        independent: Value(def.independentOnly),
        xpAwarded: Value(def.xpEligible ? xp : 0),
        unlockedAt: Value(unlockedAt),
        updatedAt: at,
      ));

      states.add(AchievementView(
        def: def,
        progress: value,
        tier: bestTier,
        xp: def.xpEligible ? xp : 0,
        unlockedAt: unlockedAt,
      ));
    }

    return AchievementSnapshot(
      views: states,
      newlyUnlocked: unlocked,
      totalXp: states.fold(0, (sum, e) => sum + e.xp),
      independentXp: 0,
      settledAt: at,
      subject: this.subject.id,
    );
  }

  Future<Map<String, double>> computeMetrics({DateTime? now}) async {
    final at = now ?? DateTime.now();
    final evidenceStats = await db.evidenceStats();
    final nodeRows = await db.allNodeStates();

    final diagnosticSessions = await _countDistinctDays(EvidenceKind.diagnostic);
    final reviewCount = await _countKind(EvidenceKind.review);
    final explainSessions = await _countExplain();
    final maxStreak = await _maxIndependentStreak();
    final streakDays = await db.streakDays(at).then((v) => v.toDouble());

    return {
      'evidence_total': evidenceStats.total.toDouble(),
      'independent_correct': evidenceStats.independentCorrect.toDouble(),
      'hint_free_items': evidenceStats.independentCorrect.toDouble(),
      'independent_streak_max': maxStreak.toDouble(),
      'diagnostic_sessions': diagnosticSessions.toDouble(),
      'vocab_reviews': reviewCount.toDouble(),
      'explain_sessions': explainSessions.toDouble(),
      'nodes_at_level_3':
          nodeRows.where((e) => e.mastery >= 0.58).length.toDouble(),
      'nodes_at_level_4':
          nodeRows.where((e) => e.mastery >= 0.76).length.toDouble(),
      'streak_days': streakDays,
    };
  }

  Future<int> _countKind(EvidenceKind kind) async {
    final count = db.evidenceEvents.id.count();
    final query = db.selectOnly(db.evidenceEvents)
      ..addColumns([count])
      ..where(db.evidenceEvents.kind.equalsValue(kind));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> _countDistinctDays(EvidenceKind kind) async {
    final rows = await db.customSelect(
      "SELECT COUNT(DISTINCT date(created_at)) AS c FROM evidence_events "
      "WHERE kind = ? AND source != 'legacy_mixed'",
      variables: [Variable.withString(kind.name)],
      readsFrom: {db.evidenceEvents},
    ).getSingle();
    return rows.read<int>('c');
  }

  Future<int> _countExplain() async {
    final rows = await db.customSelect(
      'SELECT COUNT(*) AS c FROM evidence_events '
      "WHERE explain_mode = 1 AND source != 'legacy_mixed'",
      readsFrom: {db.evidenceEvents},
    ).getSingle();
    return rows.read<int>('c');
  }

  Future<int> _maxIndependentStreak() async {
    final rows = await db.customSelect(
      'SELECT independent, score FROM evidence_events '
      "WHERE source != 'legacy_mixed' "
      'ORDER BY created_at ASC LIMIT 2000',
      readsFrom: {db.evidenceEvents},
    ).get();
    var best = 0;
    var current = 0;
    for (final row in rows) {
      final independent = row.read<int>('independent') == 1;
      final score = row.read<double>('score');
      if (independent && score >= 0.5) {
        current++;
        if (current > best) best = current;
      } else if (independent) {
        current = 0;
      }
      // 辅助/讲解证据不打断连胜，也不计入（分轨，不串账）
    }
    return best;
  }

  static const _tierOrder = ['none', 'bronze', 'silver', 'gold'];

  String _maxTier(String a, String b) {
    final ia = _tierOrder.indexOf(a);
    final ib = _tierOrder.indexOf(b);
    return ib > ia ? b : a;
  }
}

class AchievementView {
  const AchievementView({
    required this.def,
    required this.progress,
    required this.tier,
    required this.xp,
    this.unlockedAt,
  });

  final AchievementDef def;
  final double progress;
  final String tier;
  final int xp;
  final DateTime? unlockedAt;

  bool get unlocked => tier != 'none';

  AchievementStage? get currentStage {
    AchievementStage? next;
    for (final stage in def.stages) {
      if (progress < stage.target) {
        next = stage;
        break;
      }
    }
    return next;
  }

  double get progressToNext {
    final next = currentStage;
    if (next == null) return 1;
    final previousTarget = _previousTarget(next);
    final span = next.target - previousTarget;
    if (span <= 0) return 1;
    return ((progress - previousTarget) / span).clamp(0.0, 1.0);
  }

  double _previousTarget(AchievementStage stage) {
    var last = 0.0;
    for (final s in def.stages) {
      if (s.target >= stage.target) break;
      last = s.target;
    }
    return last;
  }
}

class AchievementUnlock {
  const AchievementUnlock({
    required this.achievementId,
    required this.title,
    required this.tier,
    required this.xp,
  });

  final String achievementId;
  final String title;
  final String tier;
  final int xp;
}

class AchievementSnapshot {
  const AchievementSnapshot({
    required this.views,
    required this.newlyUnlocked,
    required this.totalXp,
    required this.independentXp,
    required this.settledAt,
    required this.subject,
  });

  final List<AchievementView> views;
  final List<AchievementUnlock> newlyUnlocked;

  /// 本学科累计 XP。XP 按学科记账，跨学科不合并。
  final int totalXp;
  final int independentXp;
  final DateTime settledAt;
  final String subject;

  int get unlockedCount => views.where((e) => e.unlocked).length;
}
