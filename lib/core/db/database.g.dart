// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EvidenceEventsTable extends EvidenceEvents
    with TableInfo<$EvidenceEventsTable, EvidenceEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _learnerIdMeta =
      const VerificationMeta('learnerId');
  @override
  late final GeneratedColumn<String> learnerId = GeneratedColumn<String>(
      'learner_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
      'node_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumnWithTypeConverter<EvidenceKind, String> kind =
      GeneratedColumn<String>('kind', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<EvidenceKind>($EvidenceEventsTable.$converterkind);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
      'score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _effectiveScoreMeta =
      const VerificationMeta('effectiveScore');
  @override
  late final GeneratedColumn<double> effectiveScore = GeneratedColumn<double>(
      'effective_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _predictedMeta =
      const VerificationMeta('predicted');
  @override
  late final GeneratedColumn<double> predicted = GeneratedColumn<double>(
      'predicted', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _independentMeta =
      const VerificationMeta('independent');
  @override
  late final GeneratedColumn<bool> independent = GeneratedColumn<bool>(
      'independent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("independent" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _hintLevelMeta =
      const VerificationMeta('hintLevel');
  @override
  late final GeneratedColumn<int> hintLevel = GeneratedColumn<int>(
      'hint_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hintRequestCountMeta =
      const VerificationMeta('hintRequestCount');
  @override
  late final GeneratedColumn<int> hintRequestCount = GeneratedColumn<int>(
      'hint_request_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _outOfScopeMeta =
      const VerificationMeta('outOfScope');
  @override
  late final GeneratedColumn<bool> outOfScope = GeneratedColumn<bool>(
      'out_of_scope', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("out_of_scope" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _explainModeMeta =
      const VerificationMeta('explainMode');
  @override
  late final GeneratedColumn<bool> explainMode = GeneratedColumn<bool>(
      'explain_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("explain_mode" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _thetaAfterMeta =
      const VerificationMeta('thetaAfter');
  @override
  late final GeneratedColumn<double> thetaAfter = GeneratedColumn<double>(
      'theta_after', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _masteryAfterMeta =
      const VerificationMeta('masteryAfter');
  @override
  late final GeneratedColumn<double> masteryAfter = GeneratedColumn<double>(
      'mastery_after', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _elapsedSecondsMeta =
      const VerificationMeta('elapsedSeconds');
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
      'elapsed_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('app'));
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        learnerId,
        nodeId,
        itemId,
        kind,
        score,
        effectiveScore,
        predicted,
        independent,
        hintLevel,
        hintRequestCount,
        outOfScope,
        explainMode,
        difficulty,
        thetaAfter,
        masteryAfter,
        elapsedSeconds,
        source,
        payload,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidence_events';
  @override
  VerificationContext validateIntegrity(Insertable<EvidenceEventRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('learner_id')) {
      context.handle(_learnerIdMeta,
          learnerId.isAcceptableOrUnknown(data['learner_id']!, _learnerIdMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    }
    context.handle(_kindMeta, const VerificationResult.success());
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('effective_score')) {
      context.handle(
          _effectiveScoreMeta,
          effectiveScore.isAcceptableOrUnknown(
              data['effective_score']!, _effectiveScoreMeta));
    }
    if (data.containsKey('predicted')) {
      context.handle(_predictedMeta,
          predicted.isAcceptableOrUnknown(data['predicted']!, _predictedMeta));
    }
    if (data.containsKey('independent')) {
      context.handle(
          _independentMeta,
          independent.isAcceptableOrUnknown(
              data['independent']!, _independentMeta));
    }
    if (data.containsKey('hint_level')) {
      context.handle(_hintLevelMeta,
          hintLevel.isAcceptableOrUnknown(data['hint_level']!, _hintLevelMeta));
    }
    if (data.containsKey('hint_request_count')) {
      context.handle(
          _hintRequestCountMeta,
          hintRequestCount.isAcceptableOrUnknown(
              data['hint_request_count']!, _hintRequestCountMeta));
    }
    if (data.containsKey('out_of_scope')) {
      context.handle(
          _outOfScopeMeta,
          outOfScope.isAcceptableOrUnknown(
              data['out_of_scope']!, _outOfScopeMeta));
    }
    if (data.containsKey('explain_mode')) {
      context.handle(
          _explainModeMeta,
          explainMode.isAcceptableOrUnknown(
              data['explain_mode']!, _explainModeMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('theta_after')) {
      context.handle(
          _thetaAfterMeta,
          thetaAfter.isAcceptableOrUnknown(
              data['theta_after']!, _thetaAfterMeta));
    }
    if (data.containsKey('mastery_after')) {
      context.handle(
          _masteryAfterMeta,
          masteryAfter.isAcceptableOrUnknown(
              data['mastery_after']!, _masteryAfterMeta));
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
          _elapsedSecondsMeta,
          elapsedSeconds.isAcceptableOrUnknown(
              data['elapsed_seconds']!, _elapsedSecondsMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EvidenceEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceEventRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      learnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}learner_id'])!,
      nodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id']),
      kind: $EvidenceEventsTable.$converterkind.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!),
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}score'])!,
      effectiveScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}effective_score'])!,
      predicted: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}predicted'])!,
      independent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}independent'])!,
      hintLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hint_level'])!,
      hintRequestCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}hint_request_count'])!,
      outOfScope: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}out_of_scope'])!,
      explainMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}explain_mode'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difficulty'])!,
      thetaAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}theta_after'])!,
      masteryAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mastery_after'])!,
      elapsedSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}elapsed_seconds']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EvidenceEventsTable createAlias(String alias) {
    return $EvidenceEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EvidenceKind, String, String> $converterkind =
      const EnumNameConverter<EvidenceKind>(EvidenceKind.values);
}

class EvidenceEventRow extends DataClass
    implements Insertable<EvidenceEventRow> {
  final String id;
  final String learnerId;
  final String nodeId;
  final String? itemId;
  final EvidenceKind kind;
  final double score;
  final double effectiveScore;
  final double predicted;
  final bool independent;
  final int hintLevel;
  final int hintRequestCount;
  final bool outOfScope;
  final bool explainMode;
  final double difficulty;
  final double thetaAfter;
  final double masteryAfter;
  final int? elapsedSeconds;
  final String source;
  final String payload;
  final DateTime createdAt;
  const EvidenceEventRow(
      {required this.id,
      required this.learnerId,
      required this.nodeId,
      this.itemId,
      required this.kind,
      required this.score,
      required this.effectiveScore,
      required this.predicted,
      required this.independent,
      required this.hintLevel,
      required this.hintRequestCount,
      required this.outOfScope,
      required this.explainMode,
      required this.difficulty,
      required this.thetaAfter,
      required this.masteryAfter,
      this.elapsedSeconds,
      required this.source,
      required this.payload,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['learner_id'] = Variable<String>(learnerId);
    map['node_id'] = Variable<String>(nodeId);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<String>(itemId);
    }
    {
      map['kind'] =
          Variable<String>($EvidenceEventsTable.$converterkind.toSql(kind));
    }
    map['score'] = Variable<double>(score);
    map['effective_score'] = Variable<double>(effectiveScore);
    map['predicted'] = Variable<double>(predicted);
    map['independent'] = Variable<bool>(independent);
    map['hint_level'] = Variable<int>(hintLevel);
    map['hint_request_count'] = Variable<int>(hintRequestCount);
    map['out_of_scope'] = Variable<bool>(outOfScope);
    map['explain_mode'] = Variable<bool>(explainMode);
    map['difficulty'] = Variable<double>(difficulty);
    map['theta_after'] = Variable<double>(thetaAfter);
    map['mastery_after'] = Variable<double>(masteryAfter);
    if (!nullToAbsent || elapsedSeconds != null) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    }
    map['source'] = Variable<String>(source);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EvidenceEventsCompanion toCompanion(bool nullToAbsent) {
    return EvidenceEventsCompanion(
      id: Value(id),
      learnerId: Value(learnerId),
      nodeId: Value(nodeId),
      itemId:
          itemId == null && nullToAbsent ? const Value.absent() : Value(itemId),
      kind: Value(kind),
      score: Value(score),
      effectiveScore: Value(effectiveScore),
      predicted: Value(predicted),
      independent: Value(independent),
      hintLevel: Value(hintLevel),
      hintRequestCount: Value(hintRequestCount),
      outOfScope: Value(outOfScope),
      explainMode: Value(explainMode),
      difficulty: Value(difficulty),
      thetaAfter: Value(thetaAfter),
      masteryAfter: Value(masteryAfter),
      elapsedSeconds: elapsedSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(elapsedSeconds),
      source: Value(source),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory EvidenceEventRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceEventRow(
      id: serializer.fromJson<String>(json['id']),
      learnerId: serializer.fromJson<String>(json['learnerId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      itemId: serializer.fromJson<String?>(json['itemId']),
      kind: $EvidenceEventsTable.$converterkind
          .fromJson(serializer.fromJson<String>(json['kind'])),
      score: serializer.fromJson<double>(json['score']),
      effectiveScore: serializer.fromJson<double>(json['effectiveScore']),
      predicted: serializer.fromJson<double>(json['predicted']),
      independent: serializer.fromJson<bool>(json['independent']),
      hintLevel: serializer.fromJson<int>(json['hintLevel']),
      hintRequestCount: serializer.fromJson<int>(json['hintRequestCount']),
      outOfScope: serializer.fromJson<bool>(json['outOfScope']),
      explainMode: serializer.fromJson<bool>(json['explainMode']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      thetaAfter: serializer.fromJson<double>(json['thetaAfter']),
      masteryAfter: serializer.fromJson<double>(json['masteryAfter']),
      elapsedSeconds: serializer.fromJson<int?>(json['elapsedSeconds']),
      source: serializer.fromJson<String>(json['source']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'learnerId': serializer.toJson<String>(learnerId),
      'nodeId': serializer.toJson<String>(nodeId),
      'itemId': serializer.toJson<String?>(itemId),
      'kind': serializer
          .toJson<String>($EvidenceEventsTable.$converterkind.toJson(kind)),
      'score': serializer.toJson<double>(score),
      'effectiveScore': serializer.toJson<double>(effectiveScore),
      'predicted': serializer.toJson<double>(predicted),
      'independent': serializer.toJson<bool>(independent),
      'hintLevel': serializer.toJson<int>(hintLevel),
      'hintRequestCount': serializer.toJson<int>(hintRequestCount),
      'outOfScope': serializer.toJson<bool>(outOfScope),
      'explainMode': serializer.toJson<bool>(explainMode),
      'difficulty': serializer.toJson<double>(difficulty),
      'thetaAfter': serializer.toJson<double>(thetaAfter),
      'masteryAfter': serializer.toJson<double>(masteryAfter),
      'elapsedSeconds': serializer.toJson<int?>(elapsedSeconds),
      'source': serializer.toJson<String>(source),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EvidenceEventRow copyWith(
          {String? id,
          String? learnerId,
          String? nodeId,
          Value<String?> itemId = const Value.absent(),
          EvidenceKind? kind,
          double? score,
          double? effectiveScore,
          double? predicted,
          bool? independent,
          int? hintLevel,
          int? hintRequestCount,
          bool? outOfScope,
          bool? explainMode,
          double? difficulty,
          double? thetaAfter,
          double? masteryAfter,
          Value<int?> elapsedSeconds = const Value.absent(),
          String? source,
          String? payload,
          DateTime? createdAt}) =>
      EvidenceEventRow(
        id: id ?? this.id,
        learnerId: learnerId ?? this.learnerId,
        nodeId: nodeId ?? this.nodeId,
        itemId: itemId.present ? itemId.value : this.itemId,
        kind: kind ?? this.kind,
        score: score ?? this.score,
        effectiveScore: effectiveScore ?? this.effectiveScore,
        predicted: predicted ?? this.predicted,
        independent: independent ?? this.independent,
        hintLevel: hintLevel ?? this.hintLevel,
        hintRequestCount: hintRequestCount ?? this.hintRequestCount,
        outOfScope: outOfScope ?? this.outOfScope,
        explainMode: explainMode ?? this.explainMode,
        difficulty: difficulty ?? this.difficulty,
        thetaAfter: thetaAfter ?? this.thetaAfter,
        masteryAfter: masteryAfter ?? this.masteryAfter,
        elapsedSeconds:
            elapsedSeconds.present ? elapsedSeconds.value : this.elapsedSeconds,
        source: source ?? this.source,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
      );
  EvidenceEventRow copyWithCompanion(EvidenceEventsCompanion data) {
    return EvidenceEventRow(
      id: data.id.present ? data.id.value : this.id,
      learnerId: data.learnerId.present ? data.learnerId.value : this.learnerId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      kind: data.kind.present ? data.kind.value : this.kind,
      score: data.score.present ? data.score.value : this.score,
      effectiveScore: data.effectiveScore.present
          ? data.effectiveScore.value
          : this.effectiveScore,
      predicted: data.predicted.present ? data.predicted.value : this.predicted,
      independent:
          data.independent.present ? data.independent.value : this.independent,
      hintLevel: data.hintLevel.present ? data.hintLevel.value : this.hintLevel,
      hintRequestCount: data.hintRequestCount.present
          ? data.hintRequestCount.value
          : this.hintRequestCount,
      outOfScope:
          data.outOfScope.present ? data.outOfScope.value : this.outOfScope,
      explainMode:
          data.explainMode.present ? data.explainMode.value : this.explainMode,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      thetaAfter:
          data.thetaAfter.present ? data.thetaAfter.value : this.thetaAfter,
      masteryAfter: data.masteryAfter.present
          ? data.masteryAfter.value
          : this.masteryAfter,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      source: data.source.present ? data.source.value : this.source,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceEventRow(')
          ..write('id: $id, ')
          ..write('learnerId: $learnerId, ')
          ..write('nodeId: $nodeId, ')
          ..write('itemId: $itemId, ')
          ..write('kind: $kind, ')
          ..write('score: $score, ')
          ..write('effectiveScore: $effectiveScore, ')
          ..write('predicted: $predicted, ')
          ..write('independent: $independent, ')
          ..write('hintLevel: $hintLevel, ')
          ..write('hintRequestCount: $hintRequestCount, ')
          ..write('outOfScope: $outOfScope, ')
          ..write('explainMode: $explainMode, ')
          ..write('difficulty: $difficulty, ')
          ..write('thetaAfter: $thetaAfter, ')
          ..write('masteryAfter: $masteryAfter, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('source: $source, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      learnerId,
      nodeId,
      itemId,
      kind,
      score,
      effectiveScore,
      predicted,
      independent,
      hintLevel,
      hintRequestCount,
      outOfScope,
      explainMode,
      difficulty,
      thetaAfter,
      masteryAfter,
      elapsedSeconds,
      source,
      payload,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceEventRow &&
          other.id == this.id &&
          other.learnerId == this.learnerId &&
          other.nodeId == this.nodeId &&
          other.itemId == this.itemId &&
          other.kind == this.kind &&
          other.score == this.score &&
          other.effectiveScore == this.effectiveScore &&
          other.predicted == this.predicted &&
          other.independent == this.independent &&
          other.hintLevel == this.hintLevel &&
          other.hintRequestCount == this.hintRequestCount &&
          other.outOfScope == this.outOfScope &&
          other.explainMode == this.explainMode &&
          other.difficulty == this.difficulty &&
          other.thetaAfter == this.thetaAfter &&
          other.masteryAfter == this.masteryAfter &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.source == this.source &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class EvidenceEventsCompanion extends UpdateCompanion<EvidenceEventRow> {
  final Value<String> id;
  final Value<String> learnerId;
  final Value<String> nodeId;
  final Value<String?> itemId;
  final Value<EvidenceKind> kind;
  final Value<double> score;
  final Value<double> effectiveScore;
  final Value<double> predicted;
  final Value<bool> independent;
  final Value<int> hintLevel;
  final Value<int> hintRequestCount;
  final Value<bool> outOfScope;
  final Value<bool> explainMode;
  final Value<double> difficulty;
  final Value<double> thetaAfter;
  final Value<double> masteryAfter;
  final Value<int?> elapsedSeconds;
  final Value<String> source;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EvidenceEventsCompanion({
    this.id = const Value.absent(),
    this.learnerId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.kind = const Value.absent(),
    this.score = const Value.absent(),
    this.effectiveScore = const Value.absent(),
    this.predicted = const Value.absent(),
    this.independent = const Value.absent(),
    this.hintLevel = const Value.absent(),
    this.hintRequestCount = const Value.absent(),
    this.outOfScope = const Value.absent(),
    this.explainMode = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.thetaAfter = const Value.absent(),
    this.masteryAfter = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.source = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidenceEventsCompanion.insert({
    required String id,
    this.learnerId = const Value.absent(),
    required String nodeId,
    this.itemId = const Value.absent(),
    required EvidenceKind kind,
    required double score,
    this.effectiveScore = const Value.absent(),
    this.predicted = const Value.absent(),
    this.independent = const Value.absent(),
    this.hintLevel = const Value.absent(),
    this.hintRequestCount = const Value.absent(),
    this.outOfScope = const Value.absent(),
    this.explainMode = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.thetaAfter = const Value.absent(),
    this.masteryAfter = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.source = const Value.absent(),
    this.payload = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nodeId = Value(nodeId),
        kind = Value(kind),
        score = Value(score),
        createdAt = Value(createdAt);
  static Insertable<EvidenceEventRow> custom({
    Expression<String>? id,
    Expression<String>? learnerId,
    Expression<String>? nodeId,
    Expression<String>? itemId,
    Expression<String>? kind,
    Expression<double>? score,
    Expression<double>? effectiveScore,
    Expression<double>? predicted,
    Expression<bool>? independent,
    Expression<int>? hintLevel,
    Expression<int>? hintRequestCount,
    Expression<bool>? outOfScope,
    Expression<bool>? explainMode,
    Expression<double>? difficulty,
    Expression<double>? thetaAfter,
    Expression<double>? masteryAfter,
    Expression<int>? elapsedSeconds,
    Expression<String>? source,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (learnerId != null) 'learner_id': learnerId,
      if (nodeId != null) 'node_id': nodeId,
      if (itemId != null) 'item_id': itemId,
      if (kind != null) 'kind': kind,
      if (score != null) 'score': score,
      if (effectiveScore != null) 'effective_score': effectiveScore,
      if (predicted != null) 'predicted': predicted,
      if (independent != null) 'independent': independent,
      if (hintLevel != null) 'hint_level': hintLevel,
      if (hintRequestCount != null) 'hint_request_count': hintRequestCount,
      if (outOfScope != null) 'out_of_scope': outOfScope,
      if (explainMode != null) 'explain_mode': explainMode,
      if (difficulty != null) 'difficulty': difficulty,
      if (thetaAfter != null) 'theta_after': thetaAfter,
      if (masteryAfter != null) 'mastery_after': masteryAfter,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (source != null) 'source': source,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidenceEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? learnerId,
      Value<String>? nodeId,
      Value<String?>? itemId,
      Value<EvidenceKind>? kind,
      Value<double>? score,
      Value<double>? effectiveScore,
      Value<double>? predicted,
      Value<bool>? independent,
      Value<int>? hintLevel,
      Value<int>? hintRequestCount,
      Value<bool>? outOfScope,
      Value<bool>? explainMode,
      Value<double>? difficulty,
      Value<double>? thetaAfter,
      Value<double>? masteryAfter,
      Value<int?>? elapsedSeconds,
      Value<String>? source,
      Value<String>? payload,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EvidenceEventsCompanion(
      id: id ?? this.id,
      learnerId: learnerId ?? this.learnerId,
      nodeId: nodeId ?? this.nodeId,
      itemId: itemId ?? this.itemId,
      kind: kind ?? this.kind,
      score: score ?? this.score,
      effectiveScore: effectiveScore ?? this.effectiveScore,
      predicted: predicted ?? this.predicted,
      independent: independent ?? this.independent,
      hintLevel: hintLevel ?? this.hintLevel,
      hintRequestCount: hintRequestCount ?? this.hintRequestCount,
      outOfScope: outOfScope ?? this.outOfScope,
      explainMode: explainMode ?? this.explainMode,
      difficulty: difficulty ?? this.difficulty,
      thetaAfter: thetaAfter ?? this.thetaAfter,
      masteryAfter: masteryAfter ?? this.masteryAfter,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      source: source ?? this.source,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (learnerId.present) {
      map['learner_id'] = Variable<String>(learnerId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
          $EvidenceEventsTable.$converterkind.toSql(kind.value));
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (effectiveScore.present) {
      map['effective_score'] = Variable<double>(effectiveScore.value);
    }
    if (predicted.present) {
      map['predicted'] = Variable<double>(predicted.value);
    }
    if (independent.present) {
      map['independent'] = Variable<bool>(independent.value);
    }
    if (hintLevel.present) {
      map['hint_level'] = Variable<int>(hintLevel.value);
    }
    if (hintRequestCount.present) {
      map['hint_request_count'] = Variable<int>(hintRequestCount.value);
    }
    if (outOfScope.present) {
      map['out_of_scope'] = Variable<bool>(outOfScope.value);
    }
    if (explainMode.present) {
      map['explain_mode'] = Variable<bool>(explainMode.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (thetaAfter.present) {
      map['theta_after'] = Variable<double>(thetaAfter.value);
    }
    if (masteryAfter.present) {
      map['mastery_after'] = Variable<double>(masteryAfter.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceEventsCompanion(')
          ..write('id: $id, ')
          ..write('learnerId: $learnerId, ')
          ..write('nodeId: $nodeId, ')
          ..write('itemId: $itemId, ')
          ..write('kind: $kind, ')
          ..write('score: $score, ')
          ..write('effectiveScore: $effectiveScore, ')
          ..write('predicted: $predicted, ')
          ..write('independent: $independent, ')
          ..write('hintLevel: $hintLevel, ')
          ..write('hintRequestCount: $hintRequestCount, ')
          ..write('outOfScope: $outOfScope, ')
          ..write('explainMode: $explainMode, ')
          ..write('difficulty: $difficulty, ')
          ..write('thetaAfter: $thetaAfter, ')
          ..write('masteryAfter: $masteryAfter, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('source: $source, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NodeStatesTable extends NodeStates
    with TableInfo<$NodeStatesTable, NodeStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodeStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
      'node_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _learnerIdMeta =
      const VerificationMeta('learnerId');
  @override
  late final GeneratedColumn<String> learnerId = GeneratedColumn<String>(
      'learner_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  static const VerificationMeta _masteryMeta =
      const VerificationMeta('mastery');
  @override
  late final GeneratedColumn<double> mastery = GeneratedColumn<double>(
      'mastery', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _thetaMeta = const VerificationMeta('theta');
  @override
  late final GeneratedColumn<double> theta = GeneratedColumn<double>(
      'theta', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _independentAttemptsMeta =
      const VerificationMeta('independentAttempts');
  @override
  late final GeneratedColumn<int> independentAttempts = GeneratedColumn<int>(
      'independent_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _independentCorrectMeta =
      const VerificationMeta('independentCorrect');
  @override
  late final GeneratedColumn<int> independentCorrect = GeneratedColumn<int>(
      'independent_correct', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _assistedAttemptsMeta =
      const VerificationMeta('assistedAttempts');
  @override
  late final GeneratedColumn<int> assistedAttempts = GeneratedColumn<int>(
      'assisted_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _explainAttemptsMeta =
      const VerificationMeta('explainAttempts');
  @override
  late final GeneratedColumn<int> explainAttempts = GeneratedColumn<int>(
      'explain_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _engineVersionMeta =
      const VerificationMeta('engineVersion');
  @override
  late final GeneratedColumn<String> engineVersion = GeneratedColumn<String>(
      'engine_version', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1.0.0'));
  static const VerificationMeta _lastSeenAtMeta =
      const VerificationMeta('lastSeenAt');
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
      'last_seen_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        nodeId,
        learnerId,
        mastery,
        theta,
        attempts,
        independentAttempts,
        independentCorrect,
        assistedAttempts,
        explainAttempts,
        streak,
        engineVersion,
        lastSeenAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'node_states';
  @override
  VerificationContext validateIntegrity(Insertable<NodeStateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('learner_id')) {
      context.handle(_learnerIdMeta,
          learnerId.isAcceptableOrUnknown(data['learner_id']!, _learnerIdMeta));
    }
    if (data.containsKey('mastery')) {
      context.handle(_masteryMeta,
          mastery.isAcceptableOrUnknown(data['mastery']!, _masteryMeta));
    }
    if (data.containsKey('theta')) {
      context.handle(
          _thetaMeta, theta.isAcceptableOrUnknown(data['theta']!, _thetaMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('independent_attempts')) {
      context.handle(
          _independentAttemptsMeta,
          independentAttempts.isAcceptableOrUnknown(
              data['independent_attempts']!, _independentAttemptsMeta));
    }
    if (data.containsKey('independent_correct')) {
      context.handle(
          _independentCorrectMeta,
          independentCorrect.isAcceptableOrUnknown(
              data['independent_correct']!, _independentCorrectMeta));
    }
    if (data.containsKey('assisted_attempts')) {
      context.handle(
          _assistedAttemptsMeta,
          assistedAttempts.isAcceptableOrUnknown(
              data['assisted_attempts']!, _assistedAttemptsMeta));
    }
    if (data.containsKey('explain_attempts')) {
      context.handle(
          _explainAttemptsMeta,
          explainAttempts.isAcceptableOrUnknown(
              data['explain_attempts']!, _explainAttemptsMeta));
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    }
    if (data.containsKey('engine_version')) {
      context.handle(
          _engineVersionMeta,
          engineVersion.isAcceptableOrUnknown(
              data['engine_version']!, _engineVersionMeta));
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
          _lastSeenAtMeta,
          lastSeenAt.isAcceptableOrUnknown(
              data['last_seen_at']!, _lastSeenAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {nodeId};
  @override
  NodeStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NodeStateRow(
      nodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_id'])!,
      learnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}learner_id'])!,
      mastery: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mastery'])!,
      theta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}theta'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      independentAttempts: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}independent_attempts'])!,
      independentCorrect: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}independent_correct'])!,
      assistedAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}assisted_attempts'])!,
      explainAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}explain_attempts'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      engineVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}engine_version'])!,
      lastSeenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_seen_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NodeStatesTable createAlias(String alias) {
    return $NodeStatesTable(attachedDatabase, alias);
  }
}

class NodeStateRow extends DataClass implements Insertable<NodeStateRow> {
  final String nodeId;
  final String learnerId;
  final double mastery;
  final double theta;
  final int attempts;
  final int independentAttempts;
  final int independentCorrect;
  final int assistedAttempts;
  final int explainAttempts;
  final int streak;
  final String engineVersion;
  final DateTime? lastSeenAt;
  final DateTime updatedAt;
  const NodeStateRow(
      {required this.nodeId,
      required this.learnerId,
      required this.mastery,
      required this.theta,
      required this.attempts,
      required this.independentAttempts,
      required this.independentCorrect,
      required this.assistedAttempts,
      required this.explainAttempts,
      required this.streak,
      required this.engineVersion,
      this.lastSeenAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['node_id'] = Variable<String>(nodeId);
    map['learner_id'] = Variable<String>(learnerId);
    map['mastery'] = Variable<double>(mastery);
    map['theta'] = Variable<double>(theta);
    map['attempts'] = Variable<int>(attempts);
    map['independent_attempts'] = Variable<int>(independentAttempts);
    map['independent_correct'] = Variable<int>(independentCorrect);
    map['assisted_attempts'] = Variable<int>(assistedAttempts);
    map['explain_attempts'] = Variable<int>(explainAttempts);
    map['streak'] = Variable<int>(streak);
    map['engine_version'] = Variable<String>(engineVersion);
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NodeStatesCompanion toCompanion(bool nullToAbsent) {
    return NodeStatesCompanion(
      nodeId: Value(nodeId),
      learnerId: Value(learnerId),
      mastery: Value(mastery),
      theta: Value(theta),
      attempts: Value(attempts),
      independentAttempts: Value(independentAttempts),
      independentCorrect: Value(independentCorrect),
      assistedAttempts: Value(assistedAttempts),
      explainAttempts: Value(explainAttempts),
      streak: Value(streak),
      engineVersion: Value(engineVersion),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NodeStateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeStateRow(
      nodeId: serializer.fromJson<String>(json['nodeId']),
      learnerId: serializer.fromJson<String>(json['learnerId']),
      mastery: serializer.fromJson<double>(json['mastery']),
      theta: serializer.fromJson<double>(json['theta']),
      attempts: serializer.fromJson<int>(json['attempts']),
      independentAttempts:
          serializer.fromJson<int>(json['independentAttempts']),
      independentCorrect: serializer.fromJson<int>(json['independentCorrect']),
      assistedAttempts: serializer.fromJson<int>(json['assistedAttempts']),
      explainAttempts: serializer.fromJson<int>(json['explainAttempts']),
      streak: serializer.fromJson<int>(json['streak']),
      engineVersion: serializer.fromJson<String>(json['engineVersion']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'nodeId': serializer.toJson<String>(nodeId),
      'learnerId': serializer.toJson<String>(learnerId),
      'mastery': serializer.toJson<double>(mastery),
      'theta': serializer.toJson<double>(theta),
      'attempts': serializer.toJson<int>(attempts),
      'independentAttempts': serializer.toJson<int>(independentAttempts),
      'independentCorrect': serializer.toJson<int>(independentCorrect),
      'assistedAttempts': serializer.toJson<int>(assistedAttempts),
      'explainAttempts': serializer.toJson<int>(explainAttempts),
      'streak': serializer.toJson<int>(streak),
      'engineVersion': serializer.toJson<String>(engineVersion),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NodeStateRow copyWith(
          {String? nodeId,
          String? learnerId,
          double? mastery,
          double? theta,
          int? attempts,
          int? independentAttempts,
          int? independentCorrect,
          int? assistedAttempts,
          int? explainAttempts,
          int? streak,
          String? engineVersion,
          Value<DateTime?> lastSeenAt = const Value.absent(),
          DateTime? updatedAt}) =>
      NodeStateRow(
        nodeId: nodeId ?? this.nodeId,
        learnerId: learnerId ?? this.learnerId,
        mastery: mastery ?? this.mastery,
        theta: theta ?? this.theta,
        attempts: attempts ?? this.attempts,
        independentAttempts: independentAttempts ?? this.independentAttempts,
        independentCorrect: independentCorrect ?? this.independentCorrect,
        assistedAttempts: assistedAttempts ?? this.assistedAttempts,
        explainAttempts: explainAttempts ?? this.explainAttempts,
        streak: streak ?? this.streak,
        engineVersion: engineVersion ?? this.engineVersion,
        lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NodeStateRow copyWithCompanion(NodeStatesCompanion data) {
    return NodeStateRow(
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      learnerId: data.learnerId.present ? data.learnerId.value : this.learnerId,
      mastery: data.mastery.present ? data.mastery.value : this.mastery,
      theta: data.theta.present ? data.theta.value : this.theta,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      independentAttempts: data.independentAttempts.present
          ? data.independentAttempts.value
          : this.independentAttempts,
      independentCorrect: data.independentCorrect.present
          ? data.independentCorrect.value
          : this.independentCorrect,
      assistedAttempts: data.assistedAttempts.present
          ? data.assistedAttempts.value
          : this.assistedAttempts,
      explainAttempts: data.explainAttempts.present
          ? data.explainAttempts.value
          : this.explainAttempts,
      streak: data.streak.present ? data.streak.value : this.streak,
      engineVersion: data.engineVersion.present
          ? data.engineVersion.value
          : this.engineVersion,
      lastSeenAt:
          data.lastSeenAt.present ? data.lastSeenAt.value : this.lastSeenAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NodeStateRow(')
          ..write('nodeId: $nodeId, ')
          ..write('learnerId: $learnerId, ')
          ..write('mastery: $mastery, ')
          ..write('theta: $theta, ')
          ..write('attempts: $attempts, ')
          ..write('independentAttempts: $independentAttempts, ')
          ..write('independentCorrect: $independentCorrect, ')
          ..write('assistedAttempts: $assistedAttempts, ')
          ..write('explainAttempts: $explainAttempts, ')
          ..write('streak: $streak, ')
          ..write('engineVersion: $engineVersion, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      nodeId,
      learnerId,
      mastery,
      theta,
      attempts,
      independentAttempts,
      independentCorrect,
      assistedAttempts,
      explainAttempts,
      streak,
      engineVersion,
      lastSeenAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeStateRow &&
          other.nodeId == this.nodeId &&
          other.learnerId == this.learnerId &&
          other.mastery == this.mastery &&
          other.theta == this.theta &&
          other.attempts == this.attempts &&
          other.independentAttempts == this.independentAttempts &&
          other.independentCorrect == this.independentCorrect &&
          other.assistedAttempts == this.assistedAttempts &&
          other.explainAttempts == this.explainAttempts &&
          other.streak == this.streak &&
          other.engineVersion == this.engineVersion &&
          other.lastSeenAt == this.lastSeenAt &&
          other.updatedAt == this.updatedAt);
}

class NodeStatesCompanion extends UpdateCompanion<NodeStateRow> {
  final Value<String> nodeId;
  final Value<String> learnerId;
  final Value<double> mastery;
  final Value<double> theta;
  final Value<int> attempts;
  final Value<int> independentAttempts;
  final Value<int> independentCorrect;
  final Value<int> assistedAttempts;
  final Value<int> explainAttempts;
  final Value<int> streak;
  final Value<String> engineVersion;
  final Value<DateTime?> lastSeenAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NodeStatesCompanion({
    this.nodeId = const Value.absent(),
    this.learnerId = const Value.absent(),
    this.mastery = const Value.absent(),
    this.theta = const Value.absent(),
    this.attempts = const Value.absent(),
    this.independentAttempts = const Value.absent(),
    this.independentCorrect = const Value.absent(),
    this.assistedAttempts = const Value.absent(),
    this.explainAttempts = const Value.absent(),
    this.streak = const Value.absent(),
    this.engineVersion = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodeStatesCompanion.insert({
    required String nodeId,
    this.learnerId = const Value.absent(),
    this.mastery = const Value.absent(),
    this.theta = const Value.absent(),
    this.attempts = const Value.absent(),
    this.independentAttempts = const Value.absent(),
    this.independentCorrect = const Value.absent(),
    this.assistedAttempts = const Value.absent(),
    this.explainAttempts = const Value.absent(),
    this.streak = const Value.absent(),
    this.engineVersion = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : nodeId = Value(nodeId),
        updatedAt = Value(updatedAt);
  static Insertable<NodeStateRow> custom({
    Expression<String>? nodeId,
    Expression<String>? learnerId,
    Expression<double>? mastery,
    Expression<double>? theta,
    Expression<int>? attempts,
    Expression<int>? independentAttempts,
    Expression<int>? independentCorrect,
    Expression<int>? assistedAttempts,
    Expression<int>? explainAttempts,
    Expression<int>? streak,
    Expression<String>? engineVersion,
    Expression<DateTime>? lastSeenAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (nodeId != null) 'node_id': nodeId,
      if (learnerId != null) 'learner_id': learnerId,
      if (mastery != null) 'mastery': mastery,
      if (theta != null) 'theta': theta,
      if (attempts != null) 'attempts': attempts,
      if (independentAttempts != null)
        'independent_attempts': independentAttempts,
      if (independentCorrect != null) 'independent_correct': independentCorrect,
      if (assistedAttempts != null) 'assisted_attempts': assistedAttempts,
      if (explainAttempts != null) 'explain_attempts': explainAttempts,
      if (streak != null) 'streak': streak,
      if (engineVersion != null) 'engine_version': engineVersion,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodeStatesCompanion copyWith(
      {Value<String>? nodeId,
      Value<String>? learnerId,
      Value<double>? mastery,
      Value<double>? theta,
      Value<int>? attempts,
      Value<int>? independentAttempts,
      Value<int>? independentCorrect,
      Value<int>? assistedAttempts,
      Value<int>? explainAttempts,
      Value<int>? streak,
      Value<String>? engineVersion,
      Value<DateTime?>? lastSeenAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return NodeStatesCompanion(
      nodeId: nodeId ?? this.nodeId,
      learnerId: learnerId ?? this.learnerId,
      mastery: mastery ?? this.mastery,
      theta: theta ?? this.theta,
      attempts: attempts ?? this.attempts,
      independentAttempts: independentAttempts ?? this.independentAttempts,
      independentCorrect: independentCorrect ?? this.independentCorrect,
      assistedAttempts: assistedAttempts ?? this.assistedAttempts,
      explainAttempts: explainAttempts ?? this.explainAttempts,
      streak: streak ?? this.streak,
      engineVersion: engineVersion ?? this.engineVersion,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (learnerId.present) {
      map['learner_id'] = Variable<String>(learnerId.value);
    }
    if (mastery.present) {
      map['mastery'] = Variable<double>(mastery.value);
    }
    if (theta.present) {
      map['theta'] = Variable<double>(theta.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (independentAttempts.present) {
      map['independent_attempts'] = Variable<int>(independentAttempts.value);
    }
    if (independentCorrect.present) {
      map['independent_correct'] = Variable<int>(independentCorrect.value);
    }
    if (assistedAttempts.present) {
      map['assisted_attempts'] = Variable<int>(assistedAttempts.value);
    }
    if (explainAttempts.present) {
      map['explain_attempts'] = Variable<int>(explainAttempts.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (engineVersion.present) {
      map['engine_version'] = Variable<String>(engineVersion.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeStatesCompanion(')
          ..write('nodeId: $nodeId, ')
          ..write('learnerId: $learnerId, ')
          ..write('mastery: $mastery, ')
          ..write('theta: $theta, ')
          ..write('attempts: $attempts, ')
          ..write('independentAttempts: $independentAttempts, ')
          ..write('independentCorrect: $independentCorrect, ')
          ..write('assistedAttempts: $assistedAttempts, ')
          ..write('explainAttempts: $explainAttempts, ')
          ..write('streak: $streak, ')
          ..write('engineVersion: $engineVersion, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemDifficultyTable extends ItemDifficulty
    with TableInfo<$ItemDifficultyTable, ItemDifficultyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemDifficultyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
      'node_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discriminationMeta =
      const VerificationMeta('discrimination');
  @override
  late final GeneratedColumn<double> discrimination = GeneratedColumn<double>(
      'discrimination', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _exposureMeta =
      const VerificationMeta('exposure');
  @override
  late final GeneratedColumn<int> exposure = GeneratedColumn<int>(
      'exposure', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctCountMeta =
      const VerificationMeta('correctCount');
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
      'correct_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        itemId,
        nodeId,
        difficulty,
        discrimination,
        exposure,
        correctCount,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_difficulty';
  @override
  VerificationContext validateIntegrity(Insertable<ItemDifficultyRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('discrimination')) {
      context.handle(
          _discriminationMeta,
          discrimination.isAcceptableOrUnknown(
              data['discrimination']!, _discriminationMeta));
    }
    if (data.containsKey('exposure')) {
      context.handle(_exposureMeta,
          exposure.isAcceptableOrUnknown(data['exposure']!, _exposureMeta));
    }
    if (data.containsKey('correct_count')) {
      context.handle(
          _correctCountMeta,
          correctCount.isAcceptableOrUnknown(
              data['correct_count']!, _correctCountMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  ItemDifficultyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemDifficultyRow(
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      nodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_id'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difficulty'])!,
      discrimination: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discrimination'])!,
      exposure: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exposure'])!,
      correctCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_count'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ItemDifficultyTable createAlias(String alias) {
    return $ItemDifficultyTable(attachedDatabase, alias);
  }
}

class ItemDifficultyRow extends DataClass
    implements Insertable<ItemDifficultyRow> {
  final String itemId;
  final String nodeId;
  final double difficulty;
  final double discrimination;
  final int exposure;
  final int correctCount;
  final DateTime updatedAt;
  const ItemDifficultyRow(
      {required this.itemId,
      required this.nodeId,
      required this.difficulty,
      required this.discrimination,
      required this.exposure,
      required this.correctCount,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['node_id'] = Variable<String>(nodeId);
    map['difficulty'] = Variable<double>(difficulty);
    map['discrimination'] = Variable<double>(discrimination);
    map['exposure'] = Variable<int>(exposure);
    map['correct_count'] = Variable<int>(correctCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ItemDifficultyCompanion toCompanion(bool nullToAbsent) {
    return ItemDifficultyCompanion(
      itemId: Value(itemId),
      nodeId: Value(nodeId),
      difficulty: Value(difficulty),
      discrimination: Value(discrimination),
      exposure: Value(exposure),
      correctCount: Value(correctCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory ItemDifficultyRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemDifficultyRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      discrimination: serializer.fromJson<double>(json['discrimination']),
      exposure: serializer.fromJson<int>(json['exposure']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'nodeId': serializer.toJson<String>(nodeId),
      'difficulty': serializer.toJson<double>(difficulty),
      'discrimination': serializer.toJson<double>(discrimination),
      'exposure': serializer.toJson<int>(exposure),
      'correctCount': serializer.toJson<int>(correctCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ItemDifficultyRow copyWith(
          {String? itemId,
          String? nodeId,
          double? difficulty,
          double? discrimination,
          int? exposure,
          int? correctCount,
          DateTime? updatedAt}) =>
      ItemDifficultyRow(
        itemId: itemId ?? this.itemId,
        nodeId: nodeId ?? this.nodeId,
        difficulty: difficulty ?? this.difficulty,
        discrimination: discrimination ?? this.discrimination,
        exposure: exposure ?? this.exposure,
        correctCount: correctCount ?? this.correctCount,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ItemDifficultyRow copyWithCompanion(ItemDifficultyCompanion data) {
    return ItemDifficultyRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      discrimination: data.discrimination.present
          ? data.discrimination.value
          : this.discrimination,
      exposure: data.exposure.present ? data.exposure.value : this.exposure,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemDifficultyRow(')
          ..write('itemId: $itemId, ')
          ..write('nodeId: $nodeId, ')
          ..write('difficulty: $difficulty, ')
          ..write('discrimination: $discrimination, ')
          ..write('exposure: $exposure, ')
          ..write('correctCount: $correctCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, nodeId, difficulty, discrimination,
      exposure, correctCount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemDifficultyRow &&
          other.itemId == this.itemId &&
          other.nodeId == this.nodeId &&
          other.difficulty == this.difficulty &&
          other.discrimination == this.discrimination &&
          other.exposure == this.exposure &&
          other.correctCount == this.correctCount &&
          other.updatedAt == this.updatedAt);
}

class ItemDifficultyCompanion extends UpdateCompanion<ItemDifficultyRow> {
  final Value<String> itemId;
  final Value<String> nodeId;
  final Value<double> difficulty;
  final Value<double> discrimination;
  final Value<int> exposure;
  final Value<int> correctCount;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ItemDifficultyCompanion({
    this.itemId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.discrimination = const Value.absent(),
    this.exposure = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemDifficultyCompanion.insert({
    required String itemId,
    required String nodeId,
    this.difficulty = const Value.absent(),
    this.discrimination = const Value.absent(),
    this.exposure = const Value.absent(),
    this.correctCount = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : itemId = Value(itemId),
        nodeId = Value(nodeId),
        updatedAt = Value(updatedAt);
  static Insertable<ItemDifficultyRow> custom({
    Expression<String>? itemId,
    Expression<String>? nodeId,
    Expression<double>? difficulty,
    Expression<double>? discrimination,
    Expression<int>? exposure,
    Expression<int>? correctCount,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (nodeId != null) 'node_id': nodeId,
      if (difficulty != null) 'difficulty': difficulty,
      if (discrimination != null) 'discrimination': discrimination,
      if (exposure != null) 'exposure': exposure,
      if (correctCount != null) 'correct_count': correctCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemDifficultyCompanion copyWith(
      {Value<String>? itemId,
      Value<String>? nodeId,
      Value<double>? difficulty,
      Value<double>? discrimination,
      Value<int>? exposure,
      Value<int>? correctCount,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ItemDifficultyCompanion(
      itemId: itemId ?? this.itemId,
      nodeId: nodeId ?? this.nodeId,
      difficulty: difficulty ?? this.difficulty,
      discrimination: discrimination ?? this.discrimination,
      exposure: exposure ?? this.exposure,
      correctCount: correctCount ?? this.correctCount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (discrimination.present) {
      map['discrimination'] = Variable<double>(discrimination.value);
    }
    if (exposure.present) {
      map['exposure'] = Variable<int>(exposure.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemDifficultyCompanion(')
          ..write('itemId: $itemId, ')
          ..write('nodeId: $nodeId, ')
          ..write('difficulty: $difficulty, ')
          ..write('discrimination: $discrimination, ')
          ..write('exposure: $exposure, ')
          ..write('correctCount: $correctCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VocabStatesTable extends VocabStates
    with TableInfo<$VocabStatesTable, VocabStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
      'word_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
      'lemma', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _readingMeta =
      const VerificationMeta('reading');
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
      'reading', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _glossMeta = const VerificationMeta('gloss');
  @override
  late final GeneratedColumn<String> gloss = GeneratedColumn<String>(
      'gloss', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _dimensionMeta =
      const VerificationMeta('dimension');
  @override
  late final GeneratedColumn<String> dimension = GeneratedColumn<String>(
      'dimension', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('reading'));
  static const VerificationMeta _clusterIdMeta =
      const VerificationMeta('clusterId');
  @override
  late final GeneratedColumn<String> clusterId = GeneratedColumn<String>(
      'cluster_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _boxMeta = const VerificationMeta('box');
  @override
  late final GeneratedColumn<int> box = GeneratedColumn<int>(
      'box', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _easeMeta = const VerificationMeta('ease');
  @override
  late final GeneratedColumn<double> ease = GeneratedColumn<double>(
      'ease', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
      'lapses', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastRatingMeta =
      const VerificationMeta('lastRating');
  @override
  late final GeneratedColumn<int> lastRating = GeneratedColumn<int>(
      'last_rating', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        wordId,
        lemma,
        reading,
        gloss,
        dimension,
        clusterId,
        box,
        ease,
        reps,
        lapses,
        lastRating,
        dueAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocab_states';
  @override
  VerificationContext validateIntegrity(Insertable<VocabStateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('lemma')) {
      context.handle(
          _lemmaMeta, lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta));
    } else if (isInserting) {
      context.missing(_lemmaMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(_readingMeta,
          reading.isAcceptableOrUnknown(data['reading']!, _readingMeta));
    }
    if (data.containsKey('gloss')) {
      context.handle(
          _glossMeta, gloss.isAcceptableOrUnknown(data['gloss']!, _glossMeta));
    }
    if (data.containsKey('dimension')) {
      context.handle(_dimensionMeta,
          dimension.isAcceptableOrUnknown(data['dimension']!, _dimensionMeta));
    }
    if (data.containsKey('cluster_id')) {
      context.handle(_clusterIdMeta,
          clusterId.isAcceptableOrUnknown(data['cluster_id']!, _clusterIdMeta));
    }
    if (data.containsKey('box')) {
      context.handle(
          _boxMeta, box.isAcceptableOrUnknown(data['box']!, _boxMeta));
    }
    if (data.containsKey('ease')) {
      context.handle(
          _easeMeta, ease.isAcceptableOrUnknown(data['ease']!, _easeMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('lapses')) {
      context.handle(_lapsesMeta,
          lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta));
    }
    if (data.containsKey('last_rating')) {
      context.handle(
          _lastRatingMeta,
          lastRating.isAcceptableOrUnknown(
              data['last_rating']!, _lastRatingMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  VocabStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabStateRow(
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_id'])!,
      lemma: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lemma'])!,
      reading: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reading'])!,
      gloss: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gloss'])!,
      dimension: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dimension'])!,
      clusterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cluster_id'])!,
      box: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}box'])!,
      ease: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      lapses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lapses'])!,
      lastRating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_rating'])!,
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $VocabStatesTable createAlias(String alias) {
    return $VocabStatesTable(attachedDatabase, alias);
  }
}

class VocabStateRow extends DataClass implements Insertable<VocabStateRow> {
  final String wordId;
  final String lemma;
  final String reading;
  final String gloss;
  final String dimension;
  final String clusterId;
  final int box;
  final double ease;
  final int reps;
  final int lapses;
  final int lastRating;
  final DateTime dueAt;
  final DateTime createdAt;
  const VocabStateRow(
      {required this.wordId,
      required this.lemma,
      required this.reading,
      required this.gloss,
      required this.dimension,
      required this.clusterId,
      required this.box,
      required this.ease,
      required this.reps,
      required this.lapses,
      required this.lastRating,
      required this.dueAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['lemma'] = Variable<String>(lemma);
    map['reading'] = Variable<String>(reading);
    map['gloss'] = Variable<String>(gloss);
    map['dimension'] = Variable<String>(dimension);
    map['cluster_id'] = Variable<String>(clusterId);
    map['box'] = Variable<int>(box);
    map['ease'] = Variable<double>(ease);
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    map['last_rating'] = Variable<int>(lastRating);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VocabStatesCompanion toCompanion(bool nullToAbsent) {
    return VocabStatesCompanion(
      wordId: Value(wordId),
      lemma: Value(lemma),
      reading: Value(reading),
      gloss: Value(gloss),
      dimension: Value(dimension),
      clusterId: Value(clusterId),
      box: Value(box),
      ease: Value(ease),
      reps: Value(reps),
      lapses: Value(lapses),
      lastRating: Value(lastRating),
      dueAt: Value(dueAt),
      createdAt: Value(createdAt),
    );
  }

  factory VocabStateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabStateRow(
      wordId: serializer.fromJson<String>(json['wordId']),
      lemma: serializer.fromJson<String>(json['lemma']),
      reading: serializer.fromJson<String>(json['reading']),
      gloss: serializer.fromJson<String>(json['gloss']),
      dimension: serializer.fromJson<String>(json['dimension']),
      clusterId: serializer.fromJson<String>(json['clusterId']),
      box: serializer.fromJson<int>(json['box']),
      ease: serializer.fromJson<double>(json['ease']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      lastRating: serializer.fromJson<int>(json['lastRating']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'lemma': serializer.toJson<String>(lemma),
      'reading': serializer.toJson<String>(reading),
      'gloss': serializer.toJson<String>(gloss),
      'dimension': serializer.toJson<String>(dimension),
      'clusterId': serializer.toJson<String>(clusterId),
      'box': serializer.toJson<int>(box),
      'ease': serializer.toJson<double>(ease),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'lastRating': serializer.toJson<int>(lastRating),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VocabStateRow copyWith(
          {String? wordId,
          String? lemma,
          String? reading,
          String? gloss,
          String? dimension,
          String? clusterId,
          int? box,
          double? ease,
          int? reps,
          int? lapses,
          int? lastRating,
          DateTime? dueAt,
          DateTime? createdAt}) =>
      VocabStateRow(
        wordId: wordId ?? this.wordId,
        lemma: lemma ?? this.lemma,
        reading: reading ?? this.reading,
        gloss: gloss ?? this.gloss,
        dimension: dimension ?? this.dimension,
        clusterId: clusterId ?? this.clusterId,
        box: box ?? this.box,
        ease: ease ?? this.ease,
        reps: reps ?? this.reps,
        lapses: lapses ?? this.lapses,
        lastRating: lastRating ?? this.lastRating,
        dueAt: dueAt ?? this.dueAt,
        createdAt: createdAt ?? this.createdAt,
      );
  VocabStateRow copyWithCompanion(VocabStatesCompanion data) {
    return VocabStateRow(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      reading: data.reading.present ? data.reading.value : this.reading,
      gloss: data.gloss.present ? data.gloss.value : this.gloss,
      dimension: data.dimension.present ? data.dimension.value : this.dimension,
      clusterId: data.clusterId.present ? data.clusterId.value : this.clusterId,
      box: data.box.present ? data.box.value : this.box,
      ease: data.ease.present ? data.ease.value : this.ease,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      lastRating:
          data.lastRating.present ? data.lastRating.value : this.lastRating,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabStateRow(')
          ..write('wordId: $wordId, ')
          ..write('lemma: $lemma, ')
          ..write('reading: $reading, ')
          ..write('gloss: $gloss, ')
          ..write('dimension: $dimension, ')
          ..write('clusterId: $clusterId, ')
          ..write('box: $box, ')
          ..write('ease: $ease, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastRating: $lastRating, ')
          ..write('dueAt: $dueAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, lemma, reading, gloss, dimension,
      clusterId, box, ease, reps, lapses, lastRating, dueAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabStateRow &&
          other.wordId == this.wordId &&
          other.lemma == this.lemma &&
          other.reading == this.reading &&
          other.gloss == this.gloss &&
          other.dimension == this.dimension &&
          other.clusterId == this.clusterId &&
          other.box == this.box &&
          other.ease == this.ease &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.lastRating == this.lastRating &&
          other.dueAt == this.dueAt &&
          other.createdAt == this.createdAt);
}

class VocabStatesCompanion extends UpdateCompanion<VocabStateRow> {
  final Value<String> wordId;
  final Value<String> lemma;
  final Value<String> reading;
  final Value<String> gloss;
  final Value<String> dimension;
  final Value<String> clusterId;
  final Value<int> box;
  final Value<double> ease;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<int> lastRating;
  final Value<DateTime> dueAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VocabStatesCompanion({
    this.wordId = const Value.absent(),
    this.lemma = const Value.absent(),
    this.reading = const Value.absent(),
    this.gloss = const Value.absent(),
    this.dimension = const Value.absent(),
    this.clusterId = const Value.absent(),
    this.box = const Value.absent(),
    this.ease = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastRating = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabStatesCompanion.insert({
    required String wordId,
    required String lemma,
    this.reading = const Value.absent(),
    this.gloss = const Value.absent(),
    this.dimension = const Value.absent(),
    this.clusterId = const Value.absent(),
    this.box = const Value.absent(),
    this.ease = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastRating = const Value.absent(),
    required DateTime dueAt,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : wordId = Value(wordId),
        lemma = Value(lemma),
        dueAt = Value(dueAt),
        createdAt = Value(createdAt);
  static Insertable<VocabStateRow> custom({
    Expression<String>? wordId,
    Expression<String>? lemma,
    Expression<String>? reading,
    Expression<String>? gloss,
    Expression<String>? dimension,
    Expression<String>? clusterId,
    Expression<int>? box,
    Expression<double>? ease,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<int>? lastRating,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (lemma != null) 'lemma': lemma,
      if (reading != null) 'reading': reading,
      if (gloss != null) 'gloss': gloss,
      if (dimension != null) 'dimension': dimension,
      if (clusterId != null) 'cluster_id': clusterId,
      if (box != null) 'box': box,
      if (ease != null) 'ease': ease,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (lastRating != null) 'last_rating': lastRating,
      if (dueAt != null) 'due_at': dueAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabStatesCompanion copyWith(
      {Value<String>? wordId,
      Value<String>? lemma,
      Value<String>? reading,
      Value<String>? gloss,
      Value<String>? dimension,
      Value<String>? clusterId,
      Value<int>? box,
      Value<double>? ease,
      Value<int>? reps,
      Value<int>? lapses,
      Value<int>? lastRating,
      Value<DateTime>? dueAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return VocabStatesCompanion(
      wordId: wordId ?? this.wordId,
      lemma: lemma ?? this.lemma,
      reading: reading ?? this.reading,
      gloss: gloss ?? this.gloss,
      dimension: dimension ?? this.dimension,
      clusterId: clusterId ?? this.clusterId,
      box: box ?? this.box,
      ease: ease ?? this.ease,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      lastRating: lastRating ?? this.lastRating,
      dueAt: dueAt ?? this.dueAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (gloss.present) {
      map['gloss'] = Variable<String>(gloss.value);
    }
    if (dimension.present) {
      map['dimension'] = Variable<String>(dimension.value);
    }
    if (clusterId.present) {
      map['cluster_id'] = Variable<String>(clusterId.value);
    }
    if (box.present) {
      map['box'] = Variable<int>(box.value);
    }
    if (ease.present) {
      map['ease'] = Variable<double>(ease.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (lastRating.present) {
      map['last_rating'] = Variable<int>(lastRating.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabStatesCompanion(')
          ..write('wordId: $wordId, ')
          ..write('lemma: $lemma, ')
          ..write('reading: $reading, ')
          ..write('gloss: $gloss, ')
          ..write('dimension: $dimension, ')
          ..write('clusterId: $clusterId, ')
          ..write('box: $box, ')
          ..write('ease: $ease, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastRating: $lastRating, ')
          ..write('dueAt: $dueAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementStatesTable extends AchievementStates
    with TableInfo<$AchievementStatesTable, AchievementStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _achievementIdMeta =
      const VerificationMeta('achievementId');
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
      'achievement_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
      'tier', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('none'));
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
      'progress', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _independentMeta =
      const VerificationMeta('independent');
  @override
  late final GeneratedColumn<bool> independent = GeneratedColumn<bool>(
      'independent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("independent" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _xpAwardedMeta =
      const VerificationMeta('xpAwarded');
  @override
  late final GeneratedColumn<int> xpAwarded = GeneratedColumn<int>(
      'xp_awarded', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        achievementId,
        tier,
        progress,
        independent,
        xpAwarded,
        unlockedAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievement_states';
  @override
  VerificationContext validateIntegrity(
      Insertable<AchievementStateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('achievement_id')) {
      context.handle(
          _achievementIdMeta,
          achievementId.isAcceptableOrUnknown(
              data['achievement_id']!, _achievementIdMeta));
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
          _tierMeta, tier.isAcceptableOrUnknown(data['tier']!, _tierMeta));
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('independent')) {
      context.handle(
          _independentMeta,
          independent.isAcceptableOrUnknown(
              data['independent']!, _independentMeta));
    }
    if (data.containsKey('xp_awarded')) {
      context.handle(_xpAwardedMeta,
          xpAwarded.isAcceptableOrUnknown(data['xp_awarded']!, _xpAwardedMeta));
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {achievementId};
  @override
  AchievementStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementStateRow(
      achievementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}achievement_id'])!,
      tier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tier'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}progress'])!,
      independent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}independent'])!,
      xpAwarded: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_awarded'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AchievementStatesTable createAlias(String alias) {
    return $AchievementStatesTable(attachedDatabase, alias);
  }
}

class AchievementStateRow extends DataClass
    implements Insertable<AchievementStateRow> {
  final String achievementId;
  final String tier;
  final double progress;
  final bool independent;
  final int xpAwarded;
  final DateTime? unlockedAt;
  final DateTime updatedAt;
  const AchievementStateRow(
      {required this.achievementId,
      required this.tier,
      required this.progress,
      required this.independent,
      required this.xpAwarded,
      this.unlockedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['achievement_id'] = Variable<String>(achievementId);
    map['tier'] = Variable<String>(tier);
    map['progress'] = Variable<double>(progress);
    map['independent'] = Variable<bool>(independent);
    map['xp_awarded'] = Variable<int>(xpAwarded);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AchievementStatesCompanion toCompanion(bool nullToAbsent) {
    return AchievementStatesCompanion(
      achievementId: Value(achievementId),
      tier: Value(tier),
      progress: Value(progress),
      independent: Value(independent),
      xpAwarded: Value(xpAwarded),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AchievementStateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementStateRow(
      achievementId: serializer.fromJson<String>(json['achievementId']),
      tier: serializer.fromJson<String>(json['tier']),
      progress: serializer.fromJson<double>(json['progress']),
      independent: serializer.fromJson<bool>(json['independent']),
      xpAwarded: serializer.fromJson<int>(json['xpAwarded']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'achievementId': serializer.toJson<String>(achievementId),
      'tier': serializer.toJson<String>(tier),
      'progress': serializer.toJson<double>(progress),
      'independent': serializer.toJson<bool>(independent),
      'xpAwarded': serializer.toJson<int>(xpAwarded),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AchievementStateRow copyWith(
          {String? achievementId,
          String? tier,
          double? progress,
          bool? independent,
          int? xpAwarded,
          Value<DateTime?> unlockedAt = const Value.absent(),
          DateTime? updatedAt}) =>
      AchievementStateRow(
        achievementId: achievementId ?? this.achievementId,
        tier: tier ?? this.tier,
        progress: progress ?? this.progress,
        independent: independent ?? this.independent,
        xpAwarded: xpAwarded ?? this.xpAwarded,
        unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AchievementStateRow copyWithCompanion(AchievementStatesCompanion data) {
    return AchievementStateRow(
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      tier: data.tier.present ? data.tier.value : this.tier,
      progress: data.progress.present ? data.progress.value : this.progress,
      independent:
          data.independent.present ? data.independent.value : this.independent,
      xpAwarded: data.xpAwarded.present ? data.xpAwarded.value : this.xpAwarded,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementStateRow(')
          ..write('achievementId: $achievementId, ')
          ..write('tier: $tier, ')
          ..write('progress: $progress, ')
          ..write('independent: $independent, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(achievementId, tier, progress, independent,
      xpAwarded, unlockedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementStateRow &&
          other.achievementId == this.achievementId &&
          other.tier == this.tier &&
          other.progress == this.progress &&
          other.independent == this.independent &&
          other.xpAwarded == this.xpAwarded &&
          other.unlockedAt == this.unlockedAt &&
          other.updatedAt == this.updatedAt);
}

class AchievementStatesCompanion extends UpdateCompanion<AchievementStateRow> {
  final Value<String> achievementId;
  final Value<String> tier;
  final Value<double> progress;
  final Value<bool> independent;
  final Value<int> xpAwarded;
  final Value<DateTime?> unlockedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AchievementStatesCompanion({
    this.achievementId = const Value.absent(),
    this.tier = const Value.absent(),
    this.progress = const Value.absent(),
    this.independent = const Value.absent(),
    this.xpAwarded = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementStatesCompanion.insert({
    required String achievementId,
    this.tier = const Value.absent(),
    this.progress = const Value.absent(),
    this.independent = const Value.absent(),
    this.xpAwarded = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : achievementId = Value(achievementId),
        updatedAt = Value(updatedAt);
  static Insertable<AchievementStateRow> custom({
    Expression<String>? achievementId,
    Expression<String>? tier,
    Expression<double>? progress,
    Expression<bool>? independent,
    Expression<int>? xpAwarded,
    Expression<DateTime>? unlockedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (achievementId != null) 'achievement_id': achievementId,
      if (tier != null) 'tier': tier,
      if (progress != null) 'progress': progress,
      if (independent != null) 'independent': independent,
      if (xpAwarded != null) 'xp_awarded': xpAwarded,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementStatesCompanion copyWith(
      {Value<String>? achievementId,
      Value<String>? tier,
      Value<double>? progress,
      Value<bool>? independent,
      Value<int>? xpAwarded,
      Value<DateTime?>? unlockedAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AchievementStatesCompanion(
      achievementId: achievementId ?? this.achievementId,
      tier: tier ?? this.tier,
      progress: progress ?? this.progress,
      independent: independent ?? this.independent,
      xpAwarded: xpAwarded ?? this.xpAwarded,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (independent.present) {
      map['independent'] = Variable<bool>(independent.value);
    }
    if (xpAwarded.present) {
      map['xp_awarded'] = Variable<int>(xpAwarded.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementStatesCompanion(')
          ..write('achievementId: $achievementId, ')
          ..write('tier: $tier, ')
          ..write('progress: $progress, ')
          ..write('independent: $independent, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HintEventsTable extends HintEvents
    with TableInfo<$HintEventsTable, HintEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HintEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _learnerIdMeta =
      const VerificationMeta('learnerId');
  @override
  late final GeneratedColumn<String> learnerId = GeneratedColumn<String>(
      'learner_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
      'node_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _selectedTextMeta =
      const VerificationMeta('selectedText');
  @override
  late final GeneratedColumn<String> selectedText = GeneratedColumn<String>(
      'selected_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _selectionTypeMeta =
      const VerificationMeta('selectionType');
  @override
  late final GeneratedColumn<String> selectionType = GeneratedColumn<String>(
      'selection_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intentMeta = const VerificationMeta('intent');
  @override
  late final GeneratedColumn<String> intent = GeneratedColumn<String>(
      'intent', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hintLevelMeta =
      const VerificationMeta('hintLevel');
  @override
  late final GeneratedColumn<int> hintLevel = GeneratedColumn<int>(
      'hint_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _answerRevealedMeta =
      const VerificationMeta('answerRevealed');
  @override
  late final GeneratedColumn<bool> answerRevealed = GeneratedColumn<bool>(
      'answer_revealed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("answer_revealed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _outOfScopeMeta =
      const VerificationMeta('outOfScope');
  @override
  late final GeneratedColumn<bool> outOfScope = GeneratedColumn<bool>(
      'out_of_scope', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("out_of_scope" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _explainModeMeta =
      const VerificationMeta('explainMode');
  @override
  late final GeneratedColumn<bool> explainMode = GeneratedColumn<bool>(
      'explain_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("explain_mode" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _filteredMeta =
      const VerificationMeta('filtered');
  @override
  late final GeneratedColumn<bool> filtered = GeneratedColumn<bool>(
      'filtered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("filtered" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _servedOfflineMeta =
      const VerificationMeta('servedOffline');
  @override
  late final GeneratedColumn<bool> servedOffline = GeneratedColumn<bool>(
      'served_offline', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("served_offline" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _latencyMsMeta =
      const VerificationMeta('latencyMs');
  @override
  late final GeneratedColumn<int> latencyMs = GeneratedColumn<int>(
      'latency_ms', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        learnerId,
        itemId,
        nodeId,
        selectedText,
        selectionType,
        intent,
        hintLevel,
        answerRevealed,
        outOfScope,
        explainMode,
        filtered,
        servedOffline,
        latencyMs,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hint_events';
  @override
  VerificationContext validateIntegrity(Insertable<HintEventRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('learner_id')) {
      context.handle(_learnerIdMeta,
          learnerId.isAcceptableOrUnknown(data['learner_id']!, _learnerIdMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('selected_text')) {
      context.handle(
          _selectedTextMeta,
          selectedText.isAcceptableOrUnknown(
              data['selected_text']!, _selectedTextMeta));
    } else if (isInserting) {
      context.missing(_selectedTextMeta);
    }
    if (data.containsKey('selection_type')) {
      context.handle(
          _selectionTypeMeta,
          selectionType.isAcceptableOrUnknown(
              data['selection_type']!, _selectionTypeMeta));
    } else if (isInserting) {
      context.missing(_selectionTypeMeta);
    }
    if (data.containsKey('intent')) {
      context.handle(_intentMeta,
          intent.isAcceptableOrUnknown(data['intent']!, _intentMeta));
    } else if (isInserting) {
      context.missing(_intentMeta);
    }
    if (data.containsKey('hint_level')) {
      context.handle(_hintLevelMeta,
          hintLevel.isAcceptableOrUnknown(data['hint_level']!, _hintLevelMeta));
    }
    if (data.containsKey('answer_revealed')) {
      context.handle(
          _answerRevealedMeta,
          answerRevealed.isAcceptableOrUnknown(
              data['answer_revealed']!, _answerRevealedMeta));
    }
    if (data.containsKey('out_of_scope')) {
      context.handle(
          _outOfScopeMeta,
          outOfScope.isAcceptableOrUnknown(
              data['out_of_scope']!, _outOfScopeMeta));
    }
    if (data.containsKey('explain_mode')) {
      context.handle(
          _explainModeMeta,
          explainMode.isAcceptableOrUnknown(
              data['explain_mode']!, _explainModeMeta));
    }
    if (data.containsKey('filtered')) {
      context.handle(_filteredMeta,
          filtered.isAcceptableOrUnknown(data['filtered']!, _filteredMeta));
    }
    if (data.containsKey('served_offline')) {
      context.handle(
          _servedOfflineMeta,
          servedOffline.isAcceptableOrUnknown(
              data['served_offline']!, _servedOfflineMeta));
    }
    if (data.containsKey('latency_ms')) {
      context.handle(_latencyMsMeta,
          latencyMs.isAcceptableOrUnknown(data['latency_ms']!, _latencyMsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HintEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HintEventRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      learnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}learner_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      nodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_id'])!,
      selectedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selected_text'])!,
      selectionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selection_type'])!,
      intent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intent'])!,
      hintLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hint_level'])!,
      answerRevealed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}answer_revealed'])!,
      outOfScope: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}out_of_scope'])!,
      explainMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}explain_mode'])!,
      filtered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}filtered'])!,
      servedOffline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}served_offline'])!,
      latencyMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}latency_ms'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HintEventsTable createAlias(String alias) {
    return $HintEventsTable(attachedDatabase, alias);
  }
}

class HintEventRow extends DataClass implements Insertable<HintEventRow> {
  final String id;
  final String learnerId;
  final String itemId;
  final String nodeId;
  final String selectedText;
  final String selectionType;
  final String intent;
  final int hintLevel;
  final bool answerRevealed;
  final bool outOfScope;
  final bool explainMode;
  final bool filtered;
  final bool servedOffline;
  final int latencyMs;
  final DateTime createdAt;
  const HintEventRow(
      {required this.id,
      required this.learnerId,
      required this.itemId,
      required this.nodeId,
      required this.selectedText,
      required this.selectionType,
      required this.intent,
      required this.hintLevel,
      required this.answerRevealed,
      required this.outOfScope,
      required this.explainMode,
      required this.filtered,
      required this.servedOffline,
      required this.latencyMs,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['learner_id'] = Variable<String>(learnerId);
    map['item_id'] = Variable<String>(itemId);
    map['node_id'] = Variable<String>(nodeId);
    map['selected_text'] = Variable<String>(selectedText);
    map['selection_type'] = Variable<String>(selectionType);
    map['intent'] = Variable<String>(intent);
    map['hint_level'] = Variable<int>(hintLevel);
    map['answer_revealed'] = Variable<bool>(answerRevealed);
    map['out_of_scope'] = Variable<bool>(outOfScope);
    map['explain_mode'] = Variable<bool>(explainMode);
    map['filtered'] = Variable<bool>(filtered);
    map['served_offline'] = Variable<bool>(servedOffline);
    map['latency_ms'] = Variable<int>(latencyMs);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HintEventsCompanion toCompanion(bool nullToAbsent) {
    return HintEventsCompanion(
      id: Value(id),
      learnerId: Value(learnerId),
      itemId: Value(itemId),
      nodeId: Value(nodeId),
      selectedText: Value(selectedText),
      selectionType: Value(selectionType),
      intent: Value(intent),
      hintLevel: Value(hintLevel),
      answerRevealed: Value(answerRevealed),
      outOfScope: Value(outOfScope),
      explainMode: Value(explainMode),
      filtered: Value(filtered),
      servedOffline: Value(servedOffline),
      latencyMs: Value(latencyMs),
      createdAt: Value(createdAt),
    );
  }

  factory HintEventRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HintEventRow(
      id: serializer.fromJson<String>(json['id']),
      learnerId: serializer.fromJson<String>(json['learnerId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      selectedText: serializer.fromJson<String>(json['selectedText']),
      selectionType: serializer.fromJson<String>(json['selectionType']),
      intent: serializer.fromJson<String>(json['intent']),
      hintLevel: serializer.fromJson<int>(json['hintLevel']),
      answerRevealed: serializer.fromJson<bool>(json['answerRevealed']),
      outOfScope: serializer.fromJson<bool>(json['outOfScope']),
      explainMode: serializer.fromJson<bool>(json['explainMode']),
      filtered: serializer.fromJson<bool>(json['filtered']),
      servedOffline: serializer.fromJson<bool>(json['servedOffline']),
      latencyMs: serializer.fromJson<int>(json['latencyMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'learnerId': serializer.toJson<String>(learnerId),
      'itemId': serializer.toJson<String>(itemId),
      'nodeId': serializer.toJson<String>(nodeId),
      'selectedText': serializer.toJson<String>(selectedText),
      'selectionType': serializer.toJson<String>(selectionType),
      'intent': serializer.toJson<String>(intent),
      'hintLevel': serializer.toJson<int>(hintLevel),
      'answerRevealed': serializer.toJson<bool>(answerRevealed),
      'outOfScope': serializer.toJson<bool>(outOfScope),
      'explainMode': serializer.toJson<bool>(explainMode),
      'filtered': serializer.toJson<bool>(filtered),
      'servedOffline': serializer.toJson<bool>(servedOffline),
      'latencyMs': serializer.toJson<int>(latencyMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HintEventRow copyWith(
          {String? id,
          String? learnerId,
          String? itemId,
          String? nodeId,
          String? selectedText,
          String? selectionType,
          String? intent,
          int? hintLevel,
          bool? answerRevealed,
          bool? outOfScope,
          bool? explainMode,
          bool? filtered,
          bool? servedOffline,
          int? latencyMs,
          DateTime? createdAt}) =>
      HintEventRow(
        id: id ?? this.id,
        learnerId: learnerId ?? this.learnerId,
        itemId: itemId ?? this.itemId,
        nodeId: nodeId ?? this.nodeId,
        selectedText: selectedText ?? this.selectedText,
        selectionType: selectionType ?? this.selectionType,
        intent: intent ?? this.intent,
        hintLevel: hintLevel ?? this.hintLevel,
        answerRevealed: answerRevealed ?? this.answerRevealed,
        outOfScope: outOfScope ?? this.outOfScope,
        explainMode: explainMode ?? this.explainMode,
        filtered: filtered ?? this.filtered,
        servedOffline: servedOffline ?? this.servedOffline,
        latencyMs: latencyMs ?? this.latencyMs,
        createdAt: createdAt ?? this.createdAt,
      );
  HintEventRow copyWithCompanion(HintEventsCompanion data) {
    return HintEventRow(
      id: data.id.present ? data.id.value : this.id,
      learnerId: data.learnerId.present ? data.learnerId.value : this.learnerId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      selectedText: data.selectedText.present
          ? data.selectedText.value
          : this.selectedText,
      selectionType: data.selectionType.present
          ? data.selectionType.value
          : this.selectionType,
      intent: data.intent.present ? data.intent.value : this.intent,
      hintLevel: data.hintLevel.present ? data.hintLevel.value : this.hintLevel,
      answerRevealed: data.answerRevealed.present
          ? data.answerRevealed.value
          : this.answerRevealed,
      outOfScope:
          data.outOfScope.present ? data.outOfScope.value : this.outOfScope,
      explainMode:
          data.explainMode.present ? data.explainMode.value : this.explainMode,
      filtered: data.filtered.present ? data.filtered.value : this.filtered,
      servedOffline: data.servedOffline.present
          ? data.servedOffline.value
          : this.servedOffline,
      latencyMs: data.latencyMs.present ? data.latencyMs.value : this.latencyMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HintEventRow(')
          ..write('id: $id, ')
          ..write('learnerId: $learnerId, ')
          ..write('itemId: $itemId, ')
          ..write('nodeId: $nodeId, ')
          ..write('selectedText: $selectedText, ')
          ..write('selectionType: $selectionType, ')
          ..write('intent: $intent, ')
          ..write('hintLevel: $hintLevel, ')
          ..write('answerRevealed: $answerRevealed, ')
          ..write('outOfScope: $outOfScope, ')
          ..write('explainMode: $explainMode, ')
          ..write('filtered: $filtered, ')
          ..write('servedOffline: $servedOffline, ')
          ..write('latencyMs: $latencyMs, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      learnerId,
      itemId,
      nodeId,
      selectedText,
      selectionType,
      intent,
      hintLevel,
      answerRevealed,
      outOfScope,
      explainMode,
      filtered,
      servedOffline,
      latencyMs,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HintEventRow &&
          other.id == this.id &&
          other.learnerId == this.learnerId &&
          other.itemId == this.itemId &&
          other.nodeId == this.nodeId &&
          other.selectedText == this.selectedText &&
          other.selectionType == this.selectionType &&
          other.intent == this.intent &&
          other.hintLevel == this.hintLevel &&
          other.answerRevealed == this.answerRevealed &&
          other.outOfScope == this.outOfScope &&
          other.explainMode == this.explainMode &&
          other.filtered == this.filtered &&
          other.servedOffline == this.servedOffline &&
          other.latencyMs == this.latencyMs &&
          other.createdAt == this.createdAt);
}

class HintEventsCompanion extends UpdateCompanion<HintEventRow> {
  final Value<String> id;
  final Value<String> learnerId;
  final Value<String> itemId;
  final Value<String> nodeId;
  final Value<String> selectedText;
  final Value<String> selectionType;
  final Value<String> intent;
  final Value<int> hintLevel;
  final Value<bool> answerRevealed;
  final Value<bool> outOfScope;
  final Value<bool> explainMode;
  final Value<bool> filtered;
  final Value<bool> servedOffline;
  final Value<int> latencyMs;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HintEventsCompanion({
    this.id = const Value.absent(),
    this.learnerId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.selectedText = const Value.absent(),
    this.selectionType = const Value.absent(),
    this.intent = const Value.absent(),
    this.hintLevel = const Value.absent(),
    this.answerRevealed = const Value.absent(),
    this.outOfScope = const Value.absent(),
    this.explainMode = const Value.absent(),
    this.filtered = const Value.absent(),
    this.servedOffline = const Value.absent(),
    this.latencyMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HintEventsCompanion.insert({
    required String id,
    this.learnerId = const Value.absent(),
    required String itemId,
    required String nodeId,
    required String selectedText,
    required String selectionType,
    required String intent,
    this.hintLevel = const Value.absent(),
    this.answerRevealed = const Value.absent(),
    this.outOfScope = const Value.absent(),
    this.explainMode = const Value.absent(),
    this.filtered = const Value.absent(),
    this.servedOffline = const Value.absent(),
    this.latencyMs = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        nodeId = Value(nodeId),
        selectedText = Value(selectedText),
        selectionType = Value(selectionType),
        intent = Value(intent),
        createdAt = Value(createdAt);
  static Insertable<HintEventRow> custom({
    Expression<String>? id,
    Expression<String>? learnerId,
    Expression<String>? itemId,
    Expression<String>? nodeId,
    Expression<String>? selectedText,
    Expression<String>? selectionType,
    Expression<String>? intent,
    Expression<int>? hintLevel,
    Expression<bool>? answerRevealed,
    Expression<bool>? outOfScope,
    Expression<bool>? explainMode,
    Expression<bool>? filtered,
    Expression<bool>? servedOffline,
    Expression<int>? latencyMs,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (learnerId != null) 'learner_id': learnerId,
      if (itemId != null) 'item_id': itemId,
      if (nodeId != null) 'node_id': nodeId,
      if (selectedText != null) 'selected_text': selectedText,
      if (selectionType != null) 'selection_type': selectionType,
      if (intent != null) 'intent': intent,
      if (hintLevel != null) 'hint_level': hintLevel,
      if (answerRevealed != null) 'answer_revealed': answerRevealed,
      if (outOfScope != null) 'out_of_scope': outOfScope,
      if (explainMode != null) 'explain_mode': explainMode,
      if (filtered != null) 'filtered': filtered,
      if (servedOffline != null) 'served_offline': servedOffline,
      if (latencyMs != null) 'latency_ms': latencyMs,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HintEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? learnerId,
      Value<String>? itemId,
      Value<String>? nodeId,
      Value<String>? selectedText,
      Value<String>? selectionType,
      Value<String>? intent,
      Value<int>? hintLevel,
      Value<bool>? answerRevealed,
      Value<bool>? outOfScope,
      Value<bool>? explainMode,
      Value<bool>? filtered,
      Value<bool>? servedOffline,
      Value<int>? latencyMs,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return HintEventsCompanion(
      id: id ?? this.id,
      learnerId: learnerId ?? this.learnerId,
      itemId: itemId ?? this.itemId,
      nodeId: nodeId ?? this.nodeId,
      selectedText: selectedText ?? this.selectedText,
      selectionType: selectionType ?? this.selectionType,
      intent: intent ?? this.intent,
      hintLevel: hintLevel ?? this.hintLevel,
      answerRevealed: answerRevealed ?? this.answerRevealed,
      outOfScope: outOfScope ?? this.outOfScope,
      explainMode: explainMode ?? this.explainMode,
      filtered: filtered ?? this.filtered,
      servedOffline: servedOffline ?? this.servedOffline,
      latencyMs: latencyMs ?? this.latencyMs,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (learnerId.present) {
      map['learner_id'] = Variable<String>(learnerId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (selectedText.present) {
      map['selected_text'] = Variable<String>(selectedText.value);
    }
    if (selectionType.present) {
      map['selection_type'] = Variable<String>(selectionType.value);
    }
    if (intent.present) {
      map['intent'] = Variable<String>(intent.value);
    }
    if (hintLevel.present) {
      map['hint_level'] = Variable<int>(hintLevel.value);
    }
    if (answerRevealed.present) {
      map['answer_revealed'] = Variable<bool>(answerRevealed.value);
    }
    if (outOfScope.present) {
      map['out_of_scope'] = Variable<bool>(outOfScope.value);
    }
    if (explainMode.present) {
      map['explain_mode'] = Variable<bool>(explainMode.value);
    }
    if (filtered.present) {
      map['filtered'] = Variable<bool>(filtered.value);
    }
    if (servedOffline.present) {
      map['served_offline'] = Variable<bool>(servedOffline.value);
    }
    if (latencyMs.present) {
      map['latency_ms'] = Variable<int>(latencyMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HintEventsCompanion(')
          ..write('id: $id, ')
          ..write('learnerId: $learnerId, ')
          ..write('itemId: $itemId, ')
          ..write('nodeId: $nodeId, ')
          ..write('selectedText: $selectedText, ')
          ..write('selectionType: $selectionType, ')
          ..write('intent: $intent, ')
          ..write('hintLevel: $hintLevel, ')
          ..write('answerRevealed: $answerRevealed, ')
          ..write('outOfScope: $outOfScope, ')
          ..write('explainMode: $explainMode, ')
          ..write('filtered: $filtered, ')
          ..write('servedOffline: $servedOffline, ')
          ..write('latencyMs: $latencyMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttemptsTable extends Attempts
    with TableInfo<$AttemptsTable, AttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
      'node_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumnWithTypeConverter<AttemptMode, String> mode =
      GeneratedColumn<String>('mode', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<AttemptMode>($AttemptsTable.$convertermode);
  static const VerificationMeta _hintLevelMeta =
      const VerificationMeta('hintLevel');
  @override
  late final GeneratedColumn<int> hintLevel = GeneratedColumn<int>(
      'hint_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hintRequestCountMeta =
      const VerificationMeta('hintRequestCount');
  @override
  late final GeneratedColumn<int> hintRequestCount = GeneratedColumn<int>(
      'hint_request_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _assistedMeta =
      const VerificationMeta('assisted');
  @override
  late final GeneratedColumn<bool> assisted = GeneratedColumn<bool>(
      'assisted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("assisted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _answerRevealedMeta =
      const VerificationMeta('answerRevealed');
  @override
  late final GeneratedColumn<bool> answerRevealed = GeneratedColumn<bool>(
      'answer_revealed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("answer_revealed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
      'correct', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("correct" IN (0, 1))'));
  static const VerificationMeta _selectedAnswerMeta =
      const VerificationMeta('selectedAnswer');
  @override
  late final GeneratedColumn<String> selectedAnswer = GeneratedColumn<String>(
      'selected_answer', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _elapsedSecondsMeta =
      const VerificationMeta('elapsedSeconds');
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
      'elapsed_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
      'finished_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        itemId,
        nodeId,
        mode,
        hintLevel,
        hintRequestCount,
        assisted,
        answerRevealed,
        correct,
        selectedAnswer,
        elapsedSeconds,
        startedAt,
        finishedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempts';
  @override
  VerificationContext validateIntegrity(Insertable<AttemptRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    context.handle(_modeMeta, const VerificationResult.success());
    if (data.containsKey('hint_level')) {
      context.handle(_hintLevelMeta,
          hintLevel.isAcceptableOrUnknown(data['hint_level']!, _hintLevelMeta));
    }
    if (data.containsKey('hint_request_count')) {
      context.handle(
          _hintRequestCountMeta,
          hintRequestCount.isAcceptableOrUnknown(
              data['hint_request_count']!, _hintRequestCountMeta));
    }
    if (data.containsKey('assisted')) {
      context.handle(_assistedMeta,
          assisted.isAcceptableOrUnknown(data['assisted']!, _assistedMeta));
    }
    if (data.containsKey('answer_revealed')) {
      context.handle(
          _answerRevealedMeta,
          answerRevealed.isAcceptableOrUnknown(
              data['answer_revealed']!, _answerRevealedMeta));
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    }
    if (data.containsKey('selected_answer')) {
      context.handle(
          _selectedAnswerMeta,
          selectedAnswer.isAcceptableOrUnknown(
              data['selected_answer']!, _selectedAnswerMeta));
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
          _elapsedSecondsMeta,
          elapsedSeconds.isAcceptableOrUnknown(
              data['elapsed_seconds']!, _elapsedSecondsMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttemptRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      nodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}node_id'])!,
      mode: $AttemptsTable.$convertermode.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!),
      hintLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hint_level'])!,
      hintRequestCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}hint_request_count'])!,
      assisted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}assisted'])!,
      answerRevealed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}answer_revealed'])!,
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}correct']),
      selectedAnswer: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}selected_answer'])!,
      elapsedSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}elapsed_seconds'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}finished_at']),
    );
  }

  @override
  $AttemptsTable createAlias(String alias) {
    return $AttemptsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AttemptMode, String, String> $convertermode =
      const EnumNameConverter<AttemptMode>(AttemptMode.values);
}

class AttemptRow extends DataClass implements Insertable<AttemptRow> {
  final String id;
  final String itemId;
  final String nodeId;
  final AttemptMode mode;
  final int hintLevel;
  final int hintRequestCount;
  final bool assisted;
  final bool answerRevealed;
  final bool? correct;
  final String selectedAnswer;
  final int elapsedSeconds;
  final DateTime startedAt;
  final DateTime? finishedAt;
  const AttemptRow(
      {required this.id,
      required this.itemId,
      required this.nodeId,
      required this.mode,
      required this.hintLevel,
      required this.hintRequestCount,
      required this.assisted,
      required this.answerRevealed,
      this.correct,
      required this.selectedAnswer,
      required this.elapsedSeconds,
      required this.startedAt,
      this.finishedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['node_id'] = Variable<String>(nodeId);
    {
      map['mode'] = Variable<String>($AttemptsTable.$convertermode.toSql(mode));
    }
    map['hint_level'] = Variable<int>(hintLevel);
    map['hint_request_count'] = Variable<int>(hintRequestCount);
    map['assisted'] = Variable<bool>(assisted);
    map['answer_revealed'] = Variable<bool>(answerRevealed);
    if (!nullToAbsent || correct != null) {
      map['correct'] = Variable<bool>(correct);
    }
    map['selected_answer'] = Variable<String>(selectedAnswer);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    return map;
  }

  AttemptsCompanion toCompanion(bool nullToAbsent) {
    return AttemptsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      nodeId: Value(nodeId),
      mode: Value(mode),
      hintLevel: Value(hintLevel),
      hintRequestCount: Value(hintRequestCount),
      assisted: Value(assisted),
      answerRevealed: Value(answerRevealed),
      correct: correct == null && nullToAbsent
          ? const Value.absent()
          : Value(correct),
      selectedAnswer: Value(selectedAnswer),
      elapsedSeconds: Value(elapsedSeconds),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
    );
  }

  factory AttemptRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttemptRow(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      mode: $AttemptsTable.$convertermode
          .fromJson(serializer.fromJson<String>(json['mode'])),
      hintLevel: serializer.fromJson<int>(json['hintLevel']),
      hintRequestCount: serializer.fromJson<int>(json['hintRequestCount']),
      assisted: serializer.fromJson<bool>(json['assisted']),
      answerRevealed: serializer.fromJson<bool>(json['answerRevealed']),
      correct: serializer.fromJson<bool?>(json['correct']),
      selectedAnswer: serializer.fromJson<String>(json['selectedAnswer']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'nodeId': serializer.toJson<String>(nodeId),
      'mode':
          serializer.toJson<String>($AttemptsTable.$convertermode.toJson(mode)),
      'hintLevel': serializer.toJson<int>(hintLevel),
      'hintRequestCount': serializer.toJson<int>(hintRequestCount),
      'assisted': serializer.toJson<bool>(assisted),
      'answerRevealed': serializer.toJson<bool>(answerRevealed),
      'correct': serializer.toJson<bool?>(correct),
      'selectedAnswer': serializer.toJson<String>(selectedAnswer),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
    };
  }

  AttemptRow copyWith(
          {String? id,
          String? itemId,
          String? nodeId,
          AttemptMode? mode,
          int? hintLevel,
          int? hintRequestCount,
          bool? assisted,
          bool? answerRevealed,
          Value<bool?> correct = const Value.absent(),
          String? selectedAnswer,
          int? elapsedSeconds,
          DateTime? startedAt,
          Value<DateTime?> finishedAt = const Value.absent()}) =>
      AttemptRow(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        nodeId: nodeId ?? this.nodeId,
        mode: mode ?? this.mode,
        hintLevel: hintLevel ?? this.hintLevel,
        hintRequestCount: hintRequestCount ?? this.hintRequestCount,
        assisted: assisted ?? this.assisted,
        answerRevealed: answerRevealed ?? this.answerRevealed,
        correct: correct.present ? correct.value : this.correct,
        selectedAnswer: selectedAnswer ?? this.selectedAnswer,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
      );
  AttemptRow copyWithCompanion(AttemptsCompanion data) {
    return AttemptRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      mode: data.mode.present ? data.mode.value : this.mode,
      hintLevel: data.hintLevel.present ? data.hintLevel.value : this.hintLevel,
      hintRequestCount: data.hintRequestCount.present
          ? data.hintRequestCount.value
          : this.hintRequestCount,
      assisted: data.assisted.present ? data.assisted.value : this.assisted,
      answerRevealed: data.answerRevealed.present
          ? data.answerRevealed.value
          : this.answerRevealed,
      correct: data.correct.present ? data.correct.value : this.correct,
      selectedAnswer: data.selectedAnswer.present
          ? data.selectedAnswer.value
          : this.selectedAnswer,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt:
          data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttemptRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('nodeId: $nodeId, ')
          ..write('mode: $mode, ')
          ..write('hintLevel: $hintLevel, ')
          ..write('hintRequestCount: $hintRequestCount, ')
          ..write('assisted: $assisted, ')
          ..write('answerRevealed: $answerRevealed, ')
          ..write('correct: $correct, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      itemId,
      nodeId,
      mode,
      hintLevel,
      hintRequestCount,
      assisted,
      answerRevealed,
      correct,
      selectedAnswer,
      elapsedSeconds,
      startedAt,
      finishedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttemptRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.nodeId == this.nodeId &&
          other.mode == this.mode &&
          other.hintLevel == this.hintLevel &&
          other.hintRequestCount == this.hintRequestCount &&
          other.assisted == this.assisted &&
          other.answerRevealed == this.answerRevealed &&
          other.correct == this.correct &&
          other.selectedAnswer == this.selectedAnswer &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt);
}

class AttemptsCompanion extends UpdateCompanion<AttemptRow> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String> nodeId;
  final Value<AttemptMode> mode;
  final Value<int> hintLevel;
  final Value<int> hintRequestCount;
  final Value<bool> assisted;
  final Value<bool> answerRevealed;
  final Value<bool?> correct;
  final Value<String> selectedAnswer;
  final Value<int> elapsedSeconds;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> rowid;
  const AttemptsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.mode = const Value.absent(),
    this.hintLevel = const Value.absent(),
    this.hintRequestCount = const Value.absent(),
    this.assisted = const Value.absent(),
    this.answerRevealed = const Value.absent(),
    this.correct = const Value.absent(),
    this.selectedAnswer = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttemptsCompanion.insert({
    required String id,
    required String itemId,
    required String nodeId,
    required AttemptMode mode,
    this.hintLevel = const Value.absent(),
    this.hintRequestCount = const Value.absent(),
    this.assisted = const Value.absent(),
    this.answerRevealed = const Value.absent(),
    this.correct = const Value.absent(),
    this.selectedAnswer = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        nodeId = Value(nodeId),
        mode = Value(mode),
        startedAt = Value(startedAt);
  static Insertable<AttemptRow> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? nodeId,
    Expression<String>? mode,
    Expression<int>? hintLevel,
    Expression<int>? hintRequestCount,
    Expression<bool>? assisted,
    Expression<bool>? answerRevealed,
    Expression<bool>? correct,
    Expression<String>? selectedAnswer,
    Expression<int>? elapsedSeconds,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (nodeId != null) 'node_id': nodeId,
      if (mode != null) 'mode': mode,
      if (hintLevel != null) 'hint_level': hintLevel,
      if (hintRequestCount != null) 'hint_request_count': hintRequestCount,
      if (assisted != null) 'assisted': assisted,
      if (answerRevealed != null) 'answer_revealed': answerRevealed,
      if (correct != null) 'correct': correct,
      if (selectedAnswer != null) 'selected_answer': selectedAnswer,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttemptsCompanion copyWith(
      {Value<String>? id,
      Value<String>? itemId,
      Value<String>? nodeId,
      Value<AttemptMode>? mode,
      Value<int>? hintLevel,
      Value<int>? hintRequestCount,
      Value<bool>? assisted,
      Value<bool>? answerRevealed,
      Value<bool?>? correct,
      Value<String>? selectedAnswer,
      Value<int>? elapsedSeconds,
      Value<DateTime>? startedAt,
      Value<DateTime?>? finishedAt,
      Value<int>? rowid}) {
    return AttemptsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      nodeId: nodeId ?? this.nodeId,
      mode: mode ?? this.mode,
      hintLevel: hintLevel ?? this.hintLevel,
      hintRequestCount: hintRequestCount ?? this.hintRequestCount,
      assisted: assisted ?? this.assisted,
      answerRevealed: answerRevealed ?? this.answerRevealed,
      correct: correct ?? this.correct,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (mode.present) {
      map['mode'] =
          Variable<String>($AttemptsTable.$convertermode.toSql(mode.value));
    }
    if (hintLevel.present) {
      map['hint_level'] = Variable<int>(hintLevel.value);
    }
    if (hintRequestCount.present) {
      map['hint_request_count'] = Variable<int>(hintRequestCount.value);
    }
    if (assisted.present) {
      map['assisted'] = Variable<bool>(assisted.value);
    }
    if (answerRevealed.present) {
      map['answer_revealed'] = Variable<bool>(answerRevealed.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (selectedAnswer.present) {
      map['selected_answer'] = Variable<String>(selectedAnswer.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('nodeId: $nodeId, ')
          ..write('mode: $mode, ')
          ..write('hintLevel: $hintLevel, ')
          ..write('hintRequestCount: $hintRequestCount, ')
          ..write('assisted: $assisted, ')
          ..write('answerRevealed: $answerRevealed, ')
          ..write('correct: $correct, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentPackVersionsTable extends ContentPackVersions
    with TableInfo<$ContentPackVersionsTable, ContentPackVersionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentPackVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
      'pack_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _installedAtMeta =
      const VerificationMeta('installedAt');
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
      'installed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _checksumMeta =
      const VerificationMeta('checksum');
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
      'checksum', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [packId, version, installedAt, checksum, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_pack_versions';
  @override
  VerificationContext validateIntegrity(
      Insertable<ContentPackVersionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(_packIdMeta,
          packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta));
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('installed_at')) {
      context.handle(
          _installedAtMeta,
          installedAt.isAcceptableOrUnknown(
              data['installed_at']!, _installedAtMeta));
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(_checksumMeta,
          checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packId, version};
  @override
  ContentPackVersionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentPackVersionRow(
      packId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pack_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      installedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}installed_at'])!,
      checksum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checksum'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
    );
  }

  @override
  $ContentPackVersionsTable createAlias(String alias) {
    return $ContentPackVersionsTable(attachedDatabase, alias);
  }
}

class ContentPackVersionRow extends DataClass
    implements Insertable<ContentPackVersionRow> {
  final String packId;
  final String version;
  final DateTime installedAt;
  final String checksum;
  final bool active;
  const ContentPackVersionRow(
      {required this.packId,
      required this.version,
      required this.installedAt,
      required this.checksum,
      required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['version'] = Variable<String>(version);
    map['installed_at'] = Variable<DateTime>(installedAt);
    map['checksum'] = Variable<String>(checksum);
    map['active'] = Variable<bool>(active);
    return map;
  }

  ContentPackVersionsCompanion toCompanion(bool nullToAbsent) {
    return ContentPackVersionsCompanion(
      packId: Value(packId),
      version: Value(version),
      installedAt: Value(installedAt),
      checksum: Value(checksum),
      active: Value(active),
    );
  }

  factory ContentPackVersionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentPackVersionRow(
      packId: serializer.fromJson<String>(json['packId']),
      version: serializer.fromJson<String>(json['version']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
      checksum: serializer.fromJson<String>(json['checksum']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'version': serializer.toJson<String>(version),
      'installedAt': serializer.toJson<DateTime>(installedAt),
      'checksum': serializer.toJson<String>(checksum),
      'active': serializer.toJson<bool>(active),
    };
  }

  ContentPackVersionRow copyWith(
          {String? packId,
          String? version,
          DateTime? installedAt,
          String? checksum,
          bool? active}) =>
      ContentPackVersionRow(
        packId: packId ?? this.packId,
        version: version ?? this.version,
        installedAt: installedAt ?? this.installedAt,
        checksum: checksum ?? this.checksum,
        active: active ?? this.active,
      );
  ContentPackVersionRow copyWithCompanion(ContentPackVersionsCompanion data) {
    return ContentPackVersionRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      version: data.version.present ? data.version.value : this.version,
      installedAt:
          data.installedAt.present ? data.installedAt.value : this.installedAt,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentPackVersionRow(')
          ..write('packId: $packId, ')
          ..write('version: $version, ')
          ..write('installedAt: $installedAt, ')
          ..write('checksum: $checksum, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(packId, version, installedAt, checksum, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentPackVersionRow &&
          other.packId == this.packId &&
          other.version == this.version &&
          other.installedAt == this.installedAt &&
          other.checksum == this.checksum &&
          other.active == this.active);
}

class ContentPackVersionsCompanion
    extends UpdateCompanion<ContentPackVersionRow> {
  final Value<String> packId;
  final Value<String> version;
  final Value<DateTime> installedAt;
  final Value<String> checksum;
  final Value<bool> active;
  final Value<int> rowid;
  const ContentPackVersionsCompanion({
    this.packId = const Value.absent(),
    this.version = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.checksum = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentPackVersionsCompanion.insert({
    required String packId,
    required String version,
    required DateTime installedAt,
    this.checksum = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : packId = Value(packId),
        version = Value(version),
        installedAt = Value(installedAt);
  static Insertable<ContentPackVersionRow> custom({
    Expression<String>? packId,
    Expression<String>? version,
    Expression<DateTime>? installedAt,
    Expression<String>? checksum,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (version != null) 'version': version,
      if (installedAt != null) 'installed_at': installedAt,
      if (checksum != null) 'checksum': checksum,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentPackVersionsCompanion copyWith(
      {Value<String>? packId,
      Value<String>? version,
      Value<DateTime>? installedAt,
      Value<String>? checksum,
      Value<bool>? active,
      Value<int>? rowid}) {
    return ContentPackVersionsCompanion(
      packId: packId ?? this.packId,
      version: version ?? this.version,
      installedAt: installedAt ?? this.installedAt,
      checksum: checksum ?? this.checksum,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentPackVersionsCompanion(')
          ..write('packId: $packId, ')
          ..write('version: $version, ')
          ..write('installedAt: $installedAt, ')
          ..write('checksum: $checksum, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
      'entity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, entity, payload, createdAt, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(_entityMeta,
          entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueRow extends DataClass implements Insertable<SyncQueueRow> {
  final String id;
  final String entity;
  final String payload;
  final DateTime createdAt;
  final bool synced;
  const SyncQueueRow(
      {required this.id,
      required this.entity,
      required this.payload,
      required this.createdAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity'] = Variable<String>(entity);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entity: Value(entity),
      payload: Value(payload),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory SyncQueueRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueRow(
      id: serializer.fromJson<String>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entity': serializer.toJson<String>(entity),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  SyncQueueRow copyWith(
          {String? id,
          String? entity,
          String? payload,
          DateTime? createdAt,
          bool? synced}) =>
      SyncQueueRow(
        id: id ?? this.id,
        entity: entity ?? this.entity,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
      );
  SyncQueueRow copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueRow(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueRow(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entity, payload, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueRow &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueRow> {
  final Value<String> id;
  final Value<String> entity;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String entity,
    required String payload,
    required DateTime createdAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entity = Value(entity),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueRow> custom({
    Expression<String>? id,
    Expression<String>? entity,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? entity,
      Value<String>? payload,
      Value<DateTime>? createdAt,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyStatsTable extends DailyStats
    with TableInfo<$DailyStatsTable, DailyStatRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
      'day', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _evidenceCountMeta =
      const VerificationMeta('evidenceCount');
  @override
  late final GeneratedColumn<int> evidenceCount = GeneratedColumn<int>(
      'evidence_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _independentCountMeta =
      const VerificationMeta('independentCount');
  @override
  late final GeneratedColumn<int> independentCount = GeneratedColumn<int>(
      'independent_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hintCountMeta =
      const VerificationMeta('hintCount');
  @override
  late final GeneratedColumn<int> hintCount = GeneratedColumn<int>(
      'hint_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reviewCountMeta =
      const VerificationMeta('reviewCount');
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
      'review_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minutesMeta =
      const VerificationMeta('minutes');
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
      'minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [day, evidenceCount, independentCount, hintCount, reviewCount, minutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stats';
  @override
  VerificationContext validateIntegrity(Insertable<DailyStatRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('evidence_count')) {
      context.handle(
          _evidenceCountMeta,
          evidenceCount.isAcceptableOrUnknown(
              data['evidence_count']!, _evidenceCountMeta));
    }
    if (data.containsKey('independent_count')) {
      context.handle(
          _independentCountMeta,
          independentCount.isAcceptableOrUnknown(
              data['independent_count']!, _independentCountMeta));
    }
    if (data.containsKey('hint_count')) {
      context.handle(_hintCountMeta,
          hintCount.isAcceptableOrUnknown(data['hint_count']!, _hintCountMeta));
    }
    if (data.containsKey('review_count')) {
      context.handle(
          _reviewCountMeta,
          reviewCount.isAcceptableOrUnknown(
              data['review_count']!, _reviewCountMeta));
    }
    if (data.containsKey('minutes')) {
      context.handle(_minutesMeta,
          minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DailyStatRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStatRow(
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}day'])!,
      evidenceCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}evidence_count'])!,
      independentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}independent_count'])!,
      hintCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hint_count'])!,
      reviewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_count'])!,
      minutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minutes'])!,
    );
  }

  @override
  $DailyStatsTable createAlias(String alias) {
    return $DailyStatsTable(attachedDatabase, alias);
  }
}

class DailyStatRow extends DataClass implements Insertable<DailyStatRow> {
  final DateTime day;
  final int evidenceCount;
  final int independentCount;
  final int hintCount;
  final int reviewCount;
  final int minutes;
  const DailyStatRow(
      {required this.day,
      required this.evidenceCount,
      required this.independentCount,
      required this.hintCount,
      required this.reviewCount,
      required this.minutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<DateTime>(day);
    map['evidence_count'] = Variable<int>(evidenceCount);
    map['independent_count'] = Variable<int>(independentCount);
    map['hint_count'] = Variable<int>(hintCount);
    map['review_count'] = Variable<int>(reviewCount);
    map['minutes'] = Variable<int>(minutes);
    return map;
  }

  DailyStatsCompanion toCompanion(bool nullToAbsent) {
    return DailyStatsCompanion(
      day: Value(day),
      evidenceCount: Value(evidenceCount),
      independentCount: Value(independentCount),
      hintCount: Value(hintCount),
      reviewCount: Value(reviewCount),
      minutes: Value(minutes),
    );
  }

  factory DailyStatRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStatRow(
      day: serializer.fromJson<DateTime>(json['day']),
      evidenceCount: serializer.fromJson<int>(json['evidenceCount']),
      independentCount: serializer.fromJson<int>(json['independentCount']),
      hintCount: serializer.fromJson<int>(json['hintCount']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      minutes: serializer.fromJson<int>(json['minutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<DateTime>(day),
      'evidenceCount': serializer.toJson<int>(evidenceCount),
      'independentCount': serializer.toJson<int>(independentCount),
      'hintCount': serializer.toJson<int>(hintCount),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'minutes': serializer.toJson<int>(minutes),
    };
  }

  DailyStatRow copyWith(
          {DateTime? day,
          int? evidenceCount,
          int? independentCount,
          int? hintCount,
          int? reviewCount,
          int? minutes}) =>
      DailyStatRow(
        day: day ?? this.day,
        evidenceCount: evidenceCount ?? this.evidenceCount,
        independentCount: independentCount ?? this.independentCount,
        hintCount: hintCount ?? this.hintCount,
        reviewCount: reviewCount ?? this.reviewCount,
        minutes: minutes ?? this.minutes,
      );
  DailyStatRow copyWithCompanion(DailyStatsCompanion data) {
    return DailyStatRow(
      day: data.day.present ? data.day.value : this.day,
      evidenceCount: data.evidenceCount.present
          ? data.evidenceCount.value
          : this.evidenceCount,
      independentCount: data.independentCount.present
          ? data.independentCount.value
          : this.independentCount,
      hintCount: data.hintCount.present ? data.hintCount.value : this.hintCount,
      reviewCount:
          data.reviewCount.present ? data.reviewCount.value : this.reviewCount,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatRow(')
          ..write('day: $day, ')
          ..write('evidenceCount: $evidenceCount, ')
          ..write('independentCount: $independentCount, ')
          ..write('hintCount: $hintCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('minutes: $minutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      day, evidenceCount, independentCount, hintCount, reviewCount, minutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStatRow &&
          other.day == this.day &&
          other.evidenceCount == this.evidenceCount &&
          other.independentCount == this.independentCount &&
          other.hintCount == this.hintCount &&
          other.reviewCount == this.reviewCount &&
          other.minutes == this.minutes);
}

class DailyStatsCompanion extends UpdateCompanion<DailyStatRow> {
  final Value<DateTime> day;
  final Value<int> evidenceCount;
  final Value<int> independentCount;
  final Value<int> hintCount;
  final Value<int> reviewCount;
  final Value<int> minutes;
  final Value<int> rowid;
  const DailyStatsCompanion({
    this.day = const Value.absent(),
    this.evidenceCount = const Value.absent(),
    this.independentCount = const Value.absent(),
    this.hintCount = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.minutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStatsCompanion.insert({
    required DateTime day,
    this.evidenceCount = const Value.absent(),
    this.independentCount = const Value.absent(),
    this.hintCount = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.minutes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day);
  static Insertable<DailyStatRow> custom({
    Expression<DateTime>? day,
    Expression<int>? evidenceCount,
    Expression<int>? independentCount,
    Expression<int>? hintCount,
    Expression<int>? reviewCount,
    Expression<int>? minutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (evidenceCount != null) 'evidence_count': evidenceCount,
      if (independentCount != null) 'independent_count': independentCount,
      if (hintCount != null) 'hint_count': hintCount,
      if (reviewCount != null) 'review_count': reviewCount,
      if (minutes != null) 'minutes': minutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStatsCompanion copyWith(
      {Value<DateTime>? day,
      Value<int>? evidenceCount,
      Value<int>? independentCount,
      Value<int>? hintCount,
      Value<int>? reviewCount,
      Value<int>? minutes,
      Value<int>? rowid}) {
    return DailyStatsCompanion(
      day: day ?? this.day,
      evidenceCount: evidenceCount ?? this.evidenceCount,
      independentCount: independentCount ?? this.independentCount,
      hintCount: hintCount ?? this.hintCount,
      reviewCount: reviewCount ?? this.reviewCount,
      minutes: minutes ?? this.minutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (evidenceCount.present) {
      map['evidence_count'] = Variable<int>(evidenceCount.value);
    }
    if (independentCount.present) {
      map['independent_count'] = Variable<int>(independentCount.value);
    }
    if (hintCount.present) {
      map['hint_count'] = Variable<int>(hintCount.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatsCompanion(')
          ..write('day: $day, ')
          ..write('evidenceCount: $evidenceCount, ')
          ..write('independentCount: $independentCount, ')
          ..write('hintCount: $hintCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('minutes: $minutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EvidenceEventsTable evidenceEvents = $EvidenceEventsTable(this);
  late final $NodeStatesTable nodeStates = $NodeStatesTable(this);
  late final $ItemDifficultyTable itemDifficulty = $ItemDifficultyTable(this);
  late final $VocabStatesTable vocabStates = $VocabStatesTable(this);
  late final $AchievementStatesTable achievementStates =
      $AchievementStatesTable(this);
  late final $HintEventsTable hintEvents = $HintEventsTable(this);
  late final $AttemptsTable attempts = $AttemptsTable(this);
  late final $ContentPackVersionsTable contentPackVersions =
      $ContentPackVersionsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $DailyStatsTable dailyStats = $DailyStatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        evidenceEvents,
        nodeStates,
        itemDifficulty,
        vocabStates,
        achievementStates,
        hintEvents,
        attempts,
        contentPackVersions,
        syncQueue,
        dailyStats
      ];
}

typedef $$EvidenceEventsTableCreateCompanionBuilder = EvidenceEventsCompanion
    Function({
  required String id,
  Value<String> learnerId,
  required String nodeId,
  Value<String?> itemId,
  required EvidenceKind kind,
  required double score,
  Value<double> effectiveScore,
  Value<double> predicted,
  Value<bool> independent,
  Value<int> hintLevel,
  Value<int> hintRequestCount,
  Value<bool> outOfScope,
  Value<bool> explainMode,
  Value<double> difficulty,
  Value<double> thetaAfter,
  Value<double> masteryAfter,
  Value<int?> elapsedSeconds,
  Value<String> source,
  Value<String> payload,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$EvidenceEventsTableUpdateCompanionBuilder = EvidenceEventsCompanion
    Function({
  Value<String> id,
  Value<String> learnerId,
  Value<String> nodeId,
  Value<String?> itemId,
  Value<EvidenceKind> kind,
  Value<double> score,
  Value<double> effectiveScore,
  Value<double> predicted,
  Value<bool> independent,
  Value<int> hintLevel,
  Value<int> hintRequestCount,
  Value<bool> outOfScope,
  Value<bool> explainMode,
  Value<double> difficulty,
  Value<double> thetaAfter,
  Value<double> masteryAfter,
  Value<int?> elapsedSeconds,
  Value<String> source,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$EvidenceEventsTableFilterComposer
    extends Composer<_$AppDatabase, $EvidenceEventsTable> {
  $$EvidenceEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get learnerId => $composableBuilder(
      column: $table.learnerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EvidenceKind, EvidenceKind, String> get kind =>
      $composableBuilder(
          column: $table.kind,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get effectiveScore => $composableBuilder(
      column: $table.effectiveScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get predicted => $composableBuilder(
      column: $table.predicted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get independent => $composableBuilder(
      column: $table.independent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hintLevel => $composableBuilder(
      column: $table.hintLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hintRequestCount => $composableBuilder(
      column: $table.hintRequestCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get outOfScope => $composableBuilder(
      column: $table.outOfScope, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get explainMode => $composableBuilder(
      column: $table.explainMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get thetaAfter => $composableBuilder(
      column: $table.thetaAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get masteryAfter => $composableBuilder(
      column: $table.masteryAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
      column: $table.elapsedSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$EvidenceEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EvidenceEventsTable> {
  $$EvidenceEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get learnerId => $composableBuilder(
      column: $table.learnerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get effectiveScore => $composableBuilder(
      column: $table.effectiveScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get predicted => $composableBuilder(
      column: $table.predicted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get independent => $composableBuilder(
      column: $table.independent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hintLevel => $composableBuilder(
      column: $table.hintLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hintRequestCount => $composableBuilder(
      column: $table.hintRequestCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get outOfScope => $composableBuilder(
      column: $table.outOfScope, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get explainMode => $composableBuilder(
      column: $table.explainMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get thetaAfter => $composableBuilder(
      column: $table.thetaAfter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get masteryAfter => $composableBuilder(
      column: $table.masteryAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
      column: $table.elapsedSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EvidenceEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EvidenceEventsTable> {
  $$EvidenceEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get learnerId =>
      $composableBuilder(column: $table.learnerId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EvidenceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<double> get effectiveScore => $composableBuilder(
      column: $table.effectiveScore, builder: (column) => column);

  GeneratedColumn<double> get predicted =>
      $composableBuilder(column: $table.predicted, builder: (column) => column);

  GeneratedColumn<bool> get independent => $composableBuilder(
      column: $table.independent, builder: (column) => column);

  GeneratedColumn<int> get hintLevel =>
      $composableBuilder(column: $table.hintLevel, builder: (column) => column);

  GeneratedColumn<int> get hintRequestCount => $composableBuilder(
      column: $table.hintRequestCount, builder: (column) => column);

  GeneratedColumn<bool> get outOfScope => $composableBuilder(
      column: $table.outOfScope, builder: (column) => column);

  GeneratedColumn<bool> get explainMode => $composableBuilder(
      column: $table.explainMode, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<double> get thetaAfter => $composableBuilder(
      column: $table.thetaAfter, builder: (column) => column);

  GeneratedColumn<double> get masteryAfter => $composableBuilder(
      column: $table.masteryAfter, builder: (column) => column);

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
      column: $table.elapsedSeconds, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EvidenceEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EvidenceEventsTable,
    EvidenceEventRow,
    $$EvidenceEventsTableFilterComposer,
    $$EvidenceEventsTableOrderingComposer,
    $$EvidenceEventsTableAnnotationComposer,
    $$EvidenceEventsTableCreateCompanionBuilder,
    $$EvidenceEventsTableUpdateCompanionBuilder,
    (
      EvidenceEventRow,
      BaseReferences<_$AppDatabase, $EvidenceEventsTable, EvidenceEventRow>
    ),
    EvidenceEventRow,
    PrefetchHooks Function()> {
  $$EvidenceEventsTableTableManager(
      _$AppDatabase db, $EvidenceEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidenceEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> learnerId = const Value.absent(),
            Value<String> nodeId = const Value.absent(),
            Value<String?> itemId = const Value.absent(),
            Value<EvidenceKind> kind = const Value.absent(),
            Value<double> score = const Value.absent(),
            Value<double> effectiveScore = const Value.absent(),
            Value<double> predicted = const Value.absent(),
            Value<bool> independent = const Value.absent(),
            Value<int> hintLevel = const Value.absent(),
            Value<int> hintRequestCount = const Value.absent(),
            Value<bool> outOfScope = const Value.absent(),
            Value<bool> explainMode = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<double> thetaAfter = const Value.absent(),
            Value<double> masteryAfter = const Value.absent(),
            Value<int?> elapsedSeconds = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EvidenceEventsCompanion(
            id: id,
            learnerId: learnerId,
            nodeId: nodeId,
            itemId: itemId,
            kind: kind,
            score: score,
            effectiveScore: effectiveScore,
            predicted: predicted,
            independent: independent,
            hintLevel: hintLevel,
            hintRequestCount: hintRequestCount,
            outOfScope: outOfScope,
            explainMode: explainMode,
            difficulty: difficulty,
            thetaAfter: thetaAfter,
            masteryAfter: masteryAfter,
            elapsedSeconds: elapsedSeconds,
            source: source,
            payload: payload,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> learnerId = const Value.absent(),
            required String nodeId,
            Value<String?> itemId = const Value.absent(),
            required EvidenceKind kind,
            required double score,
            Value<double> effectiveScore = const Value.absent(),
            Value<double> predicted = const Value.absent(),
            Value<bool> independent = const Value.absent(),
            Value<int> hintLevel = const Value.absent(),
            Value<int> hintRequestCount = const Value.absent(),
            Value<bool> outOfScope = const Value.absent(),
            Value<bool> explainMode = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<double> thetaAfter = const Value.absent(),
            Value<double> masteryAfter = const Value.absent(),
            Value<int?> elapsedSeconds = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> payload = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EvidenceEventsCompanion.insert(
            id: id,
            learnerId: learnerId,
            nodeId: nodeId,
            itemId: itemId,
            kind: kind,
            score: score,
            effectiveScore: effectiveScore,
            predicted: predicted,
            independent: independent,
            hintLevel: hintLevel,
            hintRequestCount: hintRequestCount,
            outOfScope: outOfScope,
            explainMode: explainMode,
            difficulty: difficulty,
            thetaAfter: thetaAfter,
            masteryAfter: masteryAfter,
            elapsedSeconds: elapsedSeconds,
            source: source,
            payload: payload,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EvidenceEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EvidenceEventsTable,
    EvidenceEventRow,
    $$EvidenceEventsTableFilterComposer,
    $$EvidenceEventsTableOrderingComposer,
    $$EvidenceEventsTableAnnotationComposer,
    $$EvidenceEventsTableCreateCompanionBuilder,
    $$EvidenceEventsTableUpdateCompanionBuilder,
    (
      EvidenceEventRow,
      BaseReferences<_$AppDatabase, $EvidenceEventsTable, EvidenceEventRow>
    ),
    EvidenceEventRow,
    PrefetchHooks Function()>;
typedef $$NodeStatesTableCreateCompanionBuilder = NodeStatesCompanion Function({
  required String nodeId,
  Value<String> learnerId,
  Value<double> mastery,
  Value<double> theta,
  Value<int> attempts,
  Value<int> independentAttempts,
  Value<int> independentCorrect,
  Value<int> assistedAttempts,
  Value<int> explainAttempts,
  Value<int> streak,
  Value<String> engineVersion,
  Value<DateTime?> lastSeenAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$NodeStatesTableUpdateCompanionBuilder = NodeStatesCompanion Function({
  Value<String> nodeId,
  Value<String> learnerId,
  Value<double> mastery,
  Value<double> theta,
  Value<int> attempts,
  Value<int> independentAttempts,
  Value<int> independentCorrect,
  Value<int> assistedAttempts,
  Value<int> explainAttempts,
  Value<int> streak,
  Value<String> engineVersion,
  Value<DateTime?> lastSeenAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$NodeStatesTableFilterComposer
    extends Composer<_$AppDatabase, $NodeStatesTable> {
  $$NodeStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get learnerId => $composableBuilder(
      column: $table.learnerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get mastery => $composableBuilder(
      column: $table.mastery, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get theta => $composableBuilder(
      column: $table.theta, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get independentAttempts => $composableBuilder(
      column: $table.independentAttempts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get independentCorrect => $composableBuilder(
      column: $table.independentCorrect,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get assistedAttempts => $composableBuilder(
      column: $table.assistedAttempts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get explainAttempts => $composableBuilder(
      column: $table.explainAttempts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get engineVersion => $composableBuilder(
      column: $table.engineVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NodeStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $NodeStatesTable> {
  $$NodeStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get learnerId => $composableBuilder(
      column: $table.learnerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get mastery => $composableBuilder(
      column: $table.mastery, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get theta => $composableBuilder(
      column: $table.theta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get independentAttempts => $composableBuilder(
      column: $table.independentAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get independentCorrect => $composableBuilder(
      column: $table.independentCorrect,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get assistedAttempts => $composableBuilder(
      column: $table.assistedAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get explainAttempts => $composableBuilder(
      column: $table.explainAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get engineVersion => $composableBuilder(
      column: $table.engineVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NodeStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodeStatesTable> {
  $$NodeStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get learnerId =>
      $composableBuilder(column: $table.learnerId, builder: (column) => column);

  GeneratedColumn<double> get mastery =>
      $composableBuilder(column: $table.mastery, builder: (column) => column);

  GeneratedColumn<double> get theta =>
      $composableBuilder(column: $table.theta, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get independentAttempts => $composableBuilder(
      column: $table.independentAttempts, builder: (column) => column);

  GeneratedColumn<int> get independentCorrect => $composableBuilder(
      column: $table.independentCorrect, builder: (column) => column);

  GeneratedColumn<int> get assistedAttempts => $composableBuilder(
      column: $table.assistedAttempts, builder: (column) => column);

  GeneratedColumn<int> get explainAttempts => $composableBuilder(
      column: $table.explainAttempts, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<String> get engineVersion => $composableBuilder(
      column: $table.engineVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NodeStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NodeStatesTable,
    NodeStateRow,
    $$NodeStatesTableFilterComposer,
    $$NodeStatesTableOrderingComposer,
    $$NodeStatesTableAnnotationComposer,
    $$NodeStatesTableCreateCompanionBuilder,
    $$NodeStatesTableUpdateCompanionBuilder,
    (
      NodeStateRow,
      BaseReferences<_$AppDatabase, $NodeStatesTable, NodeStateRow>
    ),
    NodeStateRow,
    PrefetchHooks Function()> {
  $$NodeStatesTableTableManager(_$AppDatabase db, $NodeStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodeStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodeStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodeStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> nodeId = const Value.absent(),
            Value<String> learnerId = const Value.absent(),
            Value<double> mastery = const Value.absent(),
            Value<double> theta = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> independentAttempts = const Value.absent(),
            Value<int> independentCorrect = const Value.absent(),
            Value<int> assistedAttempts = const Value.absent(),
            Value<int> explainAttempts = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<String> engineVersion = const Value.absent(),
            Value<DateTime?> lastSeenAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NodeStatesCompanion(
            nodeId: nodeId,
            learnerId: learnerId,
            mastery: mastery,
            theta: theta,
            attempts: attempts,
            independentAttempts: independentAttempts,
            independentCorrect: independentCorrect,
            assistedAttempts: assistedAttempts,
            explainAttempts: explainAttempts,
            streak: streak,
            engineVersion: engineVersion,
            lastSeenAt: lastSeenAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String nodeId,
            Value<String> learnerId = const Value.absent(),
            Value<double> mastery = const Value.absent(),
            Value<double> theta = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> independentAttempts = const Value.absent(),
            Value<int> independentCorrect = const Value.absent(),
            Value<int> assistedAttempts = const Value.absent(),
            Value<int> explainAttempts = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<String> engineVersion = const Value.absent(),
            Value<DateTime?> lastSeenAt = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NodeStatesCompanion.insert(
            nodeId: nodeId,
            learnerId: learnerId,
            mastery: mastery,
            theta: theta,
            attempts: attempts,
            independentAttempts: independentAttempts,
            independentCorrect: independentCorrect,
            assistedAttempts: assistedAttempts,
            explainAttempts: explainAttempts,
            streak: streak,
            engineVersion: engineVersion,
            lastSeenAt: lastSeenAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NodeStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NodeStatesTable,
    NodeStateRow,
    $$NodeStatesTableFilterComposer,
    $$NodeStatesTableOrderingComposer,
    $$NodeStatesTableAnnotationComposer,
    $$NodeStatesTableCreateCompanionBuilder,
    $$NodeStatesTableUpdateCompanionBuilder,
    (
      NodeStateRow,
      BaseReferences<_$AppDatabase, $NodeStatesTable, NodeStateRow>
    ),
    NodeStateRow,
    PrefetchHooks Function()>;
typedef $$ItemDifficultyTableCreateCompanionBuilder = ItemDifficultyCompanion
    Function({
  required String itemId,
  required String nodeId,
  Value<double> difficulty,
  Value<double> discrimination,
  Value<int> exposure,
  Value<int> correctCount,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ItemDifficultyTableUpdateCompanionBuilder = ItemDifficultyCompanion
    Function({
  Value<String> itemId,
  Value<String> nodeId,
  Value<double> difficulty,
  Value<double> discrimination,
  Value<int> exposure,
  Value<int> correctCount,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ItemDifficultyTableFilterComposer
    extends Composer<_$AppDatabase, $ItemDifficultyTable> {
  $$ItemDifficultyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discrimination => $composableBuilder(
      column: $table.discrimination,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exposure => $composableBuilder(
      column: $table.exposure, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ItemDifficultyTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemDifficultyTable> {
  $$ItemDifficultyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discrimination => $composableBuilder(
      column: $table.discrimination,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exposure => $composableBuilder(
      column: $table.exposure, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctCount => $composableBuilder(
      column: $table.correctCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ItemDifficultyTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemDifficultyTable> {
  $$ItemDifficultyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<double> get discrimination => $composableBuilder(
      column: $table.discrimination, builder: (column) => column);

  GeneratedColumn<int> get exposure =>
      $composableBuilder(column: $table.exposure, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ItemDifficultyTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemDifficultyTable,
    ItemDifficultyRow,
    $$ItemDifficultyTableFilterComposer,
    $$ItemDifficultyTableOrderingComposer,
    $$ItemDifficultyTableAnnotationComposer,
    $$ItemDifficultyTableCreateCompanionBuilder,
    $$ItemDifficultyTableUpdateCompanionBuilder,
    (
      ItemDifficultyRow,
      BaseReferences<_$AppDatabase, $ItemDifficultyTable, ItemDifficultyRow>
    ),
    ItemDifficultyRow,
    PrefetchHooks Function()> {
  $$ItemDifficultyTableTableManager(
      _$AppDatabase db, $ItemDifficultyTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemDifficultyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemDifficultyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemDifficultyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> itemId = const Value.absent(),
            Value<String> nodeId = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<double> discrimination = const Value.absent(),
            Value<int> exposure = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemDifficultyCompanion(
            itemId: itemId,
            nodeId: nodeId,
            difficulty: difficulty,
            discrimination: discrimination,
            exposure: exposure,
            correctCount: correctCount,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String itemId,
            required String nodeId,
            Value<double> difficulty = const Value.absent(),
            Value<double> discrimination = const Value.absent(),
            Value<int> exposure = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemDifficultyCompanion.insert(
            itemId: itemId,
            nodeId: nodeId,
            difficulty: difficulty,
            discrimination: discrimination,
            exposure: exposure,
            correctCount: correctCount,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ItemDifficultyTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemDifficultyTable,
    ItemDifficultyRow,
    $$ItemDifficultyTableFilterComposer,
    $$ItemDifficultyTableOrderingComposer,
    $$ItemDifficultyTableAnnotationComposer,
    $$ItemDifficultyTableCreateCompanionBuilder,
    $$ItemDifficultyTableUpdateCompanionBuilder,
    (
      ItemDifficultyRow,
      BaseReferences<_$AppDatabase, $ItemDifficultyTable, ItemDifficultyRow>
    ),
    ItemDifficultyRow,
    PrefetchHooks Function()>;
typedef $$VocabStatesTableCreateCompanionBuilder = VocabStatesCompanion
    Function({
  required String wordId,
  required String lemma,
  Value<String> reading,
  Value<String> gloss,
  Value<String> dimension,
  Value<String> clusterId,
  Value<int> box,
  Value<double> ease,
  Value<int> reps,
  Value<int> lapses,
  Value<int> lastRating,
  required DateTime dueAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$VocabStatesTableUpdateCompanionBuilder = VocabStatesCompanion
    Function({
  Value<String> wordId,
  Value<String> lemma,
  Value<String> reading,
  Value<String> gloss,
  Value<String> dimension,
  Value<String> clusterId,
  Value<int> box,
  Value<double> ease,
  Value<int> reps,
  Value<int> lapses,
  Value<int> lastRating,
  Value<DateTime> dueAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$VocabStatesTableFilterComposer
    extends Composer<_$AppDatabase, $VocabStatesTable> {
  $$VocabStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lemma => $composableBuilder(
      column: $table.lemma, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reading => $composableBuilder(
      column: $table.reading, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gloss => $composableBuilder(
      column: $table.gloss, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dimension => $composableBuilder(
      column: $table.dimension, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clusterId => $composableBuilder(
      column: $table.clusterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get box => $composableBuilder(
      column: $table.box, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ease => $composableBuilder(
      column: $table.ease, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastRating => $composableBuilder(
      column: $table.lastRating, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$VocabStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabStatesTable> {
  $$VocabStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lemma => $composableBuilder(
      column: $table.lemma, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reading => $composableBuilder(
      column: $table.reading, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gloss => $composableBuilder(
      column: $table.gloss, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dimension => $composableBuilder(
      column: $table.dimension, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clusterId => $composableBuilder(
      column: $table.clusterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get box => $composableBuilder(
      column: $table.box, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ease => $composableBuilder(
      column: $table.ease, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastRating => $composableBuilder(
      column: $table.lastRating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$VocabStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabStatesTable> {
  $$VocabStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);

  GeneratedColumn<String> get gloss =>
      $composableBuilder(column: $table.gloss, builder: (column) => column);

  GeneratedColumn<String> get dimension =>
      $composableBuilder(column: $table.dimension, builder: (column) => column);

  GeneratedColumn<String> get clusterId =>
      $composableBuilder(column: $table.clusterId, builder: (column) => column);

  GeneratedColumn<int> get box =>
      $composableBuilder(column: $table.box, builder: (column) => column);

  GeneratedColumn<double> get ease =>
      $composableBuilder(column: $table.ease, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<int> get lastRating => $composableBuilder(
      column: $table.lastRating, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VocabStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabStatesTable,
    VocabStateRow,
    $$VocabStatesTableFilterComposer,
    $$VocabStatesTableOrderingComposer,
    $$VocabStatesTableAnnotationComposer,
    $$VocabStatesTableCreateCompanionBuilder,
    $$VocabStatesTableUpdateCompanionBuilder,
    (
      VocabStateRow,
      BaseReferences<_$AppDatabase, $VocabStatesTable, VocabStateRow>
    ),
    VocabStateRow,
    PrefetchHooks Function()> {
  $$VocabStatesTableTableManager(_$AppDatabase db, $VocabStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> wordId = const Value.absent(),
            Value<String> lemma = const Value.absent(),
            Value<String> reading = const Value.absent(),
            Value<String> gloss = const Value.absent(),
            Value<String> dimension = const Value.absent(),
            Value<String> clusterId = const Value.absent(),
            Value<int> box = const Value.absent(),
            Value<double> ease = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            Value<int> lastRating = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabStatesCompanion(
            wordId: wordId,
            lemma: lemma,
            reading: reading,
            gloss: gloss,
            dimension: dimension,
            clusterId: clusterId,
            box: box,
            ease: ease,
            reps: reps,
            lapses: lapses,
            lastRating: lastRating,
            dueAt: dueAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String wordId,
            required String lemma,
            Value<String> reading = const Value.absent(),
            Value<String> gloss = const Value.absent(),
            Value<String> dimension = const Value.absent(),
            Value<String> clusterId = const Value.absent(),
            Value<int> box = const Value.absent(),
            Value<double> ease = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            Value<int> lastRating = const Value.absent(),
            required DateTime dueAt,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabStatesCompanion.insert(
            wordId: wordId,
            lemma: lemma,
            reading: reading,
            gloss: gloss,
            dimension: dimension,
            clusterId: clusterId,
            box: box,
            ease: ease,
            reps: reps,
            lapses: lapses,
            lastRating: lastRating,
            dueAt: dueAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VocabStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabStatesTable,
    VocabStateRow,
    $$VocabStatesTableFilterComposer,
    $$VocabStatesTableOrderingComposer,
    $$VocabStatesTableAnnotationComposer,
    $$VocabStatesTableCreateCompanionBuilder,
    $$VocabStatesTableUpdateCompanionBuilder,
    (
      VocabStateRow,
      BaseReferences<_$AppDatabase, $VocabStatesTable, VocabStateRow>
    ),
    VocabStateRow,
    PrefetchHooks Function()>;
typedef $$AchievementStatesTableCreateCompanionBuilder
    = AchievementStatesCompanion Function({
  required String achievementId,
  Value<String> tier,
  Value<double> progress,
  Value<bool> independent,
  Value<int> xpAwarded,
  Value<DateTime?> unlockedAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AchievementStatesTableUpdateCompanionBuilder
    = AchievementStatesCompanion Function({
  Value<String> achievementId,
  Value<String> tier,
  Value<double> progress,
  Value<bool> independent,
  Value<int> xpAwarded,
  Value<DateTime?> unlockedAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AchievementStatesTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementStatesTable> {
  $$AchievementStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get achievementId => $composableBuilder(
      column: $table.achievementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get independent => $composableBuilder(
      column: $table.independent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpAwarded => $composableBuilder(
      column: $table.xpAwarded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AchievementStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementStatesTable> {
  $$AchievementStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get achievementId => $composableBuilder(
      column: $table.achievementId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get independent => $composableBuilder(
      column: $table.independent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpAwarded => $composableBuilder(
      column: $table.xpAwarded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AchievementStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementStatesTable> {
  $$AchievementStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get achievementId => $composableBuilder(
      column: $table.achievementId, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get independent => $composableBuilder(
      column: $table.independent, builder: (column) => column);

  GeneratedColumn<int> get xpAwarded =>
      $composableBuilder(column: $table.xpAwarded, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AchievementStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementStatesTable,
    AchievementStateRow,
    $$AchievementStatesTableFilterComposer,
    $$AchievementStatesTableOrderingComposer,
    $$AchievementStatesTableAnnotationComposer,
    $$AchievementStatesTableCreateCompanionBuilder,
    $$AchievementStatesTableUpdateCompanionBuilder,
    (
      AchievementStateRow,
      BaseReferences<_$AppDatabase, $AchievementStatesTable,
          AchievementStateRow>
    ),
    AchievementStateRow,
    PrefetchHooks Function()> {
  $$AchievementStatesTableTableManager(
      _$AppDatabase db, $AchievementStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementStatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> achievementId = const Value.absent(),
            Value<String> tier = const Value.absent(),
            Value<double> progress = const Value.absent(),
            Value<bool> independent = const Value.absent(),
            Value<int> xpAwarded = const Value.absent(),
            Value<DateTime?> unlockedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementStatesCompanion(
            achievementId: achievementId,
            tier: tier,
            progress: progress,
            independent: independent,
            xpAwarded: xpAwarded,
            unlockedAt: unlockedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String achievementId,
            Value<String> tier = const Value.absent(),
            Value<double> progress = const Value.absent(),
            Value<bool> independent = const Value.absent(),
            Value<int> xpAwarded = const Value.absent(),
            Value<DateTime?> unlockedAt = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementStatesCompanion.insert(
            achievementId: achievementId,
            tier: tier,
            progress: progress,
            independent: independent,
            xpAwarded: xpAwarded,
            unlockedAt: unlockedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementStatesTable,
    AchievementStateRow,
    $$AchievementStatesTableFilterComposer,
    $$AchievementStatesTableOrderingComposer,
    $$AchievementStatesTableAnnotationComposer,
    $$AchievementStatesTableCreateCompanionBuilder,
    $$AchievementStatesTableUpdateCompanionBuilder,
    (
      AchievementStateRow,
      BaseReferences<_$AppDatabase, $AchievementStatesTable,
          AchievementStateRow>
    ),
    AchievementStateRow,
    PrefetchHooks Function()>;
typedef $$HintEventsTableCreateCompanionBuilder = HintEventsCompanion Function({
  required String id,
  Value<String> learnerId,
  required String itemId,
  required String nodeId,
  required String selectedText,
  required String selectionType,
  required String intent,
  Value<int> hintLevel,
  Value<bool> answerRevealed,
  Value<bool> outOfScope,
  Value<bool> explainMode,
  Value<bool> filtered,
  Value<bool> servedOffline,
  Value<int> latencyMs,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$HintEventsTableUpdateCompanionBuilder = HintEventsCompanion Function({
  Value<String> id,
  Value<String> learnerId,
  Value<String> itemId,
  Value<String> nodeId,
  Value<String> selectedText,
  Value<String> selectionType,
  Value<String> intent,
  Value<int> hintLevel,
  Value<bool> answerRevealed,
  Value<bool> outOfScope,
  Value<bool> explainMode,
  Value<bool> filtered,
  Value<bool> servedOffline,
  Value<int> latencyMs,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$HintEventsTableFilterComposer
    extends Composer<_$AppDatabase, $HintEventsTable> {
  $$HintEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get learnerId => $composableBuilder(
      column: $table.learnerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedText => $composableBuilder(
      column: $table.selectedText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectionType => $composableBuilder(
      column: $table.selectionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get intent => $composableBuilder(
      column: $table.intent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hintLevel => $composableBuilder(
      column: $table.hintLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get answerRevealed => $composableBuilder(
      column: $table.answerRevealed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get outOfScope => $composableBuilder(
      column: $table.outOfScope, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get explainMode => $composableBuilder(
      column: $table.explainMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get filtered => $composableBuilder(
      column: $table.filtered, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get servedOffline => $composableBuilder(
      column: $table.servedOffline, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get latencyMs => $composableBuilder(
      column: $table.latencyMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$HintEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $HintEventsTable> {
  $$HintEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get learnerId => $composableBuilder(
      column: $table.learnerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedText => $composableBuilder(
      column: $table.selectedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectionType => $composableBuilder(
      column: $table.selectionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get intent => $composableBuilder(
      column: $table.intent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hintLevel => $composableBuilder(
      column: $table.hintLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get answerRevealed => $composableBuilder(
      column: $table.answerRevealed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get outOfScope => $composableBuilder(
      column: $table.outOfScope, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get explainMode => $composableBuilder(
      column: $table.explainMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get filtered => $composableBuilder(
      column: $table.filtered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get servedOffline => $composableBuilder(
      column: $table.servedOffline,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get latencyMs => $composableBuilder(
      column: $table.latencyMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$HintEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HintEventsTable> {
  $$HintEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get learnerId =>
      $composableBuilder(column: $table.learnerId, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get selectedText => $composableBuilder(
      column: $table.selectedText, builder: (column) => column);

  GeneratedColumn<String> get selectionType => $composableBuilder(
      column: $table.selectionType, builder: (column) => column);

  GeneratedColumn<String> get intent =>
      $composableBuilder(column: $table.intent, builder: (column) => column);

  GeneratedColumn<int> get hintLevel =>
      $composableBuilder(column: $table.hintLevel, builder: (column) => column);

  GeneratedColumn<bool> get answerRevealed => $composableBuilder(
      column: $table.answerRevealed, builder: (column) => column);

  GeneratedColumn<bool> get outOfScope => $composableBuilder(
      column: $table.outOfScope, builder: (column) => column);

  GeneratedColumn<bool> get explainMode => $composableBuilder(
      column: $table.explainMode, builder: (column) => column);

  GeneratedColumn<bool> get filtered =>
      $composableBuilder(column: $table.filtered, builder: (column) => column);

  GeneratedColumn<bool> get servedOffline => $composableBuilder(
      column: $table.servedOffline, builder: (column) => column);

  GeneratedColumn<int> get latencyMs =>
      $composableBuilder(column: $table.latencyMs, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HintEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HintEventsTable,
    HintEventRow,
    $$HintEventsTableFilterComposer,
    $$HintEventsTableOrderingComposer,
    $$HintEventsTableAnnotationComposer,
    $$HintEventsTableCreateCompanionBuilder,
    $$HintEventsTableUpdateCompanionBuilder,
    (
      HintEventRow,
      BaseReferences<_$AppDatabase, $HintEventsTable, HintEventRow>
    ),
    HintEventRow,
    PrefetchHooks Function()> {
  $$HintEventsTableTableManager(_$AppDatabase db, $HintEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HintEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HintEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HintEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> learnerId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> nodeId = const Value.absent(),
            Value<String> selectedText = const Value.absent(),
            Value<String> selectionType = const Value.absent(),
            Value<String> intent = const Value.absent(),
            Value<int> hintLevel = const Value.absent(),
            Value<bool> answerRevealed = const Value.absent(),
            Value<bool> outOfScope = const Value.absent(),
            Value<bool> explainMode = const Value.absent(),
            Value<bool> filtered = const Value.absent(),
            Value<bool> servedOffline = const Value.absent(),
            Value<int> latencyMs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HintEventsCompanion(
            id: id,
            learnerId: learnerId,
            itemId: itemId,
            nodeId: nodeId,
            selectedText: selectedText,
            selectionType: selectionType,
            intent: intent,
            hintLevel: hintLevel,
            answerRevealed: answerRevealed,
            outOfScope: outOfScope,
            explainMode: explainMode,
            filtered: filtered,
            servedOffline: servedOffline,
            latencyMs: latencyMs,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> learnerId = const Value.absent(),
            required String itemId,
            required String nodeId,
            required String selectedText,
            required String selectionType,
            required String intent,
            Value<int> hintLevel = const Value.absent(),
            Value<bool> answerRevealed = const Value.absent(),
            Value<bool> outOfScope = const Value.absent(),
            Value<bool> explainMode = const Value.absent(),
            Value<bool> filtered = const Value.absent(),
            Value<bool> servedOffline = const Value.absent(),
            Value<int> latencyMs = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HintEventsCompanion.insert(
            id: id,
            learnerId: learnerId,
            itemId: itemId,
            nodeId: nodeId,
            selectedText: selectedText,
            selectionType: selectionType,
            intent: intent,
            hintLevel: hintLevel,
            answerRevealed: answerRevealed,
            outOfScope: outOfScope,
            explainMode: explainMode,
            filtered: filtered,
            servedOffline: servedOffline,
            latencyMs: latencyMs,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HintEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HintEventsTable,
    HintEventRow,
    $$HintEventsTableFilterComposer,
    $$HintEventsTableOrderingComposer,
    $$HintEventsTableAnnotationComposer,
    $$HintEventsTableCreateCompanionBuilder,
    $$HintEventsTableUpdateCompanionBuilder,
    (
      HintEventRow,
      BaseReferences<_$AppDatabase, $HintEventsTable, HintEventRow>
    ),
    HintEventRow,
    PrefetchHooks Function()>;
typedef $$AttemptsTableCreateCompanionBuilder = AttemptsCompanion Function({
  required String id,
  required String itemId,
  required String nodeId,
  required AttemptMode mode,
  Value<int> hintLevel,
  Value<int> hintRequestCount,
  Value<bool> assisted,
  Value<bool> answerRevealed,
  Value<bool?> correct,
  Value<String> selectedAnswer,
  Value<int> elapsedSeconds,
  required DateTime startedAt,
  Value<DateTime?> finishedAt,
  Value<int> rowid,
});
typedef $$AttemptsTableUpdateCompanionBuilder = AttemptsCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String> nodeId,
  Value<AttemptMode> mode,
  Value<int> hintLevel,
  Value<int> hintRequestCount,
  Value<bool> assisted,
  Value<bool> answerRevealed,
  Value<bool?> correct,
  Value<String> selectedAnswer,
  Value<int> elapsedSeconds,
  Value<DateTime> startedAt,
  Value<DateTime?> finishedAt,
  Value<int> rowid,
});

class $$AttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AttemptMode, AttemptMode, String> get mode =>
      $composableBuilder(
          column: $table.mode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get hintLevel => $composableBuilder(
      column: $table.hintLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hintRequestCount => $composableBuilder(
      column: $table.hintRequestCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get assisted => $composableBuilder(
      column: $table.assisted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get answerRevealed => $composableBuilder(
      column: $table.answerRevealed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedAnswer => $composableBuilder(
      column: $table.selectedAnswer,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
      column: $table.elapsedSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnFilters(column));
}

class $$AttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nodeId => $composableBuilder(
      column: $table.nodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hintLevel => $composableBuilder(
      column: $table.hintLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hintRequestCount => $composableBuilder(
      column: $table.hintRequestCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get assisted => $composableBuilder(
      column: $table.assisted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get answerRevealed => $composableBuilder(
      column: $table.answerRevealed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedAnswer => $composableBuilder(
      column: $table.selectedAnswer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
      column: $table.elapsedSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnOrderings(column));
}

class $$AttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AttemptMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get hintLevel =>
      $composableBuilder(column: $table.hintLevel, builder: (column) => column);

  GeneratedColumn<int> get hintRequestCount => $composableBuilder(
      column: $table.hintRequestCount, builder: (column) => column);

  GeneratedColumn<bool> get assisted =>
      $composableBuilder(column: $table.assisted, builder: (column) => column);

  GeneratedColumn<bool> get answerRevealed => $composableBuilder(
      column: $table.answerRevealed, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<String> get selectedAnswer => $composableBuilder(
      column: $table.selectedAnswer, builder: (column) => column);

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
      column: $table.elapsedSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => column);
}

class $$AttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttemptsTable,
    AttemptRow,
    $$AttemptsTableFilterComposer,
    $$AttemptsTableOrderingComposer,
    $$AttemptsTableAnnotationComposer,
    $$AttemptsTableCreateCompanionBuilder,
    $$AttemptsTableUpdateCompanionBuilder,
    (AttemptRow, BaseReferences<_$AppDatabase, $AttemptsTable, AttemptRow>),
    AttemptRow,
    PrefetchHooks Function()> {
  $$AttemptsTableTableManager(_$AppDatabase db, $AttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> nodeId = const Value.absent(),
            Value<AttemptMode> mode = const Value.absent(),
            Value<int> hintLevel = const Value.absent(),
            Value<int> hintRequestCount = const Value.absent(),
            Value<bool> assisted = const Value.absent(),
            Value<bool> answerRevealed = const Value.absent(),
            Value<bool?> correct = const Value.absent(),
            Value<String> selectedAnswer = const Value.absent(),
            Value<int> elapsedSeconds = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> finishedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttemptsCompanion(
            id: id,
            itemId: itemId,
            nodeId: nodeId,
            mode: mode,
            hintLevel: hintLevel,
            hintRequestCount: hintRequestCount,
            assisted: assisted,
            answerRevealed: answerRevealed,
            correct: correct,
            selectedAnswer: selectedAnswer,
            elapsedSeconds: elapsedSeconds,
            startedAt: startedAt,
            finishedAt: finishedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String itemId,
            required String nodeId,
            required AttemptMode mode,
            Value<int> hintLevel = const Value.absent(),
            Value<int> hintRequestCount = const Value.absent(),
            Value<bool> assisted = const Value.absent(),
            Value<bool> answerRevealed = const Value.absent(),
            Value<bool?> correct = const Value.absent(),
            Value<String> selectedAnswer = const Value.absent(),
            Value<int> elapsedSeconds = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> finishedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttemptsCompanion.insert(
            id: id,
            itemId: itemId,
            nodeId: nodeId,
            mode: mode,
            hintLevel: hintLevel,
            hintRequestCount: hintRequestCount,
            assisted: assisted,
            answerRevealed: answerRevealed,
            correct: correct,
            selectedAnswer: selectedAnswer,
            elapsedSeconds: elapsedSeconds,
            startedAt: startedAt,
            finishedAt: finishedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttemptsTable,
    AttemptRow,
    $$AttemptsTableFilterComposer,
    $$AttemptsTableOrderingComposer,
    $$AttemptsTableAnnotationComposer,
    $$AttemptsTableCreateCompanionBuilder,
    $$AttemptsTableUpdateCompanionBuilder,
    (AttemptRow, BaseReferences<_$AppDatabase, $AttemptsTable, AttemptRow>),
    AttemptRow,
    PrefetchHooks Function()>;
typedef $$ContentPackVersionsTableCreateCompanionBuilder
    = ContentPackVersionsCompanion Function({
  required String packId,
  required String version,
  required DateTime installedAt,
  Value<String> checksum,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$ContentPackVersionsTableUpdateCompanionBuilder
    = ContentPackVersionsCompanion Function({
  Value<String> packId,
  Value<String> version,
  Value<DateTime> installedAt,
  Value<String> checksum,
  Value<bool> active,
  Value<int> rowid,
});

class $$ContentPackVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentPackVersionsTable> {
  $$ContentPackVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packId => $composableBuilder(
      column: $table.packId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
      column: $table.installedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));
}

class $$ContentPackVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentPackVersionsTable> {
  $$ContentPackVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packId => $composableBuilder(
      column: $table.packId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
      column: $table.installedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));
}

class $$ContentPackVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentPackVersionsTable> {
  $$ContentPackVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
      column: $table.installedAt, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$ContentPackVersionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContentPackVersionsTable,
    ContentPackVersionRow,
    $$ContentPackVersionsTableFilterComposer,
    $$ContentPackVersionsTableOrderingComposer,
    $$ContentPackVersionsTableAnnotationComposer,
    $$ContentPackVersionsTableCreateCompanionBuilder,
    $$ContentPackVersionsTableUpdateCompanionBuilder,
    (
      ContentPackVersionRow,
      BaseReferences<_$AppDatabase, $ContentPackVersionsTable,
          ContentPackVersionRow>
    ),
    ContentPackVersionRow,
    PrefetchHooks Function()> {
  $$ContentPackVersionsTableTableManager(
      _$AppDatabase db, $ContentPackVersionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentPackVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentPackVersionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentPackVersionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> packId = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<DateTime> installedAt = const Value.absent(),
            Value<String> checksum = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentPackVersionsCompanion(
            packId: packId,
            version: version,
            installedAt: installedAt,
            checksum: checksum,
            active: active,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String packId,
            required String version,
            required DateTime installedAt,
            Value<String> checksum = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentPackVersionsCompanion.insert(
            packId: packId,
            version: version,
            installedAt: installedAt,
            checksum: checksum,
            active: active,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContentPackVersionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContentPackVersionsTable,
    ContentPackVersionRow,
    $$ContentPackVersionsTableFilterComposer,
    $$ContentPackVersionsTableOrderingComposer,
    $$ContentPackVersionsTableAnnotationComposer,
    $$ContentPackVersionsTableCreateCompanionBuilder,
    $$ContentPackVersionsTableUpdateCompanionBuilder,
    (
      ContentPackVersionRow,
      BaseReferences<_$AppDatabase, $ContentPackVersionsTable,
          ContentPackVersionRow>
    ),
    ContentPackVersionRow,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  required String entity,
  required String payload,
  required DateTime createdAt,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> entity,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<bool> synced,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueRow,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueRow,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueRow>
    ),
    SyncQueueRow,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entity = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            entity: entity,
            payload: payload,
            createdAt: createdAt,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entity,
            required String payload,
            required DateTime createdAt,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            entity: entity,
            payload: payload,
            createdAt: createdAt,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueRow,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueRow,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueRow>
    ),
    SyncQueueRow,
    PrefetchHooks Function()>;
typedef $$DailyStatsTableCreateCompanionBuilder = DailyStatsCompanion Function({
  required DateTime day,
  Value<int> evidenceCount,
  Value<int> independentCount,
  Value<int> hintCount,
  Value<int> reviewCount,
  Value<int> minutes,
  Value<int> rowid,
});
typedef $$DailyStatsTableUpdateCompanionBuilder = DailyStatsCompanion Function({
  Value<DateTime> day,
  Value<int> evidenceCount,
  Value<int> independentCount,
  Value<int> hintCount,
  Value<int> reviewCount,
  Value<int> minutes,
  Value<int> rowid,
});

class $$DailyStatsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get evidenceCount => $composableBuilder(
      column: $table.evidenceCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get independentCount => $composableBuilder(
      column: $table.independentCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hintCount => $composableBuilder(
      column: $table.hintCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minutes => $composableBuilder(
      column: $table.minutes, builder: (column) => ColumnFilters(column));
}

class $$DailyStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get evidenceCount => $composableBuilder(
      column: $table.evidenceCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get independentCount => $composableBuilder(
      column: $table.independentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hintCount => $composableBuilder(
      column: $table.hintCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minutes => $composableBuilder(
      column: $table.minutes, builder: (column) => ColumnOrderings(column));
}

class $$DailyStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get evidenceCount => $composableBuilder(
      column: $table.evidenceCount, builder: (column) => column);

  GeneratedColumn<int> get independentCount => $composableBuilder(
      column: $table.independentCount, builder: (column) => column);

  GeneratedColumn<int> get hintCount =>
      $composableBuilder(column: $table.hintCount, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);
}

class $$DailyStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyStatsTable,
    DailyStatRow,
    $$DailyStatsTableFilterComposer,
    $$DailyStatsTableOrderingComposer,
    $$DailyStatsTableAnnotationComposer,
    $$DailyStatsTableCreateCompanionBuilder,
    $$DailyStatsTableUpdateCompanionBuilder,
    (
      DailyStatRow,
      BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStatRow>
    ),
    DailyStatRow,
    PrefetchHooks Function()> {
  $$DailyStatsTableTableManager(_$AppDatabase db, $DailyStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> day = const Value.absent(),
            Value<int> evidenceCount = const Value.absent(),
            Value<int> independentCount = const Value.absent(),
            Value<int> hintCount = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> minutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyStatsCompanion(
            day: day,
            evidenceCount: evidenceCount,
            independentCount: independentCount,
            hintCount: hintCount,
            reviewCount: reviewCount,
            minutes: minutes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime day,
            Value<int> evidenceCount = const Value.absent(),
            Value<int> independentCount = const Value.absent(),
            Value<int> hintCount = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> minutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyStatsCompanion.insert(
            day: day,
            evidenceCount: evidenceCount,
            independentCount: independentCount,
            hintCount: hintCount,
            reviewCount: reviewCount,
            minutes: minutes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyStatsTable,
    DailyStatRow,
    $$DailyStatsTableFilterComposer,
    $$DailyStatsTableOrderingComposer,
    $$DailyStatsTableAnnotationComposer,
    $$DailyStatsTableCreateCompanionBuilder,
    $$DailyStatsTableUpdateCompanionBuilder,
    (
      DailyStatRow,
      BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStatRow>
    ),
    DailyStatRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EvidenceEventsTableTableManager get evidenceEvents =>
      $$EvidenceEventsTableTableManager(_db, _db.evidenceEvents);
  $$NodeStatesTableTableManager get nodeStates =>
      $$NodeStatesTableTableManager(_db, _db.nodeStates);
  $$ItemDifficultyTableTableManager get itemDifficulty =>
      $$ItemDifficultyTableTableManager(_db, _db.itemDifficulty);
  $$VocabStatesTableTableManager get vocabStates =>
      $$VocabStatesTableTableManager(_db, _db.vocabStates);
  $$AchievementStatesTableTableManager get achievementStates =>
      $$AchievementStatesTableTableManager(_db, _db.achievementStates);
  $$HintEventsTableTableManager get hintEvents =>
      $$HintEventsTableTableManager(_db, _db.hintEvents);
  $$AttemptsTableTableManager get attempts =>
      $$AttemptsTableTableManager(_db, _db.attempts);
  $$ContentPackVersionsTableTableManager get contentPackVersions =>
      $$ContentPackVersionsTableTableManager(_db, _db.contentPackVersions);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$DailyStatsTableTableManager get dailyStats =>
      $$DailyStatsTableTableManager(_db, _db.dailyStats);
}
