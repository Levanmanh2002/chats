// import 'dart:async';
// import 'dart:developer';
// import 'dart:js' as js;

// import 'package:chats/pages/profile/profile_controller.dart';
// import 'package:chats/utils/app_constants.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

// class PusherService {
//   static final PusherService _instance = PusherService._();

//   factory PusherService() => _instance;

//   PusherService._();

//   static final _pusher = PusherChannelsFlutter.getInstance();

//   static StreamController streamController = StreamController.broadcast();
//   Stream get stream => streamController.stream;

//   static Future<void> initPusher() async {
//     try {
//       if (kIsWeb) {
//         initPusherWeb();
//       }
//       await _pusher.init(
//         apiKey: AppConstants.pusherApiKey,
//         cluster: AppConstants.pusherApiCluster,
//         onConnectionStateChange: onConnectionStateChange,
//         onError: onError,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onEvent: onEvent,
//         onSubscriptionError: onSubscriptionError,
//         onDecryptionFailure: onDecryptionFailure,
//         onMemberAdded: onMemberAdded,
//         onMemberRemoved: onMemberRemoved,
//         // logToConsole: true,
//       );
//     } catch (e) {
//       log("error in initialization: $e");
//     }
//   }

//   static void initPusherWeb() {
//     js.context.callMethod('eval', [
//       """
//       try {
//         if (!window.pusher) {
//           window.pusher = new Pusher('${AppConstants.pusherApiKey}', {
//             cluster: '${AppConstants.pusherApiCluster}',
//             forceTLS: true
//           });
//           console.log("✅ Pusher Web initialized!");
//         } else {
//           console.log("ℹ️ Pusher Web already initialized.");
//         }
//       } catch (error) {
//         console.error("❌ Pusher initialization failed:", error);
//       }
//       """
//     ]);
//   }

//   static void subscribeToChannel(String channelName, String eventName) async {
//     int? userId;

//     if (Get.isRegistered<ProfileController>()) {
//       userId = Get.find<ProfileController>().user.value?.id;
//       await initPusher();
//     }
//     if (userId == null || userId == 0) return;

//     js.context.callMethod('eval', [
//       """
//       try {
//         if (window.pusher) {
//           var channel = window.pusher.subscribe('${AppConstants.pusherChannel}-$userId');
//           console.log("📡 Subscribing to channel: '${AppConstants.pusherChannel}-$userId');

//           channel.bind('$eventName', function(data) {
//             console.log("📩 Received event '$eventName':", data);
//             window.flutter_inbox.receiveMessage(data);
//           });

//           console.log("✅ Successfully subscribed to '$channelName' and listening for '$eventName'");

//         } else {
//           console.error("❌ Pusher is not initialized yet!");
//         }
//       } catch (error) {
//         console.error("❌ Failed to subscribe:", error);
//       }
//       """
//     ]);
//   }

//   Future<void> connect() async {
//     try {
//       int? userId;

//       if (Get.isRegistered<ProfileController>()) {
//         userId = Get.find<ProfileController>().user.value?.id;
//         await initPusher();
//       }
//       if (userId == null || userId == 0) return;

//       if (kIsWeb) {
//         PusherService.subscribeToChannel('${AppConstants.pusherChannel}-$userId', AppConstants.pusherChannel);
//       }
//       await _pusher.subscribe(
//         channelName: '${AppConstants.pusherChannel}-$userId',
//         onEvent: (event) {
//           log(event.toString(), name: 'Pusher Event');
//           streamController.add(event);
//         },
//       );
//       await _pusher.connect();

//       log("trying to subscribe to :  ${'${AppConstants.pusherChannel}-$userId'}");
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   static void disconnect() async {
//     await _pusher.unsubscribe(
//       channelName: '${AppConstants.pusherChannel}-${Get.find<ProfileController>().user.value?.id}',
//     );

//     _pusher.disconnect();
//   }

//   static void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     log("Connection: $currentState");
//   }

//   static void onError(String message, int? code, dynamic e) {
//     log("onError: $message code: $code exception: $e");
//   }

//   static void onEvent(PusherEvent event) {
//     log("onEvent: $event");
//     // handleIncomingCall(event.data);
//     if (event.data != null) {
//       streamController.add(event);
//     } else {
//       log("No data in event.");
//     }
//   }

//   static void onSubscriptionSucceeded(String channelName, dynamic data) {
//     log("onSubscriptionSucceeded: $channelName data: $data");
//     final me = _pusher.getChannel(channelName)?.me;
//     log("Me: $me");
//   }

//   static void onSubscriptionError(String message, dynamic e) {
//     log("onSubscriptionError: $message Exception: $e");
//   }

//   static void onDecryptionFailure(String event, String reason) {
//     log("onDecryptionFailure: $event reason: $reason");
//   }

//   static void onMemberAdded(String channelName, PusherMember member) {
//     log("onMemberAdded: $channelName user: $member");
//   }

//   static void onMemberRemoved(String channelName, PusherMember member) {
//     log("onMemberRemoved: $channelName user: $member");
//   }

//   static void onSubscriptionCount(String channelName, int subscriptionCount) {
//     log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
//   }
// }
