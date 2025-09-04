import 'package:chats/main.dart';
import 'package:chats/pages/update_profile/update_profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UpdateProfilePage extends GetWidget<UpdateProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildCustomAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header với gradient background
              _buildProfileHeader(),

              SizedBox(height: 32.h),

              // Form container với shadow
              _buildFormSection(),

              SizedBox(height: 32.h),

              // Save button
              _buildSaveButton(),

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
        'personal_information'.tr,
        style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
            color: appTheme.appColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar với camera button
          _buildAvatarSection(),

          SizedBox(height: 16.h),

          // User info
          Text(
            controller.user?.name ?? '',
            style: StyleThemeData.size20Weight700(color: Colors.white),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              controller.user?.phone?.replaceFirst(controller.phoneCode.value.getCodeAsString(), '0') ?? '',
              style: StyleThemeData.size14Weight500(color: Colors.white.withOpacity(0.9)),
            ),
          ),

          SizedBox(height: 16.h),

          // Status badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'active_now'.tr,
                  style: StyleThemeData.size12Weight500(color: appTheme.blackColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      children: [
        // Avatar với border và shadow
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CustomImageWidget(
            imageUrl: controller.user?.avatar ?? '',
            size: 100,
            noImage: false,
            colorBoder: Colors.transparent,
            showBoder: false,
          ),
        ),

        // Camera button với animation
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: controller.pickImageAvatar,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: appTheme.appColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: appTheme.appColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'profile_information'.tr,
                style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Name field
          _buildCustomTextField(
            controller: controller.nameController,
            label: 'your_name'.tr,
            hint: 'enter_your_name'.tr,
            icon: Icons.person_outline,
            formatter: FormatterUtil.fullNameFormatter,
            validator: (value) {
              return CustomValidator.validateName(value ?? '');
            },
          ),

          SizedBox(height: 20.h),

          // Auto message field
          _buildCustomTextField(
            controller: controller.autoMessage,
            label: 'auto_message'.tr,
            hint: 'enter_auto_message_content'.tr,
            icon: Icons.message_outlined,
            formatter: FormatterUtil.chatMessageFormatter,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    List<TextInputFormatter>? formatter,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label với icon
        Row(
          children: [
            Icon(
              icon,
              size: 20.w,
              color: appTheme.appColor,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // Text field với custom design
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: appTheme.greyColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            inputFormatters: formatter,
            validator: validator,
            cursorColor: appTheme.appColor,
            style: StyleThemeData.size16Weight400(color: appTheme.blackColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: StyleThemeData.size14Weight400(
                color: appTheme.greyColor.withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(
        () => Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: controller.isFormValid.isTrue
                  ? [
                      appTheme.appColor,
                      appTheme.appColor.withOpacity(0.8),
                    ]
                  : [
                      appTheme.greyColor.withOpacity(0.3),
                      appTheme.greyColor.withOpacity(0.3),
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: controller.isFormValid.isTrue
                ? [
                    BoxShadow(
                      color: appTheme.appColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.isFormValid.isTrue ? controller.updateProfile : null,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: controller.isLoading.isTrue
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'save_changes'.tr,
                        style: StyleThemeData.size16Weight600(color: Colors.white),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
