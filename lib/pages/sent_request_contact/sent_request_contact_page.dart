import 'package:chats/main.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_controller.dart';
import 'package:chats/pages/sent_request_contact/view/received_friend_view.dart';
import 'package:chats/pages/sent_request_contact/view/sent_friend_view.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SentRequestContactPage extends GetWidget<SentRequestContactController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'friend_request'.tr),
      body: Column(
        children: [
          Obx(
            () => TabBar(
              controller: controller.tabController,
              indicatorColor: appTheme.blackColor,
              dividerColor: appTheme.allSidesColor,
              labelColor: appTheme.blackColor,
              unselectedLabelColor: appTheme.grayColor,
              labelStyle: StyleThemeData.size14Weight600(),
              unselectedLabelStyle: StyleThemeData.size14Weight600(color: appTheme.grayColor),
              indicator: BoxDecoration(
                border: Border(bottom: BorderSide(color: appTheme.blackColor, width: 1.w)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  text: 'received_field'.trParams({'field': '${controller.friendRequest.value?.data?.length ?? '0'}'}),
                ),
                Tab(text: 'sent_field'.trParams({'field': '${controller.friendSendt.value?.data?.length ?? '0'}'})),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                ReceivedFriendView(),
                SentFriendView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
