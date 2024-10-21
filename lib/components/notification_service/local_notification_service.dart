import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:premiere_league_v2/components/config/app_const.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/components/notification_service/model/notification_model.dart';
import 'package:premiere_league_v2/main.dart';

// top level for checking
void notificationRedirectHandler(
    NotificationResponse notificationResponse) async {
  try {
    // Convert payload to valid JSON format
    String payloadString = notificationResponse.payload.toString();

    // Attempt to parse the payload
    NotificationModel notificationPayload =
        NotificationModel.fromJson(jsonDecode(payloadString));

    logger.i("Successfully handled redirect: $notificationPayload");

    // Perform the notification action
    LocalNotificationService().actionForNotification(notificationPayload);
  } catch (e) {
    // Log the error for debugging
    logger.e("Failed to handle notification redirect: $e");
  }
}

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationAndroidSettings =
        AndroidInitializationSettings('@drawable/logo');

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
      onDidReceiveNotificationResponse: notificationRedirectHandler,
      onDidReceiveBackgroundNotificationResponse: notificationRedirectHandler,
    );
  }

  void actionForNotification(NotificationModel notificationModel) {
    switch (notificationModel.redirectTo) {
      case AppConst.toDetail:
        toDetailScreen(notificationModel.title!);
      case AppConst.toFavorite:
        toFavoriteScreen();
    }
  }

  void toDetailScreen(String title) async {
    logger.i('Going into detail screen with id: $title');

    AppNav.navigator.pushNamed(
      AppRoute.teamFcDetailScreen,
      arguments: title,
    );
  }

  void toFavoriteScreen() {
    logger.i('Going into Favorite Screen');

    AppNav.navigator.pushNamed(AppRoute.favTeamFcScreen);
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
}
