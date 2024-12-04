import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:mobx/mobx.dart';

class NavigationController extends BaseController {
  Observable<int> currentIndex = Observable<int>(0);

  @action
  void setIndex(int index) {
    currentIndex.value = index;
  }

  @action
  void onTapFavScreen() {
    AppNav.navigator.pushNamed(AppRoute.favTeamFcScreen);
  }
}
