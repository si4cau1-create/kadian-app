import 'dart:convert';

import 'package:drift/drift.dart';

/// 证据类型：本地一切「学过」的事实都记在 evidence_events 里，等级是它的投影。
enum EvidenceKind { attempt, hint, review, reading, writing, diagnostic }

enum AttemptMode { independent, assisted, explain }

@DataClassName('EvidenceEventRow')
class EvidenceEvents extends Table {
  TextColumn get id => text()();
  TextColumn get learnerId => text().withDefault(const Constant('local'))();
  TextColumn get nodeId => text()();
  TextColumn get itemId => text().nullable()();
  TextColumn get kind => textEnum<EvidenceKind>()();
  RealColumn get score => real()();
  RealColumn get effectiveScore => real().withDefault(const Constant(0))();
  RealColumn get predicted => real().withDefault(const Constant(0))();
  BoolColumn get independent => boolean().withDefault(const Constant(true))();
  IntColumn get hintLevel => integer().withDefault(const Constant(0))();
  IntColumn get hintRequestCount => integer().withDefault(const Constant(0))();
  BoolColumn get outOfScope => boolean().withDefault(const Constant(false))();
  BoolColumn get explainMode => boolean().withDefault(const Constant(false))();
  RealColumn get difficulty => real().withDefault(const Constant(0))();
  RealColumn get thetaAfter => real().withDefault(const Constant(0))();
  RealColumn get masteryAfter => real().withDefault(const Constant(0))();
  IntColumn get elapsedSeconds => integer().nullable()();
  TextColumn get source => text().withDefault(const Constant('app'))();
  TextColumn get payload => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('NodeStateRow')
class NodeStates extends Table {
  TextColumn get nodeId => text()();
  TextColumn get learnerId => text().withDefault(const Constant('local'))();
  RealColumn get mastery => real().withDefault(const Constant(0))();
  RealColumn get theta => real().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get independentAttempts =>
      integer().withDefault(const Constant(0))();
  IntColumn get independentCorrect => integer().withDefault(const Constant(0))();
  IntColumn get assistedAttempts => integer().withDefault(const Constant(0))();
  IntColumn get explainAttempts => integer().withDefault(const Constant(0))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  TextColumn get engineVersion => text().withDefault(const Constant('1.0.0'))();
  DateTimeColumn get lastSeenAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {nodeId};
}

@DataClassName('ItemDifficultyRow')
class ItemDifficulty extends Table {
  TextColumn get itemId => text()();
  TextColumn get nodeId => text()();
  RealColumn get difficulty => real().withDefault(const Constant(0))();
  RealColumn get discrimination => real().withDefault(const Constant(1))();
  IntColumn get exposure => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {itemId};
}

@DataClassName('VocabStateRow')
class VocabStates extends Table {
  TextColumn get wordId => text()();
  TextColumn get lemma => text()();
  TextColumn get reading => text().withDefault(const Constant(''))();
  TextColumn get gloss => text().withDefault(const Constant(''))();
  TextColumn get dimension => text().withDefault(const Constant('reading'))();
  TextColumn get clusterId => text().withDefault(const Constant(''))();
  IntColumn get box => integer().withDefault(const Constant(1))();
  RealColumn get ease => real().withDefault(const Constant(2.5))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  IntColumn get lastRating => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {wordId};
}

@DataClassName('AchievementStateRow')
class AchievementStates extends Table {
  TextColumn get achievementId => text()();
  TextColumn get tier => text().withDefault(const Constant('none'))();
  RealColumn get progress => real().withDefault(const Constant(0))();
  BoolColumn get independent => boolean().withDefault(const Constant(true))();
  IntColumn get xpAwarded => integer().withDefault(const Constant(0))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {achievementId};
}

/// 攻略事件：每一次长按/右键请求都留痕（含答案是否被揭示）
@DataClassName('HintEventRow')
class HintEvents extends Table {
  TextColumn get id => text()();
  TextColumn get learnerId => text().withDefault(const Constant('local'))();
  TextColumn get itemId => text()();
  TextColumn get nodeId => text()();
  TextColumn get selectedText => text()();
  TextColumn get selectionType => text()();
  TextColumn get intent => text()();
  IntColumn get hintLevel => integer().withDefault(const Constant(1))();
  BoolColumn get answerRevealed => boolean().withDefault(const Constant(false))();
  BoolColumn get outOfScope => boolean().withDefault(const Constant(false))();
  BoolColumn get explainMode => boolean().withDefault(const Constant(false))();
  BoolColumn get filtered => boolean().withDefault(const Constant(false))();
  BoolColumn get servedOffline =>
      boolean().withDefault(const Constant(false))();
  IntColumn get latencyMs => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 一次作答会话：assisted 与 independent 分轨的落点
@DataClassName('AttemptRow')
class Attempts extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  TextColumn get nodeId => text()();
  TextColumn get mode => textEnum<AttemptMode>()();
  IntColumn get hintLevel => integer().withDefault(const Constant(0))();
  IntColumn get hintRequestCount => integer().withDefault(const Constant(0))();
  BoolColumn get assisted => boolean().withDefault(const Constant(false))();
  BoolColumn get answerRevealed =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get correct => boolean().nullable()();
  TextColumn get selectedAnswer => text().withDefault(const Constant(''))();
  IntColumn get elapsedSeconds => integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ContentPackVersionRow')
class ContentPackVersions extends Table {
  TextColumn get packId => text()();
  TextColumn get version => text()();
  DateTimeColumn get installedAt => dateTime()();
  TextColumn get checksum => text().withDefault(const Constant(''))();
  BoolColumn get active => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {packId, version};
}

/// 预留云同步：先把变更排队，首期不外发
@DataClassName('SyncQueueRow')
class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get entity => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 每日节奏：连续天数、今日完成量（成就与看板用）
@DataClassName('DailyStatRow')
class DailyStats extends Table {
  DateTimeColumn get day => dateTime()();
  IntColumn get evidenceCount => integer().withDefault(const Constant(0))();
  IntColumn get independentCount => integer().withDefault(const Constant(0))();
  IntColumn get hintCount => integer().withDefault(const Constant(0))();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  IntColumn get minutes => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {day};
}

String encodePayload(Map<String, dynamic> value) => jsonEncode(value);
