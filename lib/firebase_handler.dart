import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/components/notification_service/local_notification_service.dart';
import 'package:premiere_league_v2/components/notification_service/permission.dart';
import 'package:premiere_league_v2/main.dart';

class FirebaseHandler {
  // Initialize the local notification service
  final LocalNotificationService notificationService =
      LocalNotificationService();

  // function for firebase messaging background handler
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    logger.i("Handling a background message: ${message.messageId}");
  }

  // function to initialize firebase
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
    // Listen to Firebase messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        notificationService.showLocalNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: message.notification!.title,
          body: message.notification!.body,
          payload: message.data['teamName'],
        );
      }
    });

    // Handle messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        logger.i("Notification clicked: ${message.notification!.title}");
        firebaseHandler.handleNotificationNavigation(message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // function to handle navigation to notification
  void handleNotificationNavigation(RemoteMessage message) {
    String? route = message.data['teamName'];
    if (route != null) {
      // Check if there are route to detail screen is opened
      if (AppNav.navigator.canPop()) {
        AppNav.navigator
            .popUntil(ModalRoute.withName(AppRoute.teamFcListScreen));
      }

      AppNav.navigator.pushNamed(AppRoute.teamFcDetailScreen, arguments: route);
    } else {
      AppNav.navigator.pushNamed(AppRoute.teamFcListScreen);
    }
  }

  static Future<void> subscribeHandler(String teamName) async {
    logger.i("Subscribed to ${teamName}");
    await FirebaseMessaging.instance.subscribeToTopic(teamName);
  }

  static Future<void> unsubcribeHandler(String teamName) async {
    logger.i("Unsubscribed to ${teamName}");
    await FirebaseMessaging.instance.unsubscribeFromTopic(teamName);
  }
}
