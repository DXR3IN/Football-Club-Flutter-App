import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:premiere_league_v2/components/util/local_database/data_equipment.dart';
import 'package:premiere_league_v2/favorite_handler.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';
import 'package:premiere_league_v2/screens/favorite/model/liked_equipment_model.dart';

class FavoriteController extends ChangeNotifier {

  FavoriteController();

  final Database _database = GetIt.instance<Database>();
  final FavoriteHandler _favoriteHandler = FavoriteHandler();

  List<FavClubModel> _favoriteTeams = [];
  List<FavClubModel> get favoriteTeams => _favoriteTeams;

  late final favoriteClubCommand =
      CommandQuery.create<Null, List<FavClubModel>>(loadFavorites);
  late final likedEquipmentCommand =
      CommandQuery.create(_getLikedEquipmentFromDB);

  Future<List<FavClubModel>> loadFavorites() async {
    _favoriteTeams = await _favoriteHandler.getFavoriteTeams();
    notifyListeners();
    return _favoriteTeams;
  }

  Future<void> removeFromFavorites(FavClubModel footbalTeam) async {
    await _favoriteHandler.removeFavoriteTeam(footbalTeam);
    await favoriteClubCommand.execute();
  }

  Future<List<LikedEquipmentModel>> _getLikedEquipmentFromDB() async {
    final result = await _database.select(_database.dataEquipment).get();
    final data = result.map((equipment) {
      return LikedEquipmentModel.fromJson({
        'idEquipment': equipment.id,
        'idTeam': equipment.idTeam,
        'strEquipment': equipment.imageUrl,
        'strSeason': equipment.season,
      });
    }).toList();
    logger.i("Data length: ${data.length}");
    return data;
  }
}
