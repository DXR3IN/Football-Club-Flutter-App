import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void backgroundNotificationResponseHandler(
    NotificationResponse notification) async {
  print('Received background notification response: $notification');
}

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
        print('Received local notification: $id, $title, $body, $payload');
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationAndroidSettings,
      iOS: initializationSettingIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          backgroundNotificationResponseHandler,
    );
  }

  Future<void> showLocalNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    print('Showing notification: $id, $title, $body, $payload');
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
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }
}
