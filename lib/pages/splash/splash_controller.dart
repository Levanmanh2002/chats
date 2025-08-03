import 'package:chats/routes/pages.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final isLoggedIn = LocalStorage.getBool(SharedKey.isLoggedIn);
  final isSecurity = LocalStorage.getBool(SharedKey.IS_SHOW_SECURITY_SCREEN);
  final isShowFeature = LocalStorage.getBool(SharedKey.IS_SHOW_FEATURES_SCREEN);

  var titleOpacity = 0.0.obs;
  var subtitleOpacity = 0.0.obs;
  var loadingProgress = 0.0.obs;
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _startSplashSequence();

    // Future.delayed(const Duration(milliseconds: 500)).then((value) => init());
  }

  void _startSplashSequence() async {
    // Animation fade in title
    await Future.delayed(const Duration(milliseconds: 500));
    titleOpacity.value = 1.0;

    // Animation fade in subtitle
    await Future.delayed(const Duration(milliseconds: 300));
    subtitleOpacity.value = 1.0;

    // Bắt đầu loading animation
    await Future.delayed(const Duration(milliseconds: 500));
    _startLoadingAnimation();

    // Simulate loading process
    await _simulateLoading();

    // Navigate to next screen
    _navigateToNext();
  }

  void _startLoadingAnimation() {
    animationController.repeat();
  }

  Future<void> _simulateLoading() async {
    // Simulate app initialization
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      loadingProgress.value = i / 100;
    }
  }

  void _navigateToNext() {
    // Dừng animation
    animationController.stop();

    init();
  }

  void init() async {
    if (isSecurity) {
      Get.offAllNamed(Routes.CONFIRM_SECURITY_CODE);
    } else if (isLoggedIn) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      if (isShowFeature == false) {
        Get.offAllNamed(Routes.FEATURES);
      } else {
        Get.offAllNamed(Routes.SIGN_IN);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
