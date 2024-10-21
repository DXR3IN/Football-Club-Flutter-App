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

  // Function to initialize Firebase and necessary permissions
  Future<void> initializeFirebase() async {
    
    await notificationService.initNotification();

    // Initialize Firebase
    await Firebase.initializeApp();

    // Request notification permissions
    await Permission.requestPermision();
  }

  // Function to initialize notifications
  Future<void> initializeNotifications() async {
    await notificationService.initNotification();

    // Get the Firebase Messaging token
    FirebaseMessaging.instance.getToken().then((String? token) {
      if (token != null) {
        logger.i("Firebase Messaging Token: $token");
      } else {
        logger.w("Firebase Messaging Token is null");
      }
    }).catchError((error) {
      logger.e("Error getting Firebase Messaging token: $error");
    });
  }

  // Function to initialize Firebase message listeners
  Future<void> firebaseListener() async {
    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        notificationService.showLocalNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: notification.title ?? 'No Title',
          body: notification.body ?? 'No Body',
          payload: message.data.toString(),
        );
      }
    });

    // Handle messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        logger.i("Notification clicked: ${notification.title}");

        // Deserialize the data
        try {
          NotificationModel notificationResponse =
              NotificationModel.fromJson(jsonDecode(message.data.toString()));
          notificationService.actionForNotification(notificationResponse);
        } catch (e) {
          logger.e("Error parsing notification data: $e");
        }
      }
    });
  }

  // Subscribe to a topic for team notifications
  static Future<void> subscribeHandler(String teamName) async {
    try {
      logger.i("Subscribed to $teamName");
      await FirebaseMessaging.instance.subscribeToTopic(teamName);
    } catch (e) {
      logger.e("Error subscribing to $teamName: $e");
    }
  }

  // Unsubscribe from a topic for team notifications
  static Future<void> unsubscribeHandler(String teamName) async {
    try {
      logger.i("Unsubscribed from $teamName");
      await FirebaseMessaging.instance.unsubscribeFromTopic(teamName);
    } catch (e) {
      logger.e("Error unsubscribing from $teamName: $e");
    }
  }
}
