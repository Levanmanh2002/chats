import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:chats/pages/call/call_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class CallController extends GetxController {
  final IMessagesRepository messagesRepository;
  final CallCallParameter parameter;

  CallController({required this.parameter, required this.messagesRepository});

  var remoteUidValue = ''.obs; // ZegoCloud dùng String cho userID
  var localUserJoined = false.obs;
  var connectionDuration = 0.obs;

  var isSpeakerOn = false.obs;
  var isMicMuted = false.obs;

  var isCallId = 0.obs;

  Timer? _timer;

  final ReceivePort _receivePortReject = ReceivePort();

  @override
  void onInit() {
    super.onInit();
    if (parameter.type == CallType.call) {
      _initCall();
    } else if (parameter.type == CallType.incomingCall) {
      initZego(
        token: parameter.token!,
        roomId: parameter.channel!,
      );
    }
    _setupIsolated();
  }

  void _initCall() async {
    try {
      await [Permission.microphone].request();

      final channel = '${parameter.channel}_${parameter.id}_${Get.find<ProfileController>().user.value?.id}';

      Map<String, String> params = {
        "call_id": parameter.callId != null ? parameter.callId.toString() : isCallId.value.toString(),
        "receiver_id": parameter.id.toString(),
        "channel_name": channel,
        "uid": '0',
      };

      final response = await messagesRepository.initCall(params);

      if (response.statusCode == 200) {
        log('Call initiated');
        isCallId.value = response.body['data']['id'];
        await initZego(
          token: response.body['data']['call_token'],
          roomId: response.body['data']['channel_name'],
        );
      } else {
        DialogUtils.showErrorDialog('failed_to_start_call'.tr);
        await endCall();
        Get.back();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> initZego({required String token, required String roomId}) async {
    try {
      // Xin quyền microphone
      await [Permission.microphone].request();

      // Tạo ZegoExpressEngine
      await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
        1867273448, // AppID từ ZegoCloud
        ZegoScenario.StandardVoiceCall,
        appSign: '5ee1c36db5afb252dc4ccd22b0256fb2734675bff66805fd84f0f98cdff8445e',
      ));

      ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, List<ZegoStream> streamList, extendedData) {
        log('🎵 Stream update: $updateType, streams: ${streamList.length}');

        if (updateType == ZegoUpdateType.Add) {
          for (var stream in streamList) {
            log('▶️ Playing stream: ${stream.streamID} from user: ${stream.user.userID}');
            // ✅ QUAN TRỌNG: Play remote audio stream
            ZegoExpressEngine.instance.startPlayingStream(stream.streamID);
          }
        }
      };

      // Đăng ký event handlers
      ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, List<ZegoUser> userList) {
        log('Room user update: $updateType');
        if (updateType == ZegoUpdateType.Add) {
          if (userList.isNotEmpty) {
            remoteUidValue.value = userList[0].userID;
            log("Remote user ${userList[0].userID} joined");
            startTimer();
            _fetchJoinCall();

            if (Platform.isIOS) {
              _enableIOSAudio();
            }
          }
        } else {
          remoteUidValue.value = '';
          log("Remote user left");
          _handleUserLeft();
        }
      };

      ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
        log('Room state update: $state, error: $errorCode');
        if (state == ZegoRoomState.Connected) {
          localUserJoined.value = true;
          log("✅ Local user joined room: $roomID");

          if (Platform.isIOS) {
            Future.delayed(const Duration(milliseconds: 500), () {
              _enableIOSAudio();
            });
          }

          // Timeout nếu không có người join sau 60s
          Future.delayed(const Duration(seconds: 60), () {
            if (remoteUidValue.value.isEmpty) {
              log("Không có ai nhận cuộc gọi, tự động kết thúc.");
              endCall();
            }
          });
        }
      };

      ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
        log('🎤 Remote mic state: $streamID = $state');
      };

      ZegoExpressEngine.onRemoteSoundLevelUpdate = (soundLevels) {
        for (var level in soundLevels.entries) {
          if (level.value > 0) {
            log('🔊 Sound from ${level.key}: ${level.value}');
          }
        }
      };

      ZegoExpressEngine.onCapturedSoundLevelUpdate = (soundLevel) {
        if (soundLevel > 0) {
          log('🎙️ My mic level: $soundLevel');
        }
      };

      // Cấu hình audio
      await ZegoExpressEngine.instance.setAudioConfig(ZegoAudioConfig.preset(ZegoAudioConfigPreset.StandardQuality));

      await ZegoExpressEngine.instance.setAudioRouteToSpeaker(true); // Force speaker

      // Bật microphone
      await ZegoExpressEngine.instance.muteMicrophone(false);

      await ZegoExpressEngine.instance.startSoundLevelMonitor(config: ZegoSoundLevelConfig(1000, true));

      if (Platform.isIOS) {
        await ZegoExpressEngine.instance.setCaptureVolume(100);
        await ZegoExpressEngine.instance.setPlayVolume("user_123", 100);
        log('✅ iOS: Audio pre-configured before join');
      }

      // Tạo user
      final userId = Get.find<ProfileController>().user.value?.id.toString() ?? '0';
      final userName = Get.find<ProfileController>().user.value?.name ?? 'User';
      ZegoUser user = ZegoUser(userId, userName);

      // Join room
      await ZegoExpressEngine.instance.loginRoom(
        roomId,
        user,
        config: ZegoRoomConfig(0, true, token), // token nếu có
      );

      final streamID = 'stream_$userId';
      await ZegoExpressEngine.instance.startPublishingStream(streamID);

      // Start playing all streams
      await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
      await ZegoExpressEngine.instance.muteAllPlayStreamVideo(true); // Voice only
    } catch (e) {
      log('Error initializing Zego: $e');
    }
  }

  void _enableIOSAudio() async {
    if (Platform.isIOS) {
      try {
        // Unmute microphone
        await ZegoExpressEngine.instance.muteMicrophone(false);

        // Set speaker on
        await ZegoExpressEngine.instance.setAudioRouteToSpeaker(true);

        // Set volume
        await ZegoExpressEngine.instance.setCaptureVolume(100);

        // ✅ Đảm bảo play tất cả stream
        await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);

        log('✅ iOS audio fully activated');
      } catch (e) {
        log('⚠️ iOS audio activation error: $e');
      }
    }
  }

  void _handleUserLeft() async {
    // Stop timer
    _timer?.cancel();
    connectionDuration.value = 0;

    // Stop all streams
    await ZegoExpressEngine.instance.stopPublishingStream();
    await ZegoExpressEngine.instance.logoutRoom();

    await _fetchEndCall();

    if (Get.currentRoute == Routes.CALL) {
      Get.back();
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

  // Bật/tắt loa ngoài
  void toggleSpeaker() async {
    isSpeakerOn.value = !isSpeakerOn.value;
    await ZegoExpressEngine.instance.setAudioRouteToSpeaker(isSpeakerOn.value);
    log('🔊 Speaker: ${isSpeakerOn.value ? "ON" : "OFF"}');
  }

  // Bật/tắt mic
  void toggleMic() async {
    isMicMuted.value = !isMicMuted.value;
    await ZegoExpressEngine.instance.muteMicrophone(isMicMuted.value);
  }

  // Kết thúc cuộc gọi
  Future<void> endCall() async {
    await ZegoExpressEngine.instance.stopPublishingStream();
    await ZegoExpressEngine.instance.logoutRoom();
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
    await ZegoExpressEngine.instance.stopPublishingStream();
    await ZegoExpressEngine.instance.logoutRoom();
    await ZegoExpressEngine.destroyEngine();
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
            Get.back();
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
    ZegoExpressEngine.instance.logoutRoom();
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
