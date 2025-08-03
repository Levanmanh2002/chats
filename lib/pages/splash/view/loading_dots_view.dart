import 'package:chats/main.dart';
import 'package:chats/pages/splash/splash_controller.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDotsView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            // Tính toán delay cho mỗi dot
            double delay = index * 0.2;
            double animValue = (controller.animationController.value - delay).clamp(0.0, 1.0);

            // Animation curve cho mỗi dot
            double offsetY = 0;
            double opacity = 0.3;

            if (animValue > 0 && animValue <= 0.6) {
              double progress = animValue / 0.6;
              offsetY = -20 * Curves.easeInOut.transform(progress);
              opacity = 0.3 + (0.7 * progress);
            } else if (animValue > 0.6) {
              double progress = (animValue - 0.6) / 0.4;
              offsetY = -20 * (1 - Curves.easeInOut.transform(progress));
              opacity = 1.0 - (0.7 * progress);
            }

            return Container(
              margin: padding(horizontal: 2.5.w),
              child: Transform.translate(
                offset: Offset(0, offsetY),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: appTheme.whiteColor.withOpacity(opacity),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
