import 'dart:ui';

import 'package:chats/main.dart';
import 'package:chats/pages/splash/splash_controller.dart';
import 'package:chats/pages/splash/view/loading_dots_view.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetWidget<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: appTheme.whiteColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Center(
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 60.w,
                        color: appTheme.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Obx(
                () => AnimatedOpacity(
                  opacity: controller.titleOpacity.value,
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    AppConstants.appName,
                    style: StyleThemeData.size32Weight600(color: appTheme.whiteColor),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                () => AnimatedOpacity(
                  opacity: controller.subtitleOpacity.value,
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'connect_anywhere'.tr,
                    textAlign: TextAlign.center,
                    style: StyleThemeData.size16Weight400(color: appTheme.whiteColor.withOpacity(0.8)),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              LoadingDotsView(),
            ],
          ),
        ),
      ),
    );
  }
}
