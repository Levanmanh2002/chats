import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/chats/group_message_web/group_message_page.dart';
import 'package:chats/pages/chats/message_web/message_page.dart';
import 'package:chats/pages/chats/view/chat_all_view.dart';
import 'package:chats/utils/gif_utils.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // appBar: SearchAppbar(
        //   isShowBack: true,
        //   isOffSearch: true,
        //   leftTitle: 16,
        //   backgroundColor: appTheme.appColor,
        //   title: 'chat'.tr,
        //   // onSubmitted: controller.onSearchChat,
        //   actions: [],
        //   // action: Padding(
        //   //   padding: padding(vertical: 16, right: 16),
        //   //   child: CustomPopup(
        //   //     content: Column(
        //   //       mainAxisSize: MainAxisSize.min,
        //   //       children: [
        //   //         InkWell(
        //   //           onTap: () {
        //   //             Get.back();
        //   //             Get.toNamed(Routes.ADD_FRIEND);
        //   //           },
        //   //           child: Row(
        //   //             mainAxisSize: MainAxisSize.min,
        //   //             children: [
        //   //               ImageAssetCustom(imagePath: IconsAssets.userPlusRoundedIcon, size: 24.w),
        //   //               SizedBox(width: 12.w),
        //   //               Text('add_friend'.tr, style: StyleThemeData.size14Weight400()),
        //   //               SizedBox(width: 24.w),
        //   //             ],
        //   //           ),
        //   //         ),
        //   //         SizedBox(height: 16.h),
        //   //         InkWell(
        //   //           onTap: () {
        //   //             Get.back();
        //   //             Get.toNamed(
        //   //               Routes.CREATE_GROUP,
        //   //               arguments: CreateGroupParameter(type: CreateGroupType.createGroup),
        //   //             );
        //   //           },
        //   //           child: Row(
        //   //             mainAxisSize: MainAxisSize.min,
        //   //             children: [
        //   //               ImageAssetCustom(imagePath: IconsAssets.addGroupIcon, size: 24.w),
        //   //               SizedBox(width: 12.w),
        //   //               Text('create_group'.tr, style: StyleThemeData.size14Weight400()),
        //   //               SizedBox(width: 24.w),
        //   //             ],
        //   //           ),
        //   //         ),
        //   //       ],
        //   //     ),
        //   //     child: const ImageAssetCustom(imagePath: IconsAssets.addIcon),
        //   // ),
        //   // ),
        // ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: controller.isLoading.isTrue
                    ? Center(child: Image.asset(GifUtils.noDataImageGif))
                    : Row(
                        children: [
                          Flexible(flex: 3, child: ChatAllView()),
                          Flexible(
                            flex: 8,
                            child: controller.messageModel.value != null
                                ? controller.isGroup.isTrue
                                    ? GroupMessageWebPage()
                                    : MessageWebPage()
                                : const Center(child: NoDataWidget()),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
