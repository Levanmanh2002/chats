import 'dart:convert';
import 'dart:developer';

import 'package:chats/main.dart';
import 'package:chats/pages/call/call_parameter.dart';
import 'package:chats/pages/group_message/group_message_parameter.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
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
      if (message.data['type'] == 'incoming_call') {
        _handleIncomingCall(message);
      } else {
        showLocalNotification(message);
      }

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

// Event.actionCallIncoming	Nhận một cuộc gọi đến.
// Event.actionCallStart	Bắt đầu một cuộc gọi đi.
// Event.actionCallAccept	Người dùng chấp nhận cuộc gọi đến.
// Event.actionCallDecline	Người dùng từ chối cuộc gọi đến.
// Event.actionCallEnded	Cuộc gọi kết thúc (dù là cuộc gọi đến hay cuộc gọi đi).
// Event.actionCallTimeout	Cuộc gọi bị nhỡ (không ai bắt máy).
// Event.actionCallCallback	Chỉ trên Android - Nhấn vào "Gọi lại" trong thông báo cuộc gọi nhỡ.
// Event.actionCallToggleHold	Chỉ trên iOS - Đưa cuộc gọi vào chế độ giữ máy (hold).
// Event.actionCallToggleMute	Chỉ trên iOS - Bật/tắt chế độ tắt tiếng (mute).
// Event.actionCallToggleDmtf	Chỉ trên iOS - Gửi tín hiệu DTMF (phím bấm trên điện thoại).
// Event.actionCallToggleGroup	Chỉ trên iOS - Thêm cuộc gọi vào nhóm.
// Event.actionCallToggleAudioSession	Chỉ trên iOS - Thay đổi thiết lập âm thanh trong cuộc gọi.
// Event.actionDidUpdateDevicePushTokenVoip	Chỉ trên iOS - Cập nhật token VoIP cho thông báo đẩy.
// Event.actionCallCustom	Tuỳ chỉnh sự kiện cuộc gọi (dùng cho custom actions).

    FlutterCallkitIncoming.onEvent.listen((event) {
      switch (event?.event) {
        case Event.actionCallAccept:
          Get.toNamed(
            Routes.CALL,
            arguments: CallCallParameter(
              id: 0,
              name: 'firebase name',
              avatar: '',
              channel: 'channel',
            ),
          );
          break;
        case Event.actionCallDecline:
          log("Người dùng đã từ chối cuộc gọi");
          break;
        case Event.actionCallEnded:
          log("Cuộc gọi đã kết thúc");
          break;
        case Event.actionCallIncoming:
          log("Cuộc gọi đến");
          break;
        case Event.actionCallTimeout:
          log("Cuộc gọi đã hết hạn");
          break;
        case Event.actionCallCallback:
          log("Bắt đầu cuộc gọi");
          break;
        default:
          log("Sự kiện không xác định: ${event?.event}");
          break;
      }
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

      final relatedId = int.tryParse(message.data['id'] ?? '');

      if (message.data['type'] == 'chat' && (message.data['is_group'] == 0 || message.data['is_group'] == "0")) {
        if (relatedId != null) {
          Get.toNamed(
            Routes.MESSAGE,
            arguments: MessageParameter(chatId: relatedId),
          );
        }
      } else if (message.data['type'] == 'chat' && (message.data['is_group'] == 1 || message.data['is_group'] == "1")) {
        if (relatedId != null) {
          Get.toNamed(
            Routes.GROUP_MESSAGE,
            arguments: GroupMessageParameter(chatId: relatedId),
          );
        }
      } else if (message.data['type'] == 'friend_request') {
        if (relatedId != null) {
          Get.toNamed(Routes.SENT_REQUEST_CONTACT);
        }
      }

      /// xử lý khi ấn cuộc gọi đến
    } catch (e) {
      log(e.toString());
    }
  }
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print("🔔 Nhận thông báo nền: ${message.notification?.title}");

  _handleIncomingCall(message);

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

void _handleIncomingCall(RemoteMessage message) {
  if (message.data['type'] == 'incoming_call') {
    // String callerName = message.data['caller_name'] ?? 'Người gọi';
    // String channel = message.data['channel'] ?? '';

    // Nếu app đang mở, hiển thị màn hình nhận cuộc gọi
    // if (Get.context != null) {
    _showCallKitIncomingCall(
      channel: 'channel',
      callerName: 'callerName',
      avatar: 'https://i.pravatar.cc/100',
    );
    // } else {
    //   // Nếu app bị tắt, hiển thị thông báo đẩy
    //   _showIncomingCallNotification('callerName', 'channel');
    // }
  }
}

void _showCallKitIncomingCall({required String channel, required String callerName, required String avatar}) async {
  CallKitParams callKitParams = CallKitParams(
    id: channel,
    nameCaller: callerName,
    appName: 'Chat - Nhà Táo',
    avatar: avatar,
    // handle: '0123456789',
    type: 0, // 0: Audio Call, 1: Video Call
    textAccept: 'Chấp nhận',
    textDecline: 'Từ chối',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Cuộc gọi nhỡ',
      callbackText: 'Gọi lại',
    ),
    duration: 30000,
    android: AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: avatar,
      actionColor: '#4CAF50',
      textColor: '#ffffff',
      incomingCallNotificationChannelName: "Cuộc gọi đến",
      missedCallNotificationChannelName: "Cuộc gọi nhỡ",
      isShowCallID: false,
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: 'generic',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );

  await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  Future.delayed(const Duration(seconds: 60), () async {
    await FlutterCallkitIncoming.endAllCalls();
  });
}
