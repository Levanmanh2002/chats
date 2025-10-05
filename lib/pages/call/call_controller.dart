import 'dart:async';
import 'dart:developer';
import 'dart:io';
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
    if (parameter.type == CallType.call) {
      _initCall();
    } else if (parameter.type == CallType.incomingCall) {
      initAgora(
        token: parameter.token!,
        // token:
        //     "007eJxTYJg8geXALvWIgIWTDuuIrJLI3b2xlSv26rRNpl0S0k/PGS1SYEg2TzJMMkxMNUlJMzQxt7C0sEw2MgcyzJJNjMyTjFOvVD3KaAhkZPiY5sjMyACBID43Q0lqcUm8oZGxsZEhAwMA/cIg1g==",
        channel: parameter.channel!,
      );
    }
    _setupIsolated();
  }

  void _initCall() async {
    try {
      final channel = '${parameter.channel}_${parameter.id}_${Get.find<ProfileController>().user.value?.id}';

      Map<String, String> params = {
        "call_id": parameter.callId != null ? parameter.callId.toString() : isCallId.value.toString(),
        "receiver_id": parameter.id.toString(),
        "channel_name": channel,
        // "channel_name": 'test_123321',
        "uid": Get.find<ProfileController>().user.value?.id.toString() ?? '0',
        // "uid": '0',
      };

      final response = await messagesRepository.initCall(params);

      if (response.statusCode == 200) {
        log('Call initiated');
        // _generateToken();
        isCallId.value = response.body['data']['id'];
        await initAgora(
          token: response.body['data']['call_token'],
          // token:
          //     "007eJxTYJg8geXALvWIgIWTDuuIrJLI3b2xlSv26rRNpl0S0k/PGS1SYEg2TzJMMkxMNUlJMzQxt7C0sEw2MgcyzJJNjMyTjFOvVD3KaAhkZPiY5sjMyACBID43Q0lqcUm8oZGxsZEhAwMA/cIg1g==",
          channel: response.body['data']['channel_name'],
          // channel: 'test_123321',
        );
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
        // appId: "c7b1b1ae4df1478989c274786c427b3e",
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));
      await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioDefault,
      );

      // ✅ THÊM: Enable local audio
      await engine.enableAudio();
      await engine.enableLocalAudio(true);

      // ✅ THÊM: Set speaker và volume
      await engine.setDefaultAudioRouteToSpeakerphone(true);
      await engine.adjustRecordingSignalVolume(100);
      await engine.adjustPlaybackSignalVolume(100);

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            log("local user ${connection.localUid} joined");
            localUserJoined.value = true;
            Future.delayed(const Duration(seconds: 60), () {
              if (remoteUidValue.value == 0) {
                log("Không có ai nhận cuộc gọi, tự động kết thúc.");
                endCall();
              }
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) async {
            log("remote user $remoteUid joined");
            remoteUidValue.value = remoteUid;
            // stopRingtone();
            startTimer();
            _fetchJoinCall();
            // engine.muteLocalAudioStream(true);

            if (Platform.isIOS) {
              // Delay nhỏ để đảm bảo CallKit đã sẵn sàng
              await Future.delayed(const Duration(milliseconds: 800));

              try {
                // Force playback volume cao
                await engine.adjustPlaybackSignalVolume(400); // ✅ Tăng lên 400%
                await engine.adjustRecordingSignalVolume(100);

                // Re-enable speaker
                await engine.setEnableSpeakerphone(false);
                await Future.delayed(const Duration(milliseconds: 100));
                await engine.setEnableSpeakerphone(true);

                log('✅ iOS: Audio force-activated for remote user');
              } catch (e) {
                log('⚠️ iOS audio activation error: $e');
              }
            }
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
          onRemoteAudioStateChanged: (RtcConnection connection, int remoteUid, RemoteAudioState state,
              RemoteAudioStateReason reason, int elapsed) {
            log('🎧 Remote audio state: UID=$remoteUid, State=$state, Reason=$reason');

            // ✅ Khi iOS nhận được remote audio, boost volume
            if (Platform.isIOS &&
                (state == RemoteAudioState.remoteAudioStateDecoding ||
                    state == RemoteAudioState.remoteAudioStateStarting)) {
              engine.adjustPlaybackSignalVolume(400);
              log('✅ iOS: Volume boosted to 400%');
            }
          },
          onError: (err, msg) {
            log('onError: $err, $msg');
          },
        ),
      );

      await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      // await engine.enableAudio();
      // await engine.enableLocalAudio(true);

      // // ✅ THÊM: Set speaker và volume
      // await engine.setDefaultAudioRouteToSpeakerphone(true);
      // await engine.adjustRecordingSignalVolume(100);
      // await engine.adjustPlaybackSignalVolume(100);

      await engine.joinChannel(
        token: token,
        channelId: channel,
        uid: parameter.id,
        options: const ChannelMediaOptions(
          autoSubscribeAudio: true,
          autoSubscribeVideo: false,
          publishMediaPlayerAudioTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
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
