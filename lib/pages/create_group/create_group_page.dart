import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/pages/create_group/create_group_controller.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupPage extends GetWidget<CreateGroupController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildCustomAppBar(),
        body: ListLoader(
          onRefresh: controller.getContacts,
          onLoad: () => controller.getContacts(isRefresh: false),
          hasNext: controller.contactModel.value?.hasNext ?? false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header section
                _buildHeaderSection(),

                // Group name input (conditional)
                if (controller.parameter.type == CreateGroupType.createGroup) _buildGroupNameSection(),

                // Search section
                _buildSearchSection(),

                // Contact list
                _buildContactList(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildSelectedContactsBar(),
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
      title: Column(
        children: [
          Text(
            controller.parameter.type == CreateGroupType.createGroup ? 'new_group'.tr : 'add_to_group'.tr,
            style: StyleThemeData.size18Weight600(color: Colors.white),
          ),
          Obx(() => Text(
                'selected_field'.trParams({'field': controller.selectedContacts.length.toString()}),
                style: StyleThemeData.size12Weight400(
                  color: Colors.white.withOpacity(0.8),
                ),
              )),
        ],
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
            // Icon với gradient background
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
                controller.parameter.type == CreateGroupType.createGroup ? Icons.group_add : Icons.person_add,
                color: Colors.white,
                size: 28.w,
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              controller.parameter.type == CreateGroupType.createGroup
                  ? 'create_new_group'.tr
                  : 'add_members_to_group'.tr,
              style: StyleThemeData.size20Weight700(color: Colors.white),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            Text(
              controller.parameter.type == CreateGroupType.createGroup
                  ? 'select_friends_for_group'.tr
                  : 'choose_members_to_add'.tr,
              style: StyleThemeData.size14Weight400(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupNameSection() {
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
                Icons.edit_outlined,
                color: appTheme.appColor,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'group_name'.tr,
                style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
              ),
            ],
          ),
          SizedBox(height: 12.h),
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
              controller: controller.groupNameController,
              inputFormatters: FormatterUtil.createGroupFormatter,
              onChanged: (value) {
                controller.createGroupValue.value = value;
              },
              cursorColor: appTheme.appColor,
              style: StyleThemeData.size16Weight400(color: appTheme.blackColor),
              decoration: InputDecoration(
                hintText: 'set_group_name'.tr,
                hintStyle: StyleThemeData.size14Weight400(
                  color: appTheme.greyColor.withOpacity(0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
                  controller: controller.searchController,
                  onFieldSubmitted: (value) {
                    controller.getContacts(search: value);
                  },
                  onChanged: (value) {
                    controller.chatValue.value = value;
                  },
                  style: StyleThemeData.size16Weight400(color: appTheme.blackColor),
                  cursorColor: appTheme.appColor,
                  decoration: InputDecoration(
                    hintText: 'search_by_name_or_phone_number'.tr,
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
                        : controller.chatValue.value.isNotEmpty
                            ? IconButton(
                                onPressed: controller.clearSearch,
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
      margin: EdgeInsets.only(top: 20.h),
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
        child: Obx(
          () => (controller.contactModel.value?.data ?? []).isNotEmpty
              ? Column(
                  children: (controller.contactModel.value?.data ?? []).map((e) {
                    return _buildContactItem(e);
                  }).toList(),
                )
              // ? ListView.builder(
              //     padding: EdgeInsets.symmetric(vertical: 16.h),
              //     itemCount: (controller.contactModel.value?.data ?? []).length,
              //     itemBuilder: (context, index) {
              //       final contact = (controller.contactModel.value?.data ?? [])[index];
              //       return _buildContactItem(contact);
              //     },
              //   )
              : const Center(child: NoDataWidget()),
        ),
      ),
    );
  }

  Widget _buildContactItem(ContactModel e) {
    return Obx(
      () => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.canDeleteContact(e.friend!.id!) ? () => controller.selectContact(e) : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                // Avatar với online status
                Stack(
                  children: [
                    CustomImageWidget(
                      imageUrl: e.friend?.avatar ?? '',
                      size: 44.w,
                      noImage: false,
                      name: e.friend?.name ?? '',
                      isShowNameAvatar: true,
                    ),
                    if (e.friend?.isChecked == true)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14.w,
                          height: 14.w,
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

                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.friend?.name ?? '',
                        style: StyleThemeData.size16Weight500(color: appTheme.blackColor),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        e.friend?.lastOnline?.timeAgo ?? '',
                        style: StyleThemeData.size12Weight400(
                          color: appTheme.greyColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: controller.selectedContacts.any((contact) => contact.id == e.id)
                          ? appTheme.appColor
                          : appTheme.greyColor.withOpacity(0.3),
                      width: 2,
                    ),
                    color: controller.selectedContacts.any((contact) => contact.id == e.id)
                        ? appTheme.appColor
                        : Colors.transparent,
                  ),
                  child: controller.selectedContacts.any((contact) => contact.id == e.id)
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.w,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContactsBar() {
    return Obx(
      () => controller.selectedContacts.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Selected contacts preview
                    Container(
                      height: 60.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.selectedContacts.length,
                              itemBuilder: (context, index) {
                                final contact = controller.selectedContacts[index];
                                return _buildSelectedContactItem(contact);
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          _buildActionButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildSelectedContactItem(ContactModel e) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: Stack(
        children: [
          CustomImageWidget(
            imageUrl: e.friend?.avatar ?? '',
            size: 44.w,
            noImage: false,
            showBoder: true,
            colorBoder: appTheme.appColor.withOpacity(0.3),
            sizeBorder: 2,
          ),
          if (controller.canDeleteContact(e.friend!.id!))
            Positioned(
              top: -2,
              right: -2,
              child: GestureDetector(
                onTap: () => controller.removeContact(e),
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appTheme.errorColor,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 12.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    bool canProceed =
        controller.parameter.type == CreateGroupType.createGroup ? controller.createGroupValue.value.isNotEmpty : true;

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        gradient: canProceed
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appTheme.appColor,
                  appTheme.appColor.withOpacity(0.8),
                ],
              )
            : null,
        color: canProceed ? null : appTheme.greyColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: canProceed
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
          onTap: canProceed
              ? (controller.parameter.type == CreateGroupType.createGroup
                  ? controller.createGroup
                  : controller.addUserToGroup)
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            child: Center(
              child: Icon(
                Icons.arrow_forward,
                color: canProceed ? Colors.white : appTheme.greyColor.withOpacity(0.5),
                size: 20.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
