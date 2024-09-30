import 'dart:async';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/detail/model/player_model.dart';

class DetailController extends BaseController {
  final ApiClient _api;
  
  

  DetailController(this._api)
      {
    
  }

  // Command queries
  late final dummyDetailClubModel =
      CommandQuery.createWithParam<String, ClubModel>(_fetchTeamById);

  late final dummyPlayerCommand =
      CommandQuery.createWithParam<String, List<PlayerModel>>(_fetchPlayers);

  // Private methods to handle API and business logic
  Future<ClubModel> _fetchTeamById(String team) async {
    try {
      final response = await _api.getApiFootballClubById(team);
      if (response != null && response.isNotEmpty) {
        final teamData = response[0]; 
        print("Team name: ${teamData['name']}"); 

        // Assuming you have a method to convert Map to ClubModel
        return ClubModel.fromJson(teamData); // Use your conversion method
      } else {
        throw Exception("No teams found.");
      }
    } catch (e) {
      throw Exception("Error fetching team: $e");
    }
  }

  FutureOr<List<PlayerModel>> _fetchPlayers(String id) async {
    try {
      final response = await _api.getApiPlayer(id);
      return response?.map((e) => PlayerModel.fromJson(e)).toList() ?? [];
    } catch (e) {
      throw Exception('Error fetching players: $e');
    }
  }

  



  
}
