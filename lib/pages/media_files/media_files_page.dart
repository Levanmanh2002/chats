import 'package:chats/main.dart';
import 'package:chats/pages/media_files/media_files_controller.dart';
import 'package:chats/pages/media_files/view/files_view.dart';
import 'package:chats/pages/media_files/view/images_view.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaFilesPage extends GetWidget<MediaFilesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'images_files'.tr,
        backgroundColor: appTheme.appColor,
        colorIcon: appTheme.whiteColor,
        colorTitle: appTheme.whiteColor,
      ),
      body: Column(
        children: [
          TabBar(
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
            tabs: [Tab(text: 'image'.tr), Tab(text: 'file'.tr)],
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                ImagesView(),
                FilesView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
