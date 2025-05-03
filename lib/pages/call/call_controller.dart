import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chats/pages/call/call_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CallController extends GetxController {
  final IMessagesRepository messagesRepository;
  final CallCallParameter parameter;

  CallController({required this.parameter, required this.messagesRepository});

  var remoteUidValue = 0.obs;
  var localUserJoined = false.obs;
  var connectionDuration = 0.obs;

  var isSpeakerOn = false.obs;
  var isMicMuted = false.obs;

  var isCallId = 0.obs;

  late RtcEngine engine;

  Timer? _timer;

  final ReceivePort _receivePortReject = ReceivePort();

  @override
  void onInit() {
    super.onInit();
    // initAgora();
    if (parameter.type == CallType.call) {
      _initCall();
    } else if (parameter.type == CallType.incomingCall) {
      initAgora(token: parameter.token!, channel: parameter.channel!);
    }
    _setupIsolated();

    // _generateToken();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   _initCall();
  // }

  void _initCall() async {
    try {
      final channel = '${parameter.channel}_${parameter.id}_${Get.find<ProfileController>().user.value?.id}';

      Map<String, String> params = {
        "receiver_id": parameter.id.toString(),
        "channel_name": channel,
        // "uid": '${parameter.id}_${Get.find<ProfileController>().user.value?.id}',
        "uid": '0',
      };

      final response = await messagesRepository.initCall(params);

      if (response.statusCode == 200) {
        log('Call initiated');
        // _generateToken();
        isCallId.value = response.body['data']['id'];
        await initAgora(token: response.body['data']['call_token'], channel: response.body['data']['channel_name']);
      } else {
        log('Call initiation failed');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> initAgora({required String token, required String channel}) async {
    try {
      // retrieve permissions
      await [
        Permission.microphone,
        // Permission.camera,
      ].request();

      engine = createAgoraRtcEngine();
      await engine.initialize(RtcEngineContext(
        appId: AppConstants.callAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
      await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileSpeechStandard,
        scenario: AudioScenarioType.audioScenarioGameStreaming,
      );

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            log("local user ${connection.localUid} joined");
            localUserJoined.value = true;
            // stopRingtone();
            // if (parameter.type == CallType.call) {
            //   startRingtone();
            // }

            Future.delayed(const Duration(seconds: 60), () {
              if (remoteUidValue.value == 0) {
                log("Không có ai nhận cuộc gọi, tự động kết thúc.");
                endCall();
              }
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            log("remote user $remoteUid joined");
            remoteUidValue.value = remoteUid;
            // stopRingtone();
            startTimer();
            _fetchJoinCall();
            engine.muteLocalAudioStream(true);
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) async {
            log("remote user $remoteUid left channel");
            remoteUidValue.value = 0;
            engine.leaveChannel();
            await _fetchEndCall();
            if (Get.currentRoute == Routes.CALL) {
              Get.back();
            }
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            log('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          },
          onError: (err, msg) {
            log('onError: $err, $msg');
          },
        ),
      );

      await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine.enableAudio();
      await engine.startPreview();
      await engine.joinChannel(
        token: token,
        channelId: channel,
        uid: parameter.id,
        options: const ChannelMediaOptions(
          autoSubscribeAudio: true,
          autoSubscribeVideo: false,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _fetchJoinCall() async {
    try {
      Map<String, String> params = {
        "message_id": parameter.callId != null ? parameter.callId.toString() : isCallId.value.toString(),
      };

      final response = await messagesRepository.joinCall(params);

      if (response.statusCode == 200) {
        log('Call joined');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _fetchEndCall() async {
    try {
      Map<String, String> params = {
        "message_id": parameter.messageId.toString(),
      };

      final response = await messagesRepository.rejectCall(params);

      if (response.statusCode == 200) {
        log('Call ended');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Gọi khi bắt đầu cuộc gọi
  // void startRingtone() {
  //   FlutterRingtonePlayer().play(
  //     fromAsset: AudioUtils.outgoingCallRingtone,
  //     // android: AndroidSounds.notification,
  //     ios: IosSounds.glass,
  //     looping: true,
  //   );
  // }

  // // Dừng khi người nhận nghe máy hoặc hủy cuộc gọi
  // void stopRingtone() {
  //   FlutterRingtonePlayer().stop();
  // }

  // Bật/tắt loa ngoài
  void toggleSpeaker() {
    isSpeakerOn.value = !isSpeakerOn.value;
    engine.setEnableSpeakerphone(isSpeakerOn.value);
  }

  // Bật/tắt mic
  void toggleMic() {
    isMicMuted.value = !isMicMuted.value;
    engine.muteLocalAudioStream(isMicMuted.value);
  }

  // Kết thúc cuộc gọi
  Future<void> endCall() async {
    await engine.leaveChannel();
    // stopRingtone();
    await _endCall();
    Get.back();
  }

  Future<void> _endCall() async {
    try {
      final response = await messagesRepository.endCall({
        "message_id": parameter.callId != null ? parameter.callId.toString() : isCallId.value.toString(),
      });

      if (response.statusCode == 200) {
        log('Call ended');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void startTimer() {
    connectionDuration.value = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      connectionDuration.value++;
    });
  }

  void resetTimer() {
    connectionDuration.value = 0;
    _timer?.cancel();
  }

  Future<void> _dispose() async {
    await engine.leaveChannel();
    await engine.release();
    // stopRingtone();
  }

  void _setupIsolated() async {
    IsolateNameServer.removePortNameMapping(AppConstants.rejectCallChannelId);
    IsolateNameServer.registerPortWithName(_receivePortReject.sendPort, AppConstants.rejectCallChannelId);

    _receivePortReject.listen((valueData) async {
      if (valueData is! Map<String, dynamic>) return;
      try {
        final message = RemoteMessage.fromMap(valueData);
        if (message.data['type'] == 'chat' && message.data['call_action'] == 'reject_call') {
          await _dispose();
          if (Get.currentRoute == Routes.CALL) {
            if (Get.currentRoute == Routes.CALL) {
              Get.back();
            }
          }
        }
      } catch (e) {
        // No-op
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    engine.leaveChannel();
    // stopRingtone();
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _dispose();
    _receivePortReject.close();
  }
}
