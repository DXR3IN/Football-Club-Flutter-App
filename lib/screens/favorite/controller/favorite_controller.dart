import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/favorite_helper.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart'; // For ChangeNotifier

class FavoriteController extends ChangeNotifier {
  final ApiClient _api;
  final FavoriteHelper _favoriteService = FavoriteHelper();

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
    _favoriteTeams = await _favoriteService.getFavoriteTeams(_allTeams);
    // logger.i("the first favorite team : ${_favoriteTeams[0]}");
    return _favoriteTeams;
  }

  Future<void> removeFromFavorites(FavClubModel team) async {
    await _favoriteService.removeFavoriteTeam(team.idTeam!);
    await favoriteCommand.execute();
  }
}
