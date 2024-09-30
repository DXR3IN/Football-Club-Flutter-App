import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteHelper {
  static const String favoritesKey = "favorite_teams";

  Future<void> saveFavoriteTeam(String idTeam) async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> favoriteTeams =
        prefs.getStringList(favoritesKey)?.toSet() ?? {};
    favoriteTeams.add(idTeam);
    logger.i("one of the favoriteTeams : ${favoriteTeams}");
    await prefs.setStringList(favoritesKey, favoriteTeams.toList());
  }

  Future<void> removeFavoriteTeam(String idTeam) async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> favoriteTeams =
        prefs.getStringList(favoritesKey)?.toSet() ?? {};
    favoriteTeams.remove(idTeam);
    await prefs.setStringList(favoritesKey, favoriteTeams.toList());
  }

  Future<List<FavClubModel>> getFavoriteTeams(
      List<FavClubModel> allTeams) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(favoritesKey) ?? [];
    return allTeams
        .where((team) => favoriteTeams.contains(team.idTeam))
        .toList();
  }

  Future<bool> isFavorite(String? idTeam) async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> favoriteTeams =
        prefs.getStringList(favoritesKey)?.toSet() ?? {};
    return favoriteTeams.contains(idTeam);
  }
}
