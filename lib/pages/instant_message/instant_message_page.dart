import 'package:chats/main.dart';
import 'package:chats/pages/instant_message/instant_message_controller.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstantMessagePage extends GetWidget<InstantMessageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildCustomAppBar(),
      body: Obx(
        () => controller.isLoading.isTrue
            ? _buildLoadingState()
            : ListLoader(
                onRefresh: controller.fetchQuickMessage,
                forceScrollable: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),

                      // Header section
                      _buildHeaderSection(),

                      SizedBox(height: 24.h),

                      // Messages list or empty state
                      controller.quickMessages.isNotEmpty ? _buildMessagesList() : _buildEmptyState(),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
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
        'manage_instant_messages'.tr,
        style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
      ),
      centerTitle: true,
      actions: [
        Container(
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
              Icons.add,
              color: appTheme.appColor,
              size: 20.w,
            ),
            onPressed: () => Get.toNamed(
              Routes.UPSERT_INSTANT_MESS,
              arguments: UpsertInstantMessParameter(
                type: UpsertInstantMessType.create,
                chatId: controller.parameter.chatId,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: appTheme.appColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 16.h),
          Text(
            'loading_messages'.tr,
            style: StyleThemeData.size14Weight400(
              color: appTheme.greyColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.appColor.withOpacity(0.1),
            appTheme.appColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: appTheme.appColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Icon với glow effect
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: appTheme.appColor.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.flash_on,
              color: appTheme.appColor,
              size: 30.w,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'instant_messages_title'.tr,
            style: StyleThemeData.size18Weight700(color: appTheme.blackColor),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 6.h),

          Text(
            'instant_messages_desc'.tr,
            style: StyleThemeData.size12Weight400(
              color: appTheme.greyColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16.h),

          // Stats row
          Obx(() => _buildStatsRow()),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.speed,
          label: 'quick_replies'.tr,
          value: '${controller.quickMessages.length}',
        ),
        Container(
          width: 1,
          height: 30.h,
          color: appTheme.greyColor.withOpacity(0.2),
        ),
        _buildStatItem(
          icon: Icons.access_time,
          label: 'time_saved'.tr,
          value: 'saved_time'.tr,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: appTheme.appColor,
          size: 16.w,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
        ),
        Text(
          label,
          style: StyleThemeData.size10Weight400(
            color: appTheme.greyColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          ...controller.quickMessages.asMap().entries.map((entry) {
            final index = entry.key;
            final message = entry.value;
            return _buildMessageCard(message, index);
          }),
          SizedBox(height: 100.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildMessageCard(dynamic message, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(
            Routes.UPSERT_INSTANT_MESS,
            arguments: UpsertInstantMessParameter(
              type: UpsertInstantMessType.update,
              chatId: controller.parameter.chatId,
              quickMessage: message,
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header với shortkey và index
                Row(
                  children: [
                    // Index badge
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: appTheme.appColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: StyleThemeData.size12Weight600(
                            color: appTheme.appColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Shortkey
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.appColor.withOpacity(0.1),
                          border: Border.all(
                            color: appTheme.appColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt,
                              size: 14.w,
                              color: appTheme.appColor,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '/${message.shortKey}',
                              style: StyleThemeData.size12Weight500(
                                color: appTheme.appColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Edit indicator
                    Icon(
                      Icons.edit_outlined,
                      size: 16.w,
                      color: appTheme.greyColor.withOpacity(0.5),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Message content
                Text(
                  message.content ?? '',
                  style: StyleThemeData.size14Weight400(
                    color: appTheme.blackColor.withOpacity(0.8),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12.h),

                // Footer với usage info
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12.w,
                      color: appTheme.greyColor.withOpacity(0.5),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'tap_to_edit'.tr,
                      style: StyleThemeData.size10Weight400(
                        color: appTheme.greyColor.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'active'.tr,
                        style: StyleThemeData.size10Weight500(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: appTheme.appColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 60.w,
                color: appTheme.appColor.withOpacity(0.5),
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              'no_instant_messages'.tr,
              style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),

            Text(
              'no_instant_messages_desc'.tr,
              style: StyleThemeData.size14Weight400(
                color: appTheme.greyColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

            // Create first message button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    appTheme.appColor,
                    appTheme.appColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.appColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.toNamed(
                    Routes.UPSERT_INSTANT_MESS,
                    arguments: UpsertInstantMessParameter(
                      type: UpsertInstantMessType.create,
                      chatId: controller.parameter.chatId,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'create_first_message'.tr,
                          style: StyleThemeData.size14Weight600(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Obx(
      () => controller.quickMessages.isNotEmpty
          ? Container(
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
                onPressed: () => Get.toNamed(
                  Routes.UPSERT_INSTANT_MESS,
                  arguments: UpsertInstantMessParameter(
                    type: UpsertInstantMessType.create,
                    chatId: controller.parameter.chatId,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28.w,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
