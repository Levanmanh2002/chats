import 'package:chats/main.dart';
import 'package:chats/pages/features/features_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturesPage extends GetWidget<FeaturesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7C4DFF),
              Color(0xFF9C27B0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildFeaturesList()),
              _buildStartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: padding(horizontal: 24, top: 24),
      child: Column(
        children: [
          Text(
            AppConstants.appName,
            style: StyleThemeData.size32Weight600(color: appTheme.whiteColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            'discover_connection_power'.tr,
            style: StyleThemeData.size16Weight400(
              color: appTheme.whiteColor.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Padding(
      padding: padding(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFeatureCard(
            icon: Icons.chat_bubble,
            iconColor: const Color(0xFF7C4DFF),
            title: 'messages'.tr,
            subtitle: 'unlimited'.tr,
            description: 'send_messages_images_videos_files'.tr,
            additionalText: 'completely_free_unlimited'.tr,
            hasAnimation: true,
          ),
          SizedBox(height: 24.h),
          _buildFeatureCard(
            icon: Icons.phone,
            iconColor: appTheme.greenColor,
            title: 'calls'.tr,
            subtitle: 'Crystal Clear',
            description: 'super_clear_sound_with_technology'.tr,
            additionalText: 'smart_noise_cancellation'.tr,
            hasAnimation: false,
            showSoundWaves: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String description,
    required String additionalText,
    bool hasAnimation = false,
    bool showSoundWaves = false,
  }) {
    return Container(
      width: double.infinity,
      padding: padding(all: 24),
      decoration: BoxDecoration(
        color: appTheme.whiteColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIconSection(icon, iconColor, hasAnimation, showSoundWaves),
          SizedBox(width: 20.w),
          Expanded(
            child: _buildContentSection(title, subtitle, description, additionalText, iconColor),
          ),
        ],
      ),
    );
  }

  Widget _buildIconSection(IconData icon, Color iconColor, bool hasAnimation, bool showSoundWaves) {
    return SizedBox(
      width: 80.w,
      height: 80.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer circle with animation
          if (hasAnimation)
            TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 2),
              tween: Tween(begin: 0.0, end: 1.0),
              onEnd: () => controller.restartAnimation(),
              builder: (context, value, child) {
                return Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor.withOpacity(0.3 * (1 - value)),
                      width: 2,
                    ),
                  ),
                );
              },
            ),

          // Static outer circle for calls
          if (!hasAnimation)
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: iconColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),

          // Sound waves for calls
          if (showSoundWaves) ..._buildSoundWaves(),

          // Main icon circle
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: appTheme.whiteColor,
              size: 28.w,
            ),
          ),

          // Floating bubbles for messages
          if (hasAnimation) ..._buildFloatingBubbles(),
        ],
      ),
    );
  }

  List<Widget> _buildSoundWaves() {
    return [
      Positioned(
        right: 8,
        child: Row(
          children: List.generate(4, (index) {
            return Container(
              width: 3.w,
              height: (20 + index * 8).h,
              margin: padding(right: 2),
              decoration: BoxDecoration(
                color: appTheme.greenColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ),
    ];
  }

  List<Widget> _buildFloatingBubbles() {
    return [
      Positioned(
        top: 10,
        right: 5,
        child: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: const Color(0xFF7C4DFF).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        bottom: 15,
        left: 8,
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: const Color(0xFF7C4DFF).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ];
  }

  Widget _buildContentSection(
      String title, String subtitle, String description, String additionalText, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StyleThemeData.size20Weight700(color: appTheme.blackColor),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: StyleThemeData.size14Weight600(color: accentColor),
        ),
        SizedBox(height: 8.h),
        Text(
          description,
          style: StyleThemeData.size14Weight400(color: appTheme.grayColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          additionalText,
          style: StyleThemeData.size14Weight400(color: appTheme.grayColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: padding(horizontal: 24, bottom: 40),
      child: Container(
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          color: appTheme.whiteColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(27),
          border: Border.all(
            color: appTheme.whiteColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(27),
            onTap: () => controller.navigateToNext(),
            child: Padding(
              padding: padding(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'start_experience'.tr,
                    style: StyleThemeData.size16Weight600(color: appTheme.whiteColor),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.arrow_forward,
                    color: appTheme.whiteColor,
                    size: 20.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
