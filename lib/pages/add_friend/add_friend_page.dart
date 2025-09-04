import 'package:chats/main.dart';
import 'package:chats/pages/add_friend/add_friend_controller.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/dashboard/dashboard_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendPage extends GetWidget<AddFriendController> {
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

                // Header section with illustration
                _buildHeaderSection(),

                SizedBox(height: 32.h),

                // Search section
                _buildSearchSection(),

                SizedBox(height: 24.h),

                // Friend list section
                _buildFriendListSection(),

                SizedBox(height: 24.h),

                // Additional info
                _buildAdditionalInfo(),

                SizedBox(height: 40.h),
              ],
            ),
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
        'add_friend'.tr,
        style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.appColor.withOpacity(0.1),
            appTheme.appColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: appTheme.appColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Illustration với floating effect
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: appTheme.appColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ImageAssetCustom(
              imagePath: ImagesAssets.addFriendImage,
              size: 80.w,
            ),
          ),

          SizedBox(height: 20.h),

          Text(
            'connect_with_friends'.tr,
            style: StyleThemeData.size20Weight700(color: appTheme.blackColor),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            'add_friends_by_phone_desc'.tr,
            style: StyleThemeData.size14Weight400(
              color: appTheme.greyColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
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
                  color: appTheme.appColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'search_by_phone'.tr,
                style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Phone input with search button
          Row(
            children: [
              Expanded(
                child: _buildPhoneInput(),
              ),
              SizedBox(width: 12.w),
              _buildSearchButton(),
            ],
          ),

          SizedBox(height: 12.h),

          // Helper text
          Text(
            'enter_phone_number_to_find'.tr,
            style: StyleThemeData.size12Weight400(
              color: appTheme.greyColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appTheme.greyColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        style: StyleThemeData.size16Weight400(color: appTheme.blackColor),
        cursorColor: appTheme.appColor,
        decoration: InputDecoration(
          hintText: 'enter_phone_number'.tr,
          hintStyle: StyleThemeData.size14Weight400(
            color: appTheme.greyColor.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.w),
          prefixIcon: Container(
            padding: EdgeInsets.all(16.w),
            child: Icon(
              Icons.phone_outlined,
              color: appTheme.appColor,
              size: 20.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Obx(
      () => Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          gradient: controller.isFormValid.value
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appTheme.appColor,
                    appTheme.appColor.withOpacity(0.8),
                  ],
                )
              : null,
          color: controller.isFormValid.value ? null : appTheme.greyColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: controller.isFormValid.value
              ? [
                  BoxShadow(
                    color: appTheme.appColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.isFormValid.value ? controller.onSearchAccount : null,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Icon(
                Icons.search,
                color: controller.isFormValid.value ? Colors.white : appTheme.greyColor.withOpacity(0.5),
                size: 20.w,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendListSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.back();
            Get.find<DashboardController>().animateToTab(1);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: appTheme.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.contacts_outlined,
                      color: appTheme.appColor,
                      size: 20.w,
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'friend_list'.tr,
                            style: StyleThemeData.size16Weight500(color: appTheme.blackColor),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: appTheme.appColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${Get.find<ContactsController>().contactModel.value?.data?.length ?? '0'}',
                              style: StyleThemeData.size12Weight600(
                                color: appTheme.appColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'view_manage_contacts'.tr,
                        style: StyleThemeData.size12Weight400(
                          color: appTheme.greyColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: appTheme.greyColor.withOpacity(0.5),
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
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
                size: 18.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'how_to_add_friends'.tr,
                style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...(_getAddFriendTips().map(
            (tip) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    margin: EdgeInsets.only(top: 8.h, right: 8.w),
                    decoration: BoxDecoration(
                      color: appTheme.appColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
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

  List<String> _getAddFriendTips() {
    return [
      'enter_exact_phone_number'.tr,
      'friend_must_have_account'.tr,
      'check_contact_list_regularly'.tr,
      'invite_friends_to_join'.tr,
    ];
  }
}
