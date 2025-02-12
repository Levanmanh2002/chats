import 'package:chats/main.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoContactWidget extends StatelessWidget {
  const InfoContactWidget({super.key, required this.contact});

  final UserModel? contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding(all: 16),
      padding: padding(all: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: appTheme.whiteColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: padding(left: 60),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: 50,
                  child: CustomImageWidget(
                    imageUrl: contact?.avatar ?? '',
                    size: 60.w,
                    colorBoder: appTheme.whiteColor,
                    sizeBorder: 2.w,
                    showBoder: true,
                  ),
                ),
                CustomImageWidget(
                  imageUrl: Get.find<ProfileController>().user.value?.avatar ?? '',
                  size: 60.w,
                  colorBoder: appTheme.whiteColor,
                  sizeBorder: 2.w,
                  showBoder: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'you_and_field'.trParams({'field': contact?.name ?? 'not_updated_yet'.tr}),
            style: StyleThemeData.size16Weight600(),
          ),
          SizedBox(height: 4.h),
          Text(
            'have_become_friends_with_each_other'.tr,
            style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
          ),
        ],
      ),
    );
  }
}
