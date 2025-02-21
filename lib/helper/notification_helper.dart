import 'dart:convert';
import 'dart:developer';

import 'package:chats/main.dart';
import 'package:chats/pages/group_message/group_message_parameter.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationHelper {
  static Future<void> initialize() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/notification_icon');

    AndroidFlutterLocalNotificationsPlugin? androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?..requestNotificationsPermission();

    androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(AppConstants.notificationChannelId, 'Normal CHATS channel'),
    );

    DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) async {
        try {
          final message = RemoteMessage.fromMap(jsonDecode(payload.payload ?? '{}'));
          if (message.data.isEmpty) return;
          _handleDirectMessage(message);
        } catch (e) {
          log(e.toString());
        }
      },
    );

    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      _handleDirectMessage(remoteMessage);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message);

      if (kDebugMode) {
        print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}",
        );
        print("onMessage type: ${message.data['type']}/${message.data}");
      }

      if (message.notification != null) {
        // IsolateNameServer.lookupPortByName(AppConstants.notificationUnreadReceivePort)?.send(message.toMap());
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleDirectMessage(message);
    });
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      '',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iOSNotificationDetails = DarwinNotificationDetails(
      presentBadge: true,
      presentAlert: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );
    int notificationId = DateTime.now().microsecond;
    return flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: jsonEncode(message.toMap()),
    );
  }

  static Future<void> _handleDirectMessage(RemoteMessage message) async {
    try {
      log(message.data.toString());

      final chatId = int.tryParse(message.data['id'] ?? '');

      if (message.data['type'] == 'chat' && (message.data['is_group'] == 0 || message.data['is_group'] == "0")) {
        if (chatId != null) {
          Get.toNamed(
            Routes.MESSAGE,
            arguments: MessageParameter(chatId: chatId),
          );
        }
      } else if (message.data['type'] == 'chat' && (message.data['is_group'] == 1 || message.data['is_group'] == "1")) {
        if (chatId != null) {
          Get.toNamed(
            Routes.GROUP_MESSAGE,
            arguments: GroupMessageParameter(chatId: chatId),
          );
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(
      "onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}",
    );
    print("onMessage type: ${message.data['type']}/${message.data}");
  }

  if (message.notification != null) {
    // IsolateNameServer.lookupPortByName(AppConstants.notificationUnreadReceivePort)?.send(message.toMap());

    // if (message.data['type'] == 'order_status') {
    //   IsolateNameServer.lookupPortByName(AppConstants.orderDetailsReceivePort)?.send(message.toMap());
    // }
  }
}
