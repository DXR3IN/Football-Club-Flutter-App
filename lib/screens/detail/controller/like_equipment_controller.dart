import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/components/util/local_database/data_equipment.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/model/equipment_model.dart';

class LikeEquipmentController {
  final Database _database = GetIt.instance<Database>();

  late final EquipmentModel equipment;

  LikeEquipmentController({required this.equipment}) {
    _checkIfLiked();
  }

  late final toggleEquipmentCommand = CommandQuery.create(_toggleLikeStatus);

  final isLiked = Observable<bool>(true);

  @action
  Future<void> _checkIfLiked() async {
    // Check if the equipment with this ID already exists in the database
    final query = await _database.select(_database.dataEquipment)
      ..where((tbl) => tbl.id.equals(equipment.idEquipment!));
    final result = await query.get();
    runInAction(() {
      isLiked.value = result.isNotEmpty;
    });
  }

  Future<void> _insertEqToDB() async {
    try {
      // Extract parameters from the map
      final String id = equipment.idEquipment!;
      final String idTeam = equipment.idTeam!;
      final String imageUrl = equipment.strEquipment!;
      final String season = equipment.strSeason!;
      logger.i("Database is adding");
      await _database.into(_database.dataEquipment).insert(
          DataEquipmentCompanion.insert(
              id: id, idTeam: idTeam, imageUrl: imageUrl, season: season));
      logger.i("success");
      logger.i(_database.select(_database.dataEquipment).get());
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _deleteEqFromDB() async {
    try {
      logger.i("deleting start");
      await (_database.delete(_database.dataEquipment)
            ..where((tbl) => tbl.id.equals(equipment.idEquipment!)))
          .go();
      logger.i(_database.select(_database.dataEquipment).get());
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _toggleLikeStatus() async {
    final currentStatus = isLiked.value;
    if (isLiked.value) {
      _deleteEqFromDB();
    } else {
      _insertEqToDB();
    }
    runInAction(() {
      isLiked.value = !currentStatus;
    });
  }
}
