import 'dart:async';

import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/model/history_model.dart';
import 'package:premiere_league_v2/screens/detail/service/detail_service.dart';

class HistoryController extends BaseController {
  late final String idTeam;

  HistoryController(this.idTeam) {
    getLastEventByIdCommand.execute();
  }

  final DetailService _service = DetailService(getIt.get<ApiClient>());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }

  late final getLastEventByIdCommand =
      CommandQuery.create(_getLastEventByIdTeam);

  FutureOr<List<HistoryModel>?> _getLastEventByIdTeam() async {
    return await _service.getLastEventByIdTeam(idTeam);
  }
}
