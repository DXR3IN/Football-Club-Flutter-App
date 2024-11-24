import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/screens/detail/model/equipment_model.dart';
import 'package:premiere_league_v2/screens/detail/model/history_model.dart';

class DetailService {
  final ApiClient _api;

  DetailService(this._api);

  Future<ClubModel> getTeamByName(String idTeam) async {
    try {
      final response = await _api.getApiFootballClubById(idTeam);
      if (response != null && response.isNotEmpty) {
        final teamData = response[0];

        return ClubModel.fromJson(teamData);
      } else {
        throw Exception("No teams found.");
      }
    } catch (e) {
      throw Exception("Error fetching team: $e");
    }
  }

  Future<List<EquipmentModel>> getEquipment(String idTeam) async {
    return await _api.getFcEquipment(idTeam).then((value) {
      return value?.map((e) => EquipmentModel.fromJson(e)).toList() ?? [];
    });
  }

  Future<List<HistoryModel>?> getLastEventByIdTeam(String idTeam) async {
    return await _api.getLastEventHomeByIdTeam(idTeam).then(
      (value) {
        return value
                ?.map(
                  (e) => HistoryModel.fromJson(e),
                )
                .toList() ??
            [];
      },
    );
  }
}