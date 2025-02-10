// import 'dart:async';
// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

// class PusherService {
//   static final PusherService _instance = PusherService._();

//   factory PusherService() => _instance;

//   PusherService._();

//   static final _pusher = PusherChannelsFlutter.getInstance();

//   StreamController streamController = StreamController.broadcast();
//   Stream get stream => streamController.stream;

//   static Future<void> initPusher() async {
//     try {
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
//       );
//     } catch (e) {
//       log("error in initialization: $e");
//     }
//   }

//   Future<void> connect() async {
//     try {
//       int? userId;

//       if (_pusher.connectionState == 'CONNECTED') return;
//       if (Get.isRegistered<ProfileController>()) {
//         userId = Get.find<ProfileController>().users.value?.id;
//         await initPusher();
//       }
//       if (userId == null || userId == 0) return;

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
//       channelName: '${AppConstants.pusherChannel}-${Get.find<ProfileController>().users.value?.id}',
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
