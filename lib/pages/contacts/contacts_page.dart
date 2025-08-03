import 'package:chats/main.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/contacts/view/contacts_view.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsPage extends GetWidget<ContactsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildModernAppBar(),
      body: Column(
        children: [
          _buildModernTabBar(),
          _buildFriendRequestsSection(),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                ContactsView(),
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.h),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: padding(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'contacts'.tr,
                    style: StyleThemeData.size24Weight700(color: appTheme.whiteColor),
                  ),
                ),
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: appTheme.whiteColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.add,
                      color: appTheme.whiteColor,
                      size: 20.w,
                    ),
                    color: appTheme.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'add_friend',
                        child: Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF667EEA).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.person_add,
                                size: 16.w,
                                color: const Color(0xFF667EEA),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'add_friend'.tr,
                              style: StyleThemeData.size14Weight500(),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'create_group',
                        child: Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: appTheme.greenColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.group_add,
                                size: 16.w,
                                color: appTheme.greenColor,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'create_group'.tr,
                              style: StyleThemeData.size14Weight500(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'add_friend') {
                        Get.toNamed(Routes.ADD_FRIEND);
                      } else if (value == 'create_group') {
                        Get.toNamed(
                          Routes.CREATE_GROUP,
                          arguments: CreateGroupParameter(type: CreateGroupType.createGroup),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTabBar() {
    return Container(
      color: appTheme.whiteColor,
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Padding(
            padding: padding(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: controller.tabController,
                indicator: BoxDecoration(
                  color: appTheme.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.blackColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorPadding: padding(all: 2),
                dividerColor: Colors.transparent,
                labelColor: const Color(0xFF667EEA),
                unselectedLabelColor: const Color(0xFF8E8E93),
                labelStyle: StyleThemeData.size14Weight600(),
                unselectedLabelStyle: StyleThemeData.size14Weight500(),
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (value) {
                  if (value == 1) {
                    Get.toNamed(Routes.SYNC_CONTACT_DETAILS);
                    controller.tabController.index = 0;
                  }
                },
                tabs: [
                  Tab(
                    text: 'friends'.tr + ' (${controller.contactModel.value?.data?.length ?? '0'})'.tr,
                  ),
                  Tab(text: 'contacts'.tr),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildFriendRequestsSection() {
    return Container(
      color: appTheme.whiteColor,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.toNamed(Routes.SENT_REQUEST_CONTACT),
              child: Padding(
                padding: padding(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.person_add,
                              color: appTheme.whiteColor,
                              size: 22.w,
                            ),
                          ),
                          Obx(() {
                            if ((controller.friendRequest.value?.data ?? []).isNotEmpty) {
                              return Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: appTheme.errorColor,
                                    border: Border.all(
                                      color: appTheme.whiteColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'friend_requests'.tr,
                            style: StyleThemeData.size15Weight600(
                              color: const Color(0xFF1A1D29),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'manage_pending_requests'.tr,
                            style: StyleThemeData.size13Weight400(
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: const Color(0xFF8E8E93),
                      size: 20.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 8.h,
            color: const Color(0xFFF8F9FA),
          ),
        ],
      ),
    );
  }
}
