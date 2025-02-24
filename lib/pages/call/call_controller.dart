import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "5b5c09358c194f21ac343634a5621bfc";
const token =
    "007eJxTYGBZt81Ey49PSzik9dOZH+XR364UPd+xsD2xK0u70oPxhoACg2mSabKBpbGpRbKhpUmakWFisrGJsZmxSaKpmZFhUlpyRPae9IZARgZNBmFmRgYIBPEFGdJySktKUovikzMSS+KTE3NyGBgAgmIiYw==";
const channel = "flutter_chat_call";

class CallController extends GetxController {
  var remoteUidValue = 0.obs;
  var localUserJoined = false.obs;
  late RtcEngine engine;

  @override
  void onInit() {
    initAgora();
    super.onInit();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
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
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await engine.leaveChannel();
    await engine.release();
  }
}
