import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';

class SplashController extends GetxController {
  final _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _delayNavigation();
  }

  void _delayNavigation() {
    _logger.i("SPLASH");
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoute.teamFcListScreen);
    });
  }
}
