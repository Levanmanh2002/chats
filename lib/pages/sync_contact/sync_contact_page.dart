import 'package:chats/main.dart';
import 'package:chats/pages/sync_contact/sync_contact_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncContactPage extends GetWidget<SyncContactController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildCustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),

                // Illustration container với shadow
                _buildIllustrationSection(),

                SizedBox(height: 40.h),

                // Content card với shadow
                _buildContentCard(),

                SizedBox(height: 40.h),

                // Sync button
                _buildSyncButton(),

                SizedBox(height: 32.h),

                // Additional info với subtle design
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
        'sync_contacts'.tr,
        style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
      ),
      centerTitle: true,
    );
  }

  Widget _buildIllustrationSection() {
    return Container(
      padding: EdgeInsets.all(32.w),
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
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ImageAssetCustom(
              imagePath: ImagesAssets.unionSyncImage,
              size: 140.w,
            ),
          ),

          SizedBox(height: 24.h),

          // Animated sync indicator
          _buildSyncIndicator(),
        ],
      ),
    );
  }

  Widget _buildSyncIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0),
        SizedBox(width: 8.w),
        _buildDot(1),
        SizedBox(width: 8.w),
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: appTheme.appColor.withOpacity(0.3 + (index * 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28.w),
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
        children: [
          // Title với accent color
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 4.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: appTheme.appColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'sync_contacts_print'.tr,
                  style: StyleThemeData.size22Weight700(color: appTheme.blackColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 4.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: appTheme.appColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Content với better typography
          _buildContentItem(
            icon: Icons.contacts_outlined,
            text: 'sync_contacts_content_1'.tr,
          ),

          SizedBox(height: 16.h),

          _buildContentItem(
            icon: Icons.sync_outlined,
            text: 'sync_contacts_content_2'.tr,
          ),

          SizedBox(height: 20.h),

          // Features list
          _buildFeaturesList(),
        ],
      ),
    );
  }

  Widget _buildContentItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: appTheme.appColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: appTheme.appColor,
            size: 20.w,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              text,
              style: StyleThemeData.size14Weight400(
                color: appTheme.blackColor.withOpacity(0.8),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'secure_sync'.tr,
      'instant_access'.tr,
      'cross_platform'.tr,
    ];

    return Column(
      children: features
          .map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      feature,
                      style: StyleThemeData.size12Weight500(
                        color: appTheme.greyColor,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSyncButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => Container(
          height: 56.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                appTheme.appColor,
                appTheme.appColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: appTheme.appColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.syncContacts,
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
                            'syncing'.tr,
                            style: StyleThemeData.size16Weight600(color: Colors.white),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sync,
                            color: Colors.white,
                            size: 20.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'sync_contacts'.tr,
                            style: StyleThemeData.size16Weight600(color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appTheme.greyColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: appTheme.appColor,
            size: 20.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'sync_privacy_notice'.tr,
              style: StyleThemeData.size12Weight400(
                color: appTheme.greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
