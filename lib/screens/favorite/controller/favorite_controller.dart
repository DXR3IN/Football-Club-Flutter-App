import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/favorite_handler.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';

class FavoriteController extends ChangeNotifier {
  final ApiClient _api;
  final FavoriteHandler _favoriteHandler = FavoriteHandler();

  FavoriteController(this._api);

  FutureOr<List<FavClubModel>> _getAllTeamsForFiltering() async {
    return _api.getApiFootballClubs().then((value) {
      return value?.map((e) => FavClubModel.fromJson(e)).toList() ?? [];
    });
  }

  List<FavClubModel> _allTeams = [];
  List<FavClubModel> _favoriteTeams = [];
  List<FavClubModel> get favoriteTeams => _favoriteTeams;

  late final favoriteCommand =
      CommandQuery.create<Null, List<FavClubModel>>(loadFavorites);

  Future<List<FavClubModel>> loadFavorites() async {
    _allTeams = await _getAllTeamsForFiltering();
    _favoriteTeams = await _favoriteHandler.getFavoriteTeams(_allTeams);
    // logger.i("the first favorite team : ${_favoriteTeams[0]}");
    return _favoriteTeams;
  }

  Future<void> removeFromFavorites(FavClubModel team) async {
    await _favoriteHandler.removeFavoriteTeam(team.team!);
    await favoriteCommand.execute();
  }
}
