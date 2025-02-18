import 'package:chats/main.dart';
import 'package:chats/pages/instant_message/instant_message_controller.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstantMessagePage extends GetWidget<InstantMessageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.allSidesColor,
      appBar: DefaultAppBar(
        title: 'manage_instant_messages'.tr,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(
              Routes.UPSERT_INSTANT_MESS,
              arguments: UpsertInstantMessParameter(
                type: UpsertInstantMessType.create,
                chatId: controller.parameter.chatId,
              ),
            ),
            icon: ImageAssetCustom(imagePath: IconsAssets.addIcon, color: appTheme.blackColor),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.isTrue
            ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
            : ListLoader(
                onRefresh: controller.fetchQuickMessage,
                forceScrollable: true,
                child: Padding(
                  padding: padding(top: 12),
                  child: controller.quickMessages.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            children: controller.quickMessages.map((e) {
                              return Padding(
                                padding: padding(bottom: 12),
                                child: InkWell(
                                  onTap: () => Get.toNamed(
                                    Routes.UPSERT_INSTANT_MESS,
                                    arguments: UpsertInstantMessParameter(
                                      type: UpsertInstantMessType.update,
                                      chatId: controller.parameter.chatId,
                                      quickMessage: e,
                                    ),
                                  ),
                                  child: Container(
                                    padding: padding(horizontal: 16, vertical: 12),
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: appTheme.whiteColor),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: padding(all: 4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: appTheme.allSidesColor,
                                          ),
                                          child: Text('/${e.shortKey}', style: StyleThemeData.size12Weight400()),
                                        ),
                                        Text(e.content ?? '', style: StyleThemeData.size14Weight400()),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : const Center(child: NoDataWidget(isSearch: false)),
                ),
              ),
      ),
    );
  }
}
