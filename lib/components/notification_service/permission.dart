import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:premiere_league_v2/main.dart';

class Permission {
  // function for requesting a permission to device
  static Future<void> requestPermision() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      logger.i('User granted provisional permission');
    } else {
      logger.i('User declined or has not accepted permission');
    }
  }
}
