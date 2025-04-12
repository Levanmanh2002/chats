import 'package:chats/main.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_boder_button_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusFriendWebView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.messageModel.value?.isFriend == false &&
              controller.messageModel.value?.isSenderRequestFriend == false &&
              controller.messageModel.value?.isReceiverIdRequestFriend == false)
          ? InkWell(
              onTap: controller.addFriend,
              child: Container(
                padding: padding(all: 12),
                color: appTheme.whiteColor,
                alignment: Alignment.center,
                child: controller.isLoadingAddFriend.isTrue
                    ? Center(
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(color: appTheme.appColor),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageAssetCustom(imagePath: IconsAssets.addUserImage, size: 24.w),
                          SizedBox(width: 8.w),
                          Text('make_friends'.tr, style: StyleThemeData.size14Weight400()),
                        ],
                      ),
              ),
            )
          : (controller.messageModel.value?.isSenderRequestFriend == true)
              ? InkWell(
                  onTap: controller.removeFriend,
                  child: Container(
                    padding: padding(all: 12),
                    color: appTheme.whiteColor,
                    alignment: Alignment.center,
                    child: controller.isLoadingRemoveFriend.isTrue
                        ? Center(
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(color: appTheme.appColor),
                            ),
                          )
                        : Text('cancel_request'.tr, style: StyleThemeData.size14Weight400(color: appTheme.redColor)),
                  ),
                )
              : (controller.messageModel.value?.isReceiverIdRequestFriend == true)
                  ? Container(
                      padding: padding(all: 12),
                      color: appTheme.whiteColor,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('friend_request'.tr, style: StyleThemeData.size14Weight400()),
                          SizedBox(width: 24.w),
                          Flexible(
                            child: CustomButton(
                              buttonText: 'accept'.tr,
                              paddings: padding(vertical: 8),
                              isLoading: controller.isLoadingAcceptFriend.isTrue,
                              onPressed: controller.acceptFriendRequest,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: CustomBorderButtonWidget(
                              buttonText: 'reject'.tr,
                              paddings: padding(vertical: 8),
                              isLoading: controller.isLoadingCancelFriend.isTrue,
                              onPressed: controller.cancelFriendRequest,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
    );
  }
}
