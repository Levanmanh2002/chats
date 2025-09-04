import 'package:chats/main.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/contacts/view/contacts_view.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/popup/popup.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsPage extends GetWidget<ContactsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildCustomAppBar(),
      body: Column(
        children: [
          // Header section
          _buildHeaderSection(),

          // Tab bar
          _buildTabBar(),

          // Friend requests section
          _buildFriendRequestsSection(),

          // Content
          Expanded(
            child: Container(
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
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    ContactsView(),
                    const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: appTheme.appColor,
      elevation: 0,
      title: Text(
        'contacts'.tr,
        style: StyleThemeData.size20Weight700(color: Colors.white),
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildMoreOptionsButton(),
        ),
      ],
    );
  }

  Widget _buildMoreOptionsButton() {
    return CustomPopup(
      content: Container(
        padding: EdgeInsets.all(8.w),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPopupMenuItem(
              icon: Icons.person_add_outlined,
              title: 'add_friend'.tr,
              onTap: () {
                Get.back();
                Get.toNamed(Routes.ADD_FRIEND);
              },
            ),
            SizedBox(height: 8.h),
            _buildPopupMenuItem(
              icon: Icons.group_add_outlined,
              title: 'create_group'.tr,
              onTap: () {
                Get.back();
                Get.toNamed(
                  Routes.CREATE_GROUP,
                  arguments: CreateGroupParameter(type: CreateGroupType.createGroup),
                );
              },
            ),
          ],
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
          size: 20.w,
        ),
        onPressed: null,
      ),
    );
  }

  Widget _buildPopupMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20.w,
                color: appTheme.appColor,
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: StyleThemeData.size14Weight500(color: appTheme.blackColor),
              ),
              SizedBox(width: 24.w),
            ],
          ),
        ),
      ),
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
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'my_contacts'.tr,
              style: StyleThemeData.size24Weight700(color: Colors.white),
            ),

            SizedBox(height: 8.h),

            Text(
              'manage_your_connections'.tr,
              style: StyleThemeData.size14Weight400(
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            SizedBox(height: 16.h),

            // Stats row
            _buildStatsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Obx(() => Row(
          children: [
            _buildStatCard(
              icon: Icons.people_outline,
              label: 'total_friends'.tr,
              value: '${controller.contactModel.value?.data?.length ?? 0}',
              color: Colors.white,
            ),
            SizedBox(width: 12.w),
            _buildStatCard(
              icon: Icons.person_add_outlined,
              label: 'pending_requests'.tr,
              value: '${(controller.friendRequest.value?.data ?? []).length}',
              color: Colors.orange,
            ),
            SizedBox(width: 12.w),
            _buildStatCard(
              icon: Icons.online_prediction,
              label: 'online_now'.tr,
              value:
                  '${(controller.contactModel.value?.data ?? []).where((contact) => contact.friend?.isChecked == true).length}',
              color: Colors.green,
            ),
          ],
        ));
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 18.w,
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: StyleThemeData.size16Weight700(color: Colors.white),
            ),
            Text(
              label,
              style: StyleThemeData.size10Weight400(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller.tabController,
        indicatorColor: appTheme.appColor,
        dividerColor: appTheme.greyColor.withOpacity(0.2),
        labelColor: appTheme.appColor,
        unselectedLabelColor: appTheme.greyColor,
        labelStyle: StyleThemeData.size14Weight600(),
        unselectedLabelStyle: StyleThemeData.size14Weight600(),
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: appTheme.appColor,
              width: 2.w,
            ),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        onTap: (value) {
          if (value == 1) {
            Get.toNamed(Routes.SYNC_CONTACT_DETAILS);
            controller.tabController.index = 0;
          }
        },
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('friends'.tr),
                SizedBox(width: 4.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: appTheme.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => Text(
                        '${controller.contactModel.value?.data?.length ?? 0}',
                        style: StyleThemeData.size10Weight600(
                          color: appTheme.appColor,
                        ),
                      )),
                ),
              ],
            ),
          ),
          Tab(text: 'contacts'.tr),
        ],
      ),
    );
  }

  Widget _buildFriendRequestsSection() {
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(Routes.SENT_REQUEST_CONTACT),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
                // Icon với notification dot
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: appTheme.appColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person_add_outlined,
                          color: appTheme.appColor,
                          size: 20.w,
                        ),
                      ),
                    ),
                    Obx(() {
                      if ((controller.friendRequest.value?.data ?? []).isNotEmpty) {
                        return Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appTheme.errorColor,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${(controller.friendRequest.value?.data ?? []).length}',
                                style: StyleThemeData.size8Weight600(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                  ],
                ),

                SizedBox(width: 16.w),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'friend_requests'.tr,
                        style: StyleThemeData.size16Weight500(color: appTheme.blackColor),
                      ),
                      SizedBox(height: 2.h),
                      Obx(() => Text(
                            (controller.friendRequest.value?.data ?? []).isNotEmpty
                                ? 'you_have_pending_requests'.tr
                                : 'no_pending_requests'.tr,
                            style: StyleThemeData.size12Weight400(
                              color: appTheme.greyColor.withOpacity(0.7),
                            ),
                          )),
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

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.appColor,
            appTheme.appColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appTheme.appColor.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_FRIEND),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.person_add,
          color: Colors.white,
          size: 24.w,
        ),
      ),
    );
  }
}
