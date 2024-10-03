import 'dart:async';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/detail/model/equipment_model.dart';

class DetailController extends BaseController {
  final ApiClient _api;

  DetailController(this._api) {}

  // Command queries
  late final dummyDetailClubModel =
      CommandQuery.createWithParam<String, ClubModel>(_fetchTeamById);

  late final dummyEquipmentCommand =
      CommandQuery.createWithParam<String, List<EquipmentModel>>(
          _fetchEquipment);

  // Private methods to handle API and business logic
  Future<ClubModel> _fetchTeamById(String team) async {
    try {
      final response = await _api.getApiFootballClubById(team);
      if (response != null && response.isNotEmpty) {
        final teamData = response[0];
        logger.i("Team name: ${teamData['team']}");

        return ClubModel.fromJson(teamData);
      } else {
        throw Exception("No teams found.");
      }
    } catch (e) {
      throw Exception("Error fetching team: $e");
    }
  }

  FutureOr<List<EquipmentModel>> _fetchEquipment(String id) async {
    return await _api.getFcEquipment(id).then((value) {
      logger.i("equipment $value");
      return value?.map((e) => EquipmentModel.fromJson(e)).toList() ?? [];
    });
  }
}
