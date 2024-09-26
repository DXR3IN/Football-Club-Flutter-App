import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/main.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationAndroidSettings =
        AndroidInitializationSettings('logo');

    final DarwinInitializationSettings initializationSettingIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        logger.i('Received local notification: $id, $title, $body, $payload');
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationAndroidSettings,
      iOS: initializationSettingIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      // Handle foreground notification taps (when the app is running)
      onDidReceiveNotificationResponse: backgroundNotificationResponseHandler,
      onDidReceiveBackgroundNotificationResponse:
          backgroundNotificationResponseHandler,
    );
  }

  // function for local notification
  Future<void> showLocalNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    logger.i('Showing notification: $id, $title, $body, $payload');
    await notificationsPlugin.show(
      id,
      title,
      body,
      await localNotificationDetails(),
      payload: payload,
    );
  }

  Future<NotificationDetails> localNotificationDetails() async {
    return const NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        'push_notification_id',
        'push_notification_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    logger.i("Handling background message: ${message.messageId}");
  }
}

void backgroundNotificationResponseHandler(
    NotificationResponse notification) async {
  logger.i('Received background notification response: $notification');

  if (notification.payload != null) {
    logger.i('Navigating to detail with payload: ${notification.payload}');

    // Remove all previous routes and navigate to the detail screen
    AppNav.navigator.pushNamedAndRemoveUntil(
      AppRoute.teamFcDetailScreen,
      (route) => false,
      arguments: notification.payload,
    );
  }
}
