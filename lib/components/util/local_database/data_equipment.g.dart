// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_equipment.dart';

// ignore_for_file: type=lint
class $DataEquipmentTable extends DataEquipment
    with TableInfo<$DataEquipmentTable, EquipmentsTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DataEquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idTeamMeta = const VerificationMeta('idTeam');
  @override
  late final GeneratedColumn<String> idTeam = GeneratedColumn<String>(
      'id_team', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _seasonMeta = const VerificationMeta('season');
  @override
  late final GeneratedColumn<String> season = GeneratedColumn<String>(
      'season', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, idTeam, imageUrl, season];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'data_equipment';
  @override
  VerificationContext validateIntegrity(Insertable<EquipmentsTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_team')) {
      context.handle(_idTeamMeta,
          idTeam.isAcceptableOrUnknown(data['id_team']!, _idTeamMeta));
    } else if (isInserting) {
      context.missing(_idTeamMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('season')) {
      context.handle(_seasonMeta,
          season.isAcceptableOrUnknown(data['season']!, _seasonMeta));
    } else if (isInserting) {
      context.missing(_seasonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  EquipmentsTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentsTable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      idTeam: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_team'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url'])!,
      season: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}season'])!,
    );
  }

  @override
  $DataEquipmentTable createAlias(String alias) {
    return $DataEquipmentTable(attachedDatabase, alias);
  }
}

class EquipmentsTable extends DataClass implements Insertable<EquipmentsTable> {
  final String id;
  final String idTeam;
  final String imageUrl;
  final String season;
  const EquipmentsTable(
      {required this.id,
      required this.idTeam,
      required this.imageUrl,
      required this.season});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_team'] = Variable<String>(idTeam);
    map['image_url'] = Variable<String>(imageUrl);
    map['season'] = Variable<String>(season);
    return map;
  }

  DataEquipmentCompanion toCompanion(bool nullToAbsent) {
    return DataEquipmentCompanion(
      id: Value(id),
      idTeam: Value(idTeam),
      imageUrl: Value(imageUrl),
      season: Value(season),
    );
  }

  factory EquipmentsTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentsTable(
      id: serializer.fromJson<String>(json['id']),
      idTeam: serializer.fromJson<String>(json['idTeam']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      season: serializer.fromJson<String>(json['season']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idTeam': serializer.toJson<String>(idTeam),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'season': serializer.toJson<String>(season),
    };
  }

  EquipmentsTable copyWith(
          {String? id, String? idTeam, String? imageUrl, String? season}) =>
      EquipmentsTable(
        id: id ?? this.id,
        idTeam: idTeam ?? this.idTeam,
        imageUrl: imageUrl ?? this.imageUrl,
        season: season ?? this.season,
      );
  EquipmentsTable copyWithCompanion(DataEquipmentCompanion data) {
    return EquipmentsTable(
      id: data.id.present ? data.id.value : this.id,
      idTeam: data.idTeam.present ? data.idTeam.value : this.idTeam,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      season: data.season.present ? data.season.value : this.season,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentsTable(')
          ..write('id: $id, ')
          ..write('idTeam: $idTeam, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('season: $season')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idTeam, imageUrl, season);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentsTable &&
          other.id == this.id &&
          other.idTeam == this.idTeam &&
          other.imageUrl == this.imageUrl &&
          other.season == this.season);
}

class DataEquipmentCompanion extends UpdateCompanion<EquipmentsTable> {
  final Value<String> id;
  final Value<String> idTeam;
  final Value<String> imageUrl;
  final Value<String> season;
  final Value<int> rowid;
  const DataEquipmentCompanion({
    this.id = const Value.absent(),
    this.idTeam = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.season = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DataEquipmentCompanion.insert({
    required String id,
    required String idTeam,
    required String imageUrl,
    required String season,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        idTeam = Value(idTeam),
        imageUrl = Value(imageUrl),
        season = Value(season);
  static Insertable<EquipmentsTable> custom({
    Expression<String>? id,
    Expression<String>? idTeam,
    Expression<String>? imageUrl,
    Expression<String>? season,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idTeam != null) 'id_team': idTeam,
      if (imageUrl != null) 'image_url': imageUrl,
      if (season != null) 'season': season,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DataEquipmentCompanion copyWith(
      {Value<String>? id,
      Value<String>? idTeam,
      Value<String>? imageUrl,
      Value<String>? season,
      Value<int>? rowid}) {
    return DataEquipmentCompanion(
      id: id ?? this.id,
      idTeam: idTeam ?? this.idTeam,
      imageUrl: imageUrl ?? this.imageUrl,
      season: season ?? this.season,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idTeam.present) {
      map['id_team'] = Variable<String>(idTeam.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (season.present) {
      map['season'] = Variable<String>(season.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DataEquipmentCompanion(')
          ..write('id: $id, ')
          ..write('idTeam: $idTeam, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('season: $season, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DataEquipmentViewData extends DataClass {
  final String id;
  final String idTeam;
  final String imageUrl;
  final String season;
  const DataEquipmentViewData(
      {required this.id,
      required this.idTeam,
      required this.imageUrl,
      required this.season});
  factory DataEquipmentViewData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DataEquipmentViewData(
      id: serializer.fromJson<String>(json['id']),
      idTeam: serializer.fromJson<String>(json['idTeam']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      season: serializer.fromJson<String>(json['season']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idTeam': serializer.toJson<String>(idTeam),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'season': serializer.toJson<String>(season),
    };
  }

  DataEquipmentViewData copyWith(
          {String? id, String? idTeam, String? imageUrl, String? season}) =>
      DataEquipmentViewData(
        id: id ?? this.id,
        idTeam: idTeam ?? this.idTeam,
        imageUrl: imageUrl ?? this.imageUrl,
        season: season ?? this.season,
      );
  @override
  String toString() {
    return (StringBuffer('DataEquipmentViewData(')
          ..write('id: $id, ')
          ..write('idTeam: $idTeam, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('season: $season')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idTeam, imageUrl, season);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataEquipmentViewData &&
          other.id == this.id &&
          other.idTeam == this.idTeam &&
          other.imageUrl == this.imageUrl &&
          other.season == this.season);
}

class $DataEquipmentViewView
    extends ViewInfo<$DataEquipmentViewView, DataEquipmentViewData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$Database attachedDatabase;
  $DataEquipmentViewView(this.attachedDatabase, [this._alias]);
  $DataEquipmentTable get equipments =>
      attachedDatabase.dataEquipment.createAlias('t0');
  @override
  List<GeneratedColumn> get $columns => [id, idTeam, imageUrl, season];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'data_equipment_view';
  @override
  Map<SqlDialect, String>? get createViewStatements => null;
  @override
  $DataEquipmentViewView get asDslTable => this;
  @override
  DataEquipmentViewData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DataEquipmentViewData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      idTeam: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_team'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url'])!,
      season: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}season'])!,
    );
  }

  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      generatedAs: GeneratedAs(equipments.id, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<String> idTeam = GeneratedColumn<String>(
      'id_team', aliasedName, false,
      generatedAs: GeneratedAs(equipments.idTeam, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, false,
      generatedAs: GeneratedAs(equipments.imageUrl, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<String> season = GeneratedColumn<String>(
      'season', aliasedName, false,
      generatedAs: GeneratedAs(equipments.season, false),
      type: DriftSqlType.string);
  @override
  $DataEquipmentViewView createAlias(String alias) {
    return $DataEquipmentViewView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(equipments)..addColumns($columns));
  @override
  Set<String> get readTables => const {'data_equipment'};
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $DataEquipmentTable dataEquipment = $DataEquipmentTable(this);
  late final $DataEquipmentViewView dataEquipmentView =
      $DataEquipmentViewView(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dataEquipment, dataEquipmentView];
}

typedef $$DataEquipmentTableCreateCompanionBuilder = DataEquipmentCompanion
    Function({
  required String id,
  required String idTeam,
  required String imageUrl,
  required String season,
  Value<int> rowid,
});
typedef $$DataEquipmentTableUpdateCompanionBuilder = DataEquipmentCompanion
    Function({
  Value<String> id,
  Value<String> idTeam,
  Value<String> imageUrl,
  Value<String> season,
  Value<int> rowid,
});

class $$DataEquipmentTableFilterComposer
    extends Composer<_$Database, $DataEquipmentTable> {
  $$DataEquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idTeam => $composableBuilder(
      column: $table.idTeam, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get season => $composableBuilder(
      column: $table.season, builder: (column) => ColumnFilters(column));
}

class $$DataEquipmentTableOrderingComposer
    extends Composer<_$Database, $DataEquipmentTable> {
  $$DataEquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idTeam => $composableBuilder(
      column: $table.idTeam, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get season => $composableBuilder(
      column: $table.season, builder: (column) => ColumnOrderings(column));
}

class $$DataEquipmentTableAnnotationComposer
    extends Composer<_$Database, $DataEquipmentTable> {
  $$DataEquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idTeam =>
      $composableBuilder(column: $table.idTeam, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get season =>
      $composableBuilder(column: $table.season, builder: (column) => column);
}

class $$DataEquipmentTableTableManager extends RootTableManager<
    _$Database,
    $DataEquipmentTable,
    EquipmentsTable,
    $$DataEquipmentTableFilterComposer,
    $$DataEquipmentTableOrderingComposer,
    $$DataEquipmentTableAnnotationComposer,
    $$DataEquipmentTableCreateCompanionBuilder,
    $$DataEquipmentTableUpdateCompanionBuilder,
    (
      EquipmentsTable,
      BaseReferences<_$Database, $DataEquipmentTable, EquipmentsTable>
    ),
    EquipmentsTable,
    PrefetchHooks Function()> {
  $$DataEquipmentTableTableManager(_$Database db, $DataEquipmentTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DataEquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DataEquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DataEquipmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> idTeam = const Value.absent(),
            Value<String> imageUrl = const Value.absent(),
            Value<String> season = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DataEquipmentCompanion(
            id: id,
            idTeam: idTeam,
            imageUrl: imageUrl,
            season: season,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String idTeam,
            required String imageUrl,
            required String season,
            Value<int> rowid = const Value.absent(),
          }) =>
              DataEquipmentCompanion.insert(
            id: id,
            idTeam: idTeam,
            imageUrl: imageUrl,
            season: season,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DataEquipmentTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $DataEquipmentTable,
    EquipmentsTable,
    $$DataEquipmentTableFilterComposer,
    $$DataEquipmentTableOrderingComposer,
    $$DataEquipmentTableAnnotationComposer,
    $$DataEquipmentTableCreateCompanionBuilder,
    $$DataEquipmentTableUpdateCompanionBuilder,
    (
      EquipmentsTable,
      BaseReferences<_$Database, $DataEquipmentTable, EquipmentsTable>
    ),
    EquipmentsTable,
    PrefetchHooks Function()>;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$DataEquipmentTableTableManager get dataEquipment =>
      $$DataEquipmentTableTableManager(_db, _db.dataEquipment);
}
