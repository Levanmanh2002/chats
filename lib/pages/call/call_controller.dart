import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chats/pages/call/call_parameter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "5b5c09358c194f21ac343634a5621bfc";
const token =
    "007eJxTYGBZt81Ey49PSzik9dOZH+XR364UPd+xsD2xK0u70oPxhoACg2mSabKBpbGpRbKhpUmakWFisrGJsZmxSaKpmZFhUlpyRPae9IZARgZNBmFmRgYIBPEFGdJySktKUovikzMSS+KTE3NyGBgAgmIiYw==";
const channel = "flutter_chat_call";

class CallController extends GetxController {
  final CallCallParameter parameter;

  CallController({required this.parameter});

  var remoteUidValue = 0.obs;
  var localUserJoined = false.obs;
  var connectionDuration = 0.obs;

  var isSpeakerOn = false.obs;
  var isMicMuted = false.obs;

  late RtcEngine engine;

  Timer? _timer;

  @override
  void onInit() {
    initAgora();
    super.onInit();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [
      Permission.microphone,
      // Permission.camera,
    ].request();

    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log("local user ${connection.localUid} joined");
          localUserJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log("remote user $remoteUid joined");
          remoteUidValue.value = remoteUid;
          startTimer();
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          log("remote user $remoteUid left channel");
          remoteUidValue.value = 0;
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          log('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: token,
      channelId: channel,
      uid: parameter.contact?.id ?? 0,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: false,
      ),
    );
  }

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
    Get.back(); // Quay về màn hình trước
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _dispose();
  }

  Future<void> _dispose() async {
    await engine.leaveChannel();
    await engine.release();
  }
}
