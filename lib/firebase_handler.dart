import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:premiere_league_v2/components/notification_service/local_notification_service.dart';
import 'package:premiere_league_v2/components/notification_service/model/notification_model.dart';
import 'package:premiere_league_v2/components/notification_service/permission.dart';
import 'package:premiere_league_v2/main.dart';

class FirebaseHandler {
  // Initialize the local notification service
  final LocalNotificationService notificationService =
      LocalNotificationService();

  // function for firebase messaging background handler
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    logger.i(
        "Handling a background message: ${message.notification!.title} && ${message.data['id']}");
  }

  // function to initialize firebase and all another function to help it
  Future initializeFirebase() async {
    await notificationService.initNotification();
    // Initialize Firebase
    await Firebase.initializeApp();

    await Permission.requestPermision();
  }

  // function to initializw notification
  Future<void> initializeNotifications() async {
    await notificationService.initNotification();
    FirebaseMessaging.instance.getToken().then((String? token) {
      logger.i("Firebase Messaging Token: $token");
    });
  }

  // function to initialize firebase listener
  void firebaseListener() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen to Firebase messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        notificationService.showLocalNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: message.notification!.title,
          body: message.notification!.body,
          payload: message.data.toString(),
        );
      }
    });

    // Handle messages when the app is opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        logger.i("Notification clicked: ${message.notification!.title}");
        NotificationModel notificationResponse =
            NotificationModel.fromJson(jsonDecode(message.data.toString()));
        notificationService.actionForNotification(notificationResponse);
      }
    });
  }

  static Future<void> subscribeHandler(String teamName) async {
    logger.i("Subscribed to $teamName");
    await FirebaseMessaging.instance.subscribeToTopic(teamName);
  }

  static Future<void> unsubscribeHandler(String teamName) async {
    logger.i("Unsubscribed to $teamName");
    await FirebaseMessaging.instance.unsubscribeFromTopic(teamName);
  }
}
