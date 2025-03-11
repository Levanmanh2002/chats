import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:chats/main.dart';
import 'package:chats/pages/call/call_controller.dart';
import 'package:chats/pages/call/call_parameter.dart';
import 'package:chats/pages/group_message/group_message_parameter.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/resourese/messages/messages_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:uuid/uuid.dart';

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
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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
      if (message.data['type'] == 'chat' && message.data['call_token'] != null) {
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
        if (message.data['type'] == 'chat' && message.data['call_action'] == 'reject_call') {
          IsolateNameServer.lookupPortByName(AppConstants.rejectCallChannelId)?.send(message.toMap());
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleDirectMessage(message);

      RemoteNotification? map = message.notification;

      if (kDebugMode) {
        print(
          "onMessageOpenedApp: ${map?.title}/${map?.body}/${map?.titleLocKey}",
        );
        print("onMessageOpenedApp type: ${message.data['type']}/${message.data}");
      }
    });

    FlutterCallkitIncoming.onEvent.listen((event) {
      log((event?.body ?? {}).toString(), name: 'CallKitEvent');
      switch (event?.event) {
        case Event.actionCallAccept:
          if (!Get.isRegistered<CallController>()) {
            final extraData = event?.body?['extra'];

            if (extraData != null) {
              Get.toNamed(
                Routes.CALL,
                arguments: CallCallParameter(
                  id: int.tryParse(extraData['user_id'] ?? '') ?? 0,
                  messageId: int.tryParse(extraData['id'] ?? '') ?? 0,
                  callId: int.tryParse(extraData['call_id'] ?? '') ?? 0,
                  name: extraData['user_name'] ?? '',
                  avatar: extraData['user_avatar'] ?? '',
                  channel: extraData['channel_name'] ?? '',
                  token: extraData['call_token'] ?? '',
                  type: CallType.incomingCall,
                ),
              );
            }
          }
          break;
        case Event.actionCallDecline:
          final extraData = event?.body?['extra'];
          sendCallDeclinedToServer(messageId: extraData['call_id']);

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
    } catch (e) {
      log(e.toString());
    }
  }
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('xu ly tin nhan trong background');
  _handleIncomingCall(message);

  FlutterCallkitIncoming.onEvent.listen((event) {
    log((event?.body ?? {}).toString(), name: 'CallKitEvent');
    switch (event?.event) {
      case Event.actionCallAccept:
        if (!Get.isRegistered<CallController>()) {
          final extraData = event?.body?['extra'];

          if (extraData != null) {
            Get.toNamed(
              Routes.CALL,
              arguments: CallCallParameter(
                id: int.tryParse(extraData['user_id'] ?? '') ?? 0,
                messageId: int.tryParse(extraData['id'] ?? '') ?? 0,
                callId: int.tryParse(extraData['call_id'] ?? '') ?? 0,
                name: extraData['user_name'] ?? '',
                avatar: extraData['user_avatar'] ?? '',
                channel: extraData['channel_name'] ?? '',
                token: extraData['call_token'] ?? '',
                type: CallType.incomingCall,
              ),
            );
          }
        }
        break;
      case Event.actionCallDecline:
        final extraData = event?.body?['extra'];
        sendCallDeclinedToServer(messageId: extraData['call_id']);

        break;
      case Event.actionCallEnded:
        sendCallDeclinedToServer(messageId: event?.body?['id']);
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

  if (message.data['type'] == 'chat' && message.data['call_token'] != null) {
    await LocalStorage.init();
    LocalStorage.setJSON(
      SharedKey.CALL_CHAT_EVENT,
      {
        "id": message.data['id'] ?? '',
        "user_id": message.data['user_id'] ?? '',
        "call_id": message.data['call_id'] ?? '',
        "call_token": message.data['call_token'] ?? '',
        "channel_name": message.data['channel_name'] ?? '',
        "user_name": message.data['user_name'] ?? '',
        "user_avatar": message.data['user_avatar'] ?? '',
      },
    );
  }

  if (kDebugMode) {
    print(
      "onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}",
    );
    print("onMessage type: ${message.data['type']}/${message.data}");
  }

  if (message.notification != null) {
    if (message.data['type'] == 'chat' && message.data['call_action'] == 'reject_call') {
      IsolateNameServer.lookupPortByName(AppConstants.rejectCallChannelId)?.send(message.toMap());
    }
  }
}

void _handleIncomingCall(RemoteMessage message) {
  log('Xử lý cuộc gọi đến');
  print('Xử lý cuộc gọi đến');
  if (message.data['type'] == 'chat' &&
      message.data['call_token'] != null &&
      message.data['call_action'] == 'init_call') {
    _showCallKitIncomingCall(
      id: message.data['user_id'] ?? '',
      token: message.data['call_token'] ?? '',
      channel: message.data['channel_name'] ?? '',
      callerName: message.data['user_name'] ?? '',
      avatar: message.data['user_avatar'] ?? '',
      message: message,
    );
  }
}

void _showCallKitIncomingCall({
  required String id,
  required String token,
  required String channel,
  required String callerName,
  required String avatar,
  required RemoteMessage message,
}) async {
  String uuidV4 = const Uuid().v4();

  CallKitParams callKitParams = CallKitParams(
    id: uuidV4,
    nameCaller: callerName,
    appName: 'Chat - Nhà Táo',
    avatar: avatar,
    handle: token,
    type: 0, // 0: Audio Call, 1: Video Call
    textAccept: 'Chấp nhận',
    textDecline: 'Từ chối',
    extra: message.data,
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: false,
      subtitle: 'Cuộc gọi nhỡ',
      callbackText: 'Gọi lại',
    ),
    duration: 20000,
    android: AndroidParams(
      isCustomNotification: true,
      isShowLogo: true,
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
      // iconName: 'CallKitLogo',
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
}

Future<void> sendCallDeclinedToServer({required String messageId}) async {
  try {
    final MessagesRepository messagesRepository = Get.put(MessagesRepository());

    Map<String, String> params = {
      "message_id": messageId.toString(),
    };

    final response = await messagesRepository.rejectCall(params);
    log("Gửi từ chối cuộc gọi thành công: $response");
  } catch (e) {
    log("Lỗi khi gửi từ chối cuộc gọi: $e");
  }
}
