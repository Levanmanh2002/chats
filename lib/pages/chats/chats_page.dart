import 'package:chats/main.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/chats/group_message_web/group_message_page.dart';
import 'package:chats/pages/chats/message_web/message_page.dart';
import 'package:chats/pages/chats/view/chat_all_view.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/gif_utils.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: appTheme.whiteColor,
        //   actions: [
        //     // IconButton(
        //     //   onPressed: () async {
        //     //     openMicSettings();
        //     //   },
        //     //   icon: const Icon(Icons.mic, color: Colors.white, size: 24),
        //     // )
        //   ],
        // ),
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
                          VerticalDivider(thickness: 1, width: 0.5, color: appTheme.background),
                          Flexible(
                            flex: 8,
                            child: Obx(
                              () => controller.callData.value != null
                                  ? Container(
                                      color: appTheme.appColor,
                                      child: _buildCallWidget(),
                                    )
                                  : controller.messageModel.value != null
                                      ? controller.isGroup.isTrue
                                          ? GroupMessageWebPage()
                                          : MessageWebPage()
                                      : const Center(child: NoDataWidget()),
                            ),
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

  Widget _buildCallWidget() {
    return Center(
      child: Padding(
        padding: padding(all: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageAssetCustom(imagePath: ImagesAssets.logoTitileWhiteImage, size: 61.w),
            SizedBox(height: 40.h),
            CustomImageWidget(
              imageUrl: controller.callData.value?.userAvatar ?? '',
              size: 100,
              noImage: false,
              showBoder: true,
              colorBoder: appTheme.blueBFFColor,
              sizeBorder: 4,
              name: controller.callData.value?.userName ?? '',
              isShowNameAvatar: true,
            ),
            SizedBox(height: 24.h),
            Text(
              controller.callData.value?.userName ?? '',
              style: StyleThemeData.size16Weight600(color: appTheme.whiteColor),
            ),
            SizedBox(height: 36.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: controller.onDeclineCall,
                        icon: ImageAssetCustom(imagePath: IconsAssets.phoneBorderImage, size: 50.w),
                      ),
                      SizedBox(height: 4.h),
                      Text('reject'.tr, style: StyleThemeData.size14Weight600(color: appTheme.whiteColor)),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: controller.onAcceptCall,
                        icon: ImageAssetCustom(imagePath: IconsAssets.callSuccessIcon, size: 50.w),
                      ),
                      SizedBox(height: 4.h),
                      Text('accept_call'.tr, style: StyleThemeData.size14Weight600(color: appTheme.whiteColor)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
