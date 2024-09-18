import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:premiere_league_v2/components/api_services/favorite_helper.dart';
import 'package:premiere_league_v2/components/model/club_model.dart';
import 'package:premiere_league_v2/components/util/command_query.dart'; // For ChangeNotifier

class FavoriteController extends ChangeNotifier {
  final FavoriteHelper _favoriteService = FavoriteHelper();

  List<ClubModel> _favoriteTeams = [];
  List<ClubModel> get favoriteTeams => _favoriteTeams;

  late final favoriteCommand =
      CommandQuery.create<Null, List<ClubModel>>(loadFavorites);

  Future<List<ClubModel>> loadFavorites() async {
    _favoriteTeams = await _favoriteService.getFavoriteTeams();
    return _favoriteTeams;
  }

  Future<void> removeFromFavorites(ClubModel team) async {
    await _favoriteService.removeFavorite(team.idTeam!);
    await favoriteCommand.execute(); // Reload favorites after removal
  }
}
