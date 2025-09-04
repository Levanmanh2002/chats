import 'package:chats/main.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_controller.dart';
import 'package:chats/pages/sent_request_contact/view/received_friend_view.dart';
import 'package:chats/pages/sent_request_contact/view/sent_friend_view.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SentRequestContactPage extends GetWidget<SentRequestContactController> {
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
                    ReceivedFriendView(),
                    SentFriendView(),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        'friend_request'.tr,
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
                Icons.people_outline,
                color: Colors.white,
                size: 28.w,
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              'friend_requests_management'.tr,
              style: StyleThemeData.size20Weight700(color: Colors.white),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            Text(
              'manage_incoming_outgoing_requests'.tr,
              style: StyleThemeData.size14Weight400(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
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
              icon: Icons.inbox_outlined,
              label: 'received'.tr,
              value: '${controller.friendRequest.value?.data?.length ?? 0}',
              color: Colors.orange,
            ),
            SizedBox(width: 12.w),
            _buildStatCard(
              icon: Icons.send_outlined,
              label: 'sent'.tr,
              value: '${controller.friendSendt.value?.data?.length ?? 0}',
              color: Colors.blue,
            ),
            SizedBox(width: 12.w),
            _buildStatCard(
              icon: Icons.pending_outlined,
              label: 'pending'.tr,
              value:
                  '${(controller.friendRequest.value?.data?.length ?? 0) + (controller.friendSendt.value?.data?.length ?? 0)}',
              color: Colors.white,
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
      child: Obx(
        () => TabBar(
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
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 16.w,
                  ),
                  SizedBox(width: 6.w),
                  Text('received'.tr),
                  SizedBox(width: 4.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${controller.friendRequest.value?.data?.length ?? 0}',
                      style: StyleThemeData.size10Weight600(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send_outlined,
                    size: 16.w,
                  ),
                  SizedBox(width: 6.w),
                  Text('sent'.tr),
                  SizedBox(width: 4.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${controller.friendSendt.value?.data?.length ?? 0}',
                      style: StyleThemeData.size10Weight600(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
