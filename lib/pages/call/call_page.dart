import 'package:chats/main.dart';
import 'package:chats/pages/call/call_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallPage extends GetWidget<CallController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryColor,
      appBar: _buildCustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              appTheme.primaryColor,
              appTheme.primaryColor.withOpacity(0.8),
              appTheme.primaryColor.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40.h),

                // App logo
                _buildAppLogo(),

                SizedBox(height: 60.h),

                // Contact info
                _buildContactInfo(),

                SizedBox(height: 16.h),
                // Call controls
                _buildCallControls(),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18.w,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      title: Text(
        'voice_call'.tr,
        style: StyleThemeData.size18Weight600(color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAppLogo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ImageAssetCustom(
        imagePath: ImagesAssets.logoTitileWhiteImage,
        size: 50.w,
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        // Contact avatar với glow effect
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 4,
              ),
            ),
            child: CustomImageWidget(
              imageUrl: controller.parameter.avatar,
              size: 160,
              noImage: false,
              showBoder: true,
              colorBoder: Colors.white,
              sizeBorder: 2,
              name: controller.parameter.name,
              isShowNameAvatar: true,
            ),
          ),
        ),

        SizedBox(height: 32.h),

        // Contact name
        Text(
          controller.parameter.name,
          style: StyleThemeData.size24Weight700(color: Colors.white),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 12.h),

        // Call status/duration
        _buildCallStatus(),

        SizedBox(height: 20.h),

        // Call quality indicator
        _buildCallQualityIndicator(),
      ],
    );
  }

  Widget _buildCallStatus() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Obx(() {
        if (controller.connectionDuration.value > 0) {
          final minutes = (controller.connectionDuration.value ~/ 60).toString().padLeft(2, '0');
          final seconds = (controller.connectionDuration.value % 60).toString().padLeft(2, '0');
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '$minutes:$seconds',
                style: StyleThemeData.size18Weight600(color: Colors.white),
              ),
            ],
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'connecting'.tr,
              style: StyleThemeData.size16Weight500(color: Colors.white),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCallQualityIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.signal_cellular_4_bar,
            color: Colors.white.withOpacity(0.8),
            size: 16.w,
          ),
          SizedBox(width: 6.w),
          Text(
            'excellent_quality'.tr,
            style: StyleThemeData.size12Weight400(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallControls() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Speaker control
            _buildControlButton(
              icon: controller.isSpeakerOn.value ? Icons.volume_up : Icons.volume_off,
              label: 'speaker'.tr,
              onPressed: controller.toggleSpeaker,
              isActive: controller.isSpeakerOn.value,
            ),

            // End call control
            _buildEndCallButton(),

            // Mic control
            _buildControlButton(
              icon: controller.isMicMuted.value ? Icons.mic_off : Icons.mic,
              label: 'microphone'.tr,
              onPressed: controller.toggleMic,
              isActive: !controller.isMicMuted.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: isActive ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(30),
              child: Center(
                child: Icon(icon), // For Obx widgets
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: StyleThemeData.size12Weight500(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildEndCallButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.red.withOpacity(0.8),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.endCall,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'end_call'.tr,
          style: StyleThemeData.size12Weight500(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
