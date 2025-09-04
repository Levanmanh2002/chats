import 'package:chats/main.dart';
import 'package:chats/pages/update_password/update_password_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordPage extends GetWidget<UpdatePasswordController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildCustomAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 24.h),

                // Security header
                _buildSecurityHeader(),

                SizedBox(height: 32.h),

                // Password form card
                _buildPasswordForm(),

                SizedBox(height: 32.h),

                // Password requirements
                _buildPasswordRequirements(),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildSaveButton(),
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
        'update_password'.tr,
        style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSecurityHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Security icon với glow effect
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.security,
              color: Colors.red,
              size: 40.w,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'password_security'.tr,
            style: StyleThemeData.size20Weight700(color: appTheme.blackColor),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            'password_security_desc'.tr,
            style: StyleThemeData.size14Weight400(
              color: appTheme.greyColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'change_password'.tr,
                style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // New password field
          _buildCustomPasswordField(
            controller: controller.newPasswordController,
            label: 'new_password'.tr,
            hint: 'enter_password'.tr,
            icon: Icons.lock_outline,
            onChanged: controller.validatePassword,
            onValidate: (value) {
              controller.showPassword.value = value;
              controller.isHidePassword.value = false;
              return CustomValidator.validatePassword(value);
            },
          ),

          SizedBox(height: 20.h),

          // Confirm password field
          _buildCustomPasswordField(
            controller: controller.confirmNewPasswordController,
            label: 'confirm_new_password'.tr,
            hint: 'enter_password'.tr,
            icon: Icons.lock_reset_outlined,
            onChanged: controller.validateConfirmPassword,
            onValidate: (value) {
              if (value != controller.newPasswordController.text) {
                return 'passwords_do_not_match'.tr;
              }
              return '';
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    Function(String)? onChanged,
    String Function(String)? onValidate,
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
              color: Colors.red,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // Password field với custom design
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: appTheme.greyColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: CustomTextField(
            controller: controller,
            onChanged: onChanged,
            isPassword: true,
            showBorder: false,
            showLine: false,
            hintText: hint,
            onValidate: onValidate,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appTheme.greyColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                'password_requirements'.tr,
                style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...(_getPasswordRequirements().map(
            (requirement) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    margin: EdgeInsets.only(top: 8.h, right: 8.w),
                    decoration: BoxDecoration(
                      color: appTheme.greyColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      requirement,
                      style: StyleThemeData.size12Weight400(
                        color: appTheme.greyColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  List<String> _getPasswordRequirements() {
    return [
      'password_cannot_be_empty'.tr,
      'password_must_contain_at_least_4_characters'.tr,
    ];
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
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
                        Colors.red,
                        Colors.red.withOpacity(0.8),
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
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.isFormValid.isTrue ? controller.updatePassword : null,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: controller.isLoading.isTrue
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'updating'.tr,
                              style: StyleThemeData.size16Weight600(color: Colors.white),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                              size: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'save_password'.tr,
                              style: StyleThemeData.size16Weight600(color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
