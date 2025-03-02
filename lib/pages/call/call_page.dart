import 'package:chats/main.dart';
import 'package:chats/pages/call/call_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallPage extends GetWidget<CallController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.appColor,
      appBar: DefaultAppBar(backgroundColor: appTheme.appColor, colorIcon: appTheme.whiteColor),
      body: Padding(
        padding: padding(all: 16),
        child: Center(
          child: Column(
            children: [
              ImageAssetCustom(imagePath: ImagesAssets.logoTitileWhiteImage, size: 61.w),
              SizedBox(height: 40.h),
              CustomImageWidget(
                imageUrl: controller.parameter.avatar,
                size: 160,
                noImage: false,
                showBoder: true,
                colorBoder: appTheme.blueBFFColor,
                sizeBorder: 4,
                name: controller.parameter.name,
                isShowNameAvatar: true,
              ),
              SizedBox(height: 24.h),
              Text(
                controller.parameter.name,
                style: StyleThemeData.size20Weight600(color: appTheme.whiteColor),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                if (controller.connectionDuration.value > 0) {
                  final minutes = (controller.connectionDuration.value ~/ 60).toString().padLeft(2, '0');
                  final seconds = (controller.connectionDuration.value % 60).toString().padLeft(2, '0');
                  return Text(
                    '$minutes:$seconds',
                    style: StyleThemeData.size16Weight400(color: appTheme.greenF00Color),
                  );
                }
                return Text(
                  'Đang kết nối',
                  style: StyleThemeData.size16Weight400(color: appTheme.greenF00Color),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: padding(top: 12, horizontal: 16, bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: controller.toggleSpeaker,
                      icon: ImageAssetCustom(
                        imagePath: controller.isSpeakerOn.value
                            ? IconsAssets.audioBorderImage
                            : IconsAssets.audioOffBorderImage,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text('Loa', style: StyleThemeData.size12Weight400(color: appTheme.whiteColor)),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: controller.endCall,
                    icon: const ImageAssetCustom(imagePath: IconsAssets.phoneBorderImage),
                  ),
                  SizedBox(height: 4.h),
                  Text('Kết thúc', style: StyleThemeData.size12Weight400(color: appTheme.whiteColor)),
                ],
              ),
            ),
            Flexible(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: controller.toggleMic,
                      icon: ImageAssetCustom(
                        imagePath:
                            controller.isMicMuted.value ? IconsAssets.micOffBorderImage : IconsAssets.micBorderImage,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text('Mic', style: StyleThemeData.size12Weight400(color: appTheme.whiteColor)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // body: Obx(
      //   () => Stack(
      //     children: [
      //       Center(
      //         child: _remoteVideo(),
      //       ),
      //       Align(
      //         alignment: Alignment.topLeft,
      //         child: SizedBox(
      //           width: 100,
      //           height: 150,
      //           child: Center(
      //             child: controller.localUserJoined.value
      //                 ? AgoraVideoView(
      //                     controller: VideoViewController(
      //                       rtcEngine: controller.engine,
      //                       canvas: const VideoCanvas(uid: 0),
      //                     ),
      //                   )
      //                 : const CircularProgressIndicator(),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // Widget _remoteVideo() {
  //   if (controller.remoteUidValue.value != 0) {
  //     return AgoraVideoView(
  //       controller: VideoViewController.remote(
  //         rtcEngine: controller.engine,
  //         canvas: VideoCanvas(uid: controller.remoteUidValue.value),
  //         connection: const RtcConnection(channelId: channel),
  //       ),
  //     );
  //   } else {
  //     return const Text(
  //       'Please wait for remote user to join',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }
}
