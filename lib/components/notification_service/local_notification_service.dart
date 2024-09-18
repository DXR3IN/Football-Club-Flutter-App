import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

    // Listen for foreground messages from Firebase
    FirebaseMessaging.onMessage.listen(_handleFirebaseMessage);
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
        'push_notification_id',
        'push_notification_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  void _handleFirebaseMessage(RemoteMessage message) {
    String? title = message.notification?.title;
    String? body = message.notification?.body;
    String? payload = message.data['route']; 

    showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, 
      title: title,
      body: body,
      payload: payload,
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
  }
}
