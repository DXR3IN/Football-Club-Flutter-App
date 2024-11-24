import 'dart:async';
import 'package:premiere_league_v2/screens/home/model/home_club_model.dart';
import '../../../components/api_services/api_client.dart';

class HomeService {
  final ApiClient _apiClient;

  HomeService(this._apiClient);

  // Fetch Football Clubs from API
  Future<List<HomeClubModel>> getFootballClubs() async {
    final List<HomeClubModel> teamList =
        await _apiClient.getApiFootballClubs().then((value) {
      return value?.map((e) => HomeClubModel.fromJson(e)).toList() ?? [];
    });
    return teamList;
  }
}
