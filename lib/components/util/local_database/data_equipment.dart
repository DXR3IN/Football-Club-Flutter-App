import 'package:drift/drift.dart';

part 'data_equipment.g.dart';

@DataClassName('EquipmentsTable')
class DataEquipment extends Table {
  TextColumn get id => text()();
  TextColumn get idTeam => text()();
  TextColumn get imageUrl => text()();
  TextColumn get season => text()();
}

abstract class DataEquipmentView extends View {
  DataEquipment get equipments;

  // Expression<int> get equipmentCount => equipments.id.count();

  @override
  Query as() => select([
        equipments.id,
        equipments.idTeam,
        equipments.imageUrl,
        equipments.season
      ]).from(equipments);
}

@DriftDatabase(tables: [DataEquipment], views: [DataEquipmentView])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 2;
}
