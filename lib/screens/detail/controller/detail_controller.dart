import 'dart:async';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/widget/launch_url.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/detail/model/equipment_model.dart';
import 'package:premiere_league_v2/screens/detail/service/detail_service.dart';

class DetailController extends BaseController {
  DetailController();

  final DetailService _service = DetailService(getIt.get<ApiClient>());

  final teamFc = Observable<ClubModel>(ClubModel());
  final isLoading = Observable<bool>(false);
  final descIsLong = Observable<bool>(true);

  // Command queries
  late final dummyDetailClubModel =
      CommandQuery.createWithParam<String, ClubModel>(_fetchTeamByName);

  late final dummyEquipmentCommand =
      CommandQuery.createWithParam<String, List<EquipmentModel>>(
          _fetchEquipment);

  // This method will be called to fetch equipment after team details are loaded
  Future<void> getTeamAndEquipment(String team) async {
    isLoading.value = true;
    // Start loading for team details
    await dummyDetailClubModel.execute(team);

    // Check if team details were successfully fetched
    if (dummyDetailClubModel.onData != null) {
      final ClubModel teamDetails = dummyDetailClubModel.onData!;
      teamFc.value = teamDetails;

      // Now start loading for equipment
      await dummyEquipmentCommand.execute(teamDetails.idTeam!);
    } else {
      logger.e("Unable to fetch team details.");
    }

    isLoading.value = false;
  }

  // Private methods to handle API and business logic
  Future<ClubModel> _fetchTeamByName(String team) async {
    return await _service.getTeamByName(team);
  }

  FutureOr<List<EquipmentModel>> _fetchEquipment(String id) async {
    return await _service.getEquipment(id);
  }

  Future launchUrl(String url) async {
    try {
      await launchUrlService("https://$url");
    } catch (e) {
      Logger().i("Failed to launch URL: $e");
    }
  }

  void errorBackButton() {
    AppNav.navigator.pop();
  }
}
