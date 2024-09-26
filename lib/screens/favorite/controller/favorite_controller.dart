import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:premiere_league_v2/screens/favorite/controller/favorite_helper.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart'; // For ChangeNotifier

class FavoriteController extends ChangeNotifier {
  final FavoriteHelper _favoriteService = FavoriteHelper();

  List<FavClubModel> _favoriteTeams = [];
  List<FavClubModel> get favoriteTeams => _favoriteTeams;

  late final favoriteCommand =
      CommandQuery.create<Null, List<FavClubModel>>(loadFavorites);

  Future<List<FavClubModel>> loadFavorites() async {
    _favoriteTeams = await _favoriteService.getFavoriteTeams();
    return _favoriteTeams;
  }

  Future<void> removeFromFavorites(FavClubModel team) async {
    await _favoriteService.removeFavorite(team.idTeam!);
    await favoriteCommand.execute(); 
  }
}
