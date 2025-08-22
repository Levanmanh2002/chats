import 'package:chats/main.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SkipVerificationDialog extends StatelessWidget {
  const SkipVerificationDialog({super.key, required this.onSkip});

  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appTheme.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titlePadding: EdgeInsets.all(24.w),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      actionsPadding: EdgeInsets.all(16.w),

      // Icon warning
      icon: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.warning_amber_rounded,
          color: Colors.orange.shade600,
          size: 32.w,
        ),
      ),

      // Title
      title: Text(
        'skip_confirmation_title'.tr,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
        textAlign: TextAlign.center,
      ),

      // Content
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'skip_confirmation_message'.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange.shade600,
                  size: 16.w,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'skip_confirmation_warning'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [
        OutlinedButton(
          onPressed: () => Get.back(),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(100.w, 40.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Text(
            'no_continue'.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            if (onSkip != null) {
              onSkip!();
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(100.w, 40.h),
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'yes_skip'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
