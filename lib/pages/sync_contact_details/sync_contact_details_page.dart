import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/sync_contact/sync_contact_model.dart';
import 'package:chats/pages/make_friends/make_friends_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/sync_contact_details/sync_contact_details_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/launch_url.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncContactDetailsPage extends GetWidget<SyncContactDetailsController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildCustomAppBar(),
        body: ListLoader(
          onRefresh: controller.fetchSyncContacts,
          onLoad: () => controller.fetchSyncContacts(isRefresh: false),
          hasNext: controller.syncContactModel.value?.hasNext ?? false,
          forceScrollable: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header section
                _buildHeaderSection(),

                // Search section
                _buildSearchSection(),

                // Contact list
                _buildContactList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: appTheme.appColor,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18.w,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      title: Text(
        'sync_contacts'.tr,
        style: StyleThemeData.size20Weight700(color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            appTheme.appColor,
            appTheme.appColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.appColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        child: Column(
          children: [
            // Icon container
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.sync,
                color: Colors.white,
                size: 28.w,
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              'synced_contacts'.tr,
              style: StyleThemeData.size20Weight700(color: Colors.white),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            Text(
              'view_your_synced_contacts'.tr,
              style: StyleThemeData.size14Weight400(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // Last sync info
            _buildLastSyncInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildLastSyncInfo() {
    return Obx(() {
      if ((controller.syncContactModel.value?.lastSyncContacts ?? '').isNotEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white.withOpacity(0.8),
                size: 16.w,
              ),
              SizedBox(width: 8.w),
              Column(
                children: [
                  Text(
                    'last_updated_contacts'.tr,
                    style: StyleThemeData.size12Weight400(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    controller.syncContactModel.value?.lastSyncContacts?.tohhmmSpaceddMMyyyy ?? '',
                    style: StyleThemeData.size14Weight600(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget _buildSearchSection() {
    return Container(
      margin: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.search,
                color: appTheme.appColor,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'search_contacts'.tr,
                style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: appTheme.greyColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  onChanged: controller.onSearch,
                  onFieldSubmitted: (value) => controller.fetchSyncContacts(search: value),
                  style: StyleThemeData.size16Weight400(color: appTheme.blackColor),
                  cursorColor: appTheme.appColor,
                  decoration: InputDecoration(
                    hintText: 'search'.tr,
                    hintStyle: StyleThemeData.size14Weight400(
                      color: appTheme.greyColor.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(16.w),
                      child: Icon(
                        Icons.search,
                        color: appTheme.greyColor.withOpacity(0.5),
                        size: 20.w,
                      ),
                    ),
                    suffixIcon: controller.isLoading.isTrue
                        ? Container(
                            padding: EdgeInsets.all(16.w),
                            child: SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                color: appTheme.appColor,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : controller.searchValue.value.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.searchValue.value = '';
                                  controller.fetchSyncContacts();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: appTheme.greyColor.withOpacity(0.5),
                                  size: 20.w,
                                ),
                              )
                            : null,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildContactList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
              child: Row(
                children: [
                  Icon(
                    Icons.contact_page_outlined,
                    color: appTheme.appColor,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'new_contact'.tr,
                    style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
                  ),
                  const Spacer(),
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: appTheme.appColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(controller.syncContactModel.value?.contacts ?? []).length}',
                        style: StyleThemeData.size12Weight600(
                          color: appTheme.appColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contact list
            Obx(
              () => controller.isLoading.isTrue
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: appTheme.appColor,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'loading_contacts'.tr,
                            style: StyleThemeData.size14Weight400(
                              color: appTheme.greyColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : (controller.syncContactModel.value?.contacts ?? []).isNotEmpty
                      ? Column(
                          children: (controller.syncContactModel.value?.contacts ?? []).map((e) {
                            return _buildContactItem(e);
                          }).toList(),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  color: appTheme.appColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Icon(
                                  Icons.contacts_outlined,
                                  size: 40.w,
                                  color: appTheme.appColor.withOpacity(0.5),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'no_synced_contacts'.tr,
                                style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'sync_your_contacts_first'.tr,
                                style: StyleThemeData.size14Weight400(
                                  color: appTheme.greyColor.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(SyncContact e) {
    bool hasAccount = e.userContact != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (hasAccount) {
            Get.toNamed(
              Routes.MAKE_FRIENDS,
              arguments: MakeFriendsParameter(
                id: e.userContact!.id!,
                contact: e.userContact,
                type: MakeFriendsType.friend,
              ),
            );
          } else {
            final androidUrl = Get.find<ProfileController>().systemSetting.value?.androidUrl ?? '';
            final iosUrl = Get.find<ProfileController>().systemSetting.value?.iosUlr ?? '';
            final smsContent = 'Link tải app Nhà Táo:\n'
                'iOS: $iosUrl'
                '\n'
                'Android: $androidUrl';
            makeSmsContent(e.phone ?? '', smsContent);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            children: [
              // Avatar with status indicator
              Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: e.userContact?.avatar ?? '',
                    size: 48.w,
                    noImage: false,
                    name: hasAccount ? (e.userContact?.name ?? '') : (e.contactName ?? ''),
                    isShowNameAvatar: true,
                  ),
                  if (hasAccount && e.userContact?.isChecked == true)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.circle,
                          size: 8.w,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 16.w),

              // Contact info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.contactName ?? '',
                      style: StyleThemeData.size16Weight500(color: appTheme.blackColor),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      e.userContact?.phone ?? e.phone ?? '',
                      style: StyleThemeData.size12Weight400(
                        color: appTheme.greyColor.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: hasAccount ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          hasAccount
                              ? (e.userContact?.lastOnline?.timeAgo ?? 'registered_user'.tr)
                              : 'this_user_has_not_registered_an_account'.tr,
                          style: StyleThemeData.size10Weight400(
                            color: hasAccount ? Colors.green : appTheme.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: hasAccount ? appTheme.appColor.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hasAccount ? 'connect'.tr : 'invite'.tr,
                  style: StyleThemeData.size10Weight600(
                    color: hasAccount ? appTheme.appColor : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
