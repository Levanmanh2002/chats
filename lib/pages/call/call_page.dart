import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/call/call_controller.dart';
import 'package:chats/pages/call/call_parameter.dart';
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
              if (controller.parameter.type == CallType.incomingCall) ...[
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
                    'connecting'.tr,
                    style: StyleThemeData.size16Weight400(color: appTheme.greenF00Color),
                  );
                }),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  height: 240.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: appTheme.blueBFFColor, width: 4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Obx(
                      () => controller.remoteUidValue.value != 0
                          ? AgoraVideoView(
                              controller: VideoViewController.remote(
                                rtcEngine: controller.engine,
                                canvas: VideoCanvas(uid: controller.remoteUidValue.value),
                                connection: RtcConnection(
                                  channelId: controller.parameter.channel,
                                ),
                              ),
                            )
                          : Container(
                              color: appTheme.appColor,
                              child: Center(
                                child: Text(
                                  'connecting'.tr,
                                  style: StyleThemeData.size16Weight400(color: appTheme.whiteColor),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ] else ...[
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
                    'connecting'.tr,
                    style: StyleThemeData.size16Weight400(color: appTheme.greenF00Color),
                  );
                }),
              ],
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
                    Text('speaker'.tr, style: StyleThemeData.size12Weight400(color: appTheme.whiteColor)),
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
                  Text('end'.tr, style: StyleThemeData.size12Weight400(color: appTheme.whiteColor)),
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
    );
  }
}
