import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/make_friends/make_friends_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MakeFriendsPage extends GetWidget<MakeFriendsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildCustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 40.h),

              // Profile card
              _buildProfileCard(),

              SizedBox(height: 32.h),

              // Additional info section
              _buildAdditionalInfo(),

              SizedBox(height: 40.h),
            ],
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: appTheme.blackColor,
            size: 18.w,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      title: Text(
        'make_friends'.tr,
        style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.appColor,
            appTheme.appColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: appTheme.appColor.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with enhanced styling
          _buildProfileAvatar(),

          SizedBox(height: 20.h),

          // Name and phone
          Text(
            controller.contact?.name ?? '',
            style: StyleThemeData.size22Weight700(color: Colors.white),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 6.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${controller.contact?.phone?.formatPhoneCode}',
              style: StyleThemeData.size14Weight500(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Status indicator
          _buildStatusIndicator(),

          SizedBox(height: 24.h),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        // Outer glow ring
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0),
              width: 3,
            ),
          ),
        ),

        // Avatar
        Positioned(
          left: 6.w,
          top: 6.w,
          child: Stack(
            children: [
              CustomImageWidget(
                imageUrl: controller.contact?.avatar ?? '',
                size: 108.w,
                colorBoder: Colors.white,
                showBoder: true,
                sizeBorder: 3,
              ),
              if (controller.contact?.isChecked == true)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 12.w,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: controller.contact?.isChecked == true ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            controller.contact?.isChecked == true ? 'online_now'.tr : 'last_seen_recently'.tr,
            style: StyleThemeData.size12Weight500(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Message button
        Expanded(
          child: Obx(
            () => Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.onMessage,
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: controller.isLoadingMessage.isTrue
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.message_outlined,
                                color: Colors.white,
                                size: 18.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'send_message'.tr,
                                style: StyleThemeData.size14Weight600(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Friend action button
        Expanded(
          child: _buildFriendActionButton(),
        ),
      ],
    );
  }

  Widget _buildFriendActionButton() {
    return Obx(() {
      String buttonText;
      Color buttonColor;
      Color textColor;
      IconData iconData;
      bool isLoading;
      VoidCallback? onPressed;

      if (controller.contact?.isSenderRequestFriend == true) {
        buttonText = 'revoke'.tr;
        buttonColor = Colors.white;
        textColor = appTheme.errorColor;
        iconData = Icons.cancel_outlined;
        isLoading = controller.isLoadingRemove.isTrue;
        onPressed = controller.removeFriend;
      } else if (controller.contact?.isFriend == true) {
        buttonText = 'unfriend'.tr;
        buttonColor = Colors.white;
        textColor = appTheme.errorColor;
        iconData = Icons.person_remove_outlined;
        isLoading = controller.isLoadingUnfriend.isTrue;
        onPressed = controller.unfriend;
      } else {
        buttonText = 'add_friend'.tr;
        buttonColor = Colors.white;
        textColor = appTheme.appColor;
        iconData = Icons.person_add_outlined;
        isLoading = controller.isLoadingAdd.isTrue;
        onPressed = controller.addFriend;
      }

      return Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        color: textColor,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconData,
                          color: textColor,
                          size: 18.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          buttonText,
                          style: StyleThemeData.size14Weight600(
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAdditionalInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: appTheme.appColor,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'connection_info'.tr,
                style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'phone_number'.tr,
            value: controller.contact?.phone?.formatPhoneCode ?? '',
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            icon: Icons.access_time_outlined,
            label: 'last_online'.tr,
            value: controller.contact?.isChecked == true ? 'online_now'.tr : 'last_seen_recently'.tr,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            icon: Icons.people_outline,
            label: 'relationship_status'.tr,
            value: controller.contact?.isFriend == true
                ? 'friends'.tr
                : controller.contact?.isSenderRequestFriend == true
                    ? 'request_sent'.tr
                    : 'not_connected'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.w,
          color: appTheme.greyColor.withOpacity(0.7),
        ),
        SizedBox(width: 12.w),
        Text(
          label,
          style: StyleThemeData.size12Weight400(
            color: appTheme.greyColor.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: StyleThemeData.size12Weight500(color: appTheme.blackColor),
        ),
      ],
    );
  }
}
