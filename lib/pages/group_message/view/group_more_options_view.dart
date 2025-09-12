import 'package:chats/main.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/instant_message/instant_message_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupMoreOptionsView extends GetView<GroupMessageController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Padding(
        padding: padding(horizontal: 12, vertical: 12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // buildOption(
              //   'Vị trí'.tr,
              //   Icons.location_on,
              //   onTap: () {},
              // ),
              buildOption(
                'quick_and_message'.tr,
                Icons.message,
                onTap: () => Get.toNamed(
                  Routes.INSTANT_MESSAGE,
                  arguments: InstantMessageParameter(type: InstantMessageType.noChatId),
                ),
              ),
              buildOption(
                'notes'.tr,
                Icons.note,
                onTap: () => controller.addQuickMessage(),
              ),
              buildOption(
                'Cloud'.tr,
                Icons.file_open,
                onTap: () => controller.onClound(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOption(String title, IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: appTheme.whiteColor,
              borderRadius: BorderRadius.circular(25.w),
            ),
            child: Icon(
              icon,
              size: 24.w,
              color: appTheme.appColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: StyleThemeData.size12Weight400(color: appTheme.blackColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
