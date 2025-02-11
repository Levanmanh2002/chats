import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/contact/friend_request.dart';
import 'package:chats/pages/make_friends/make_friends_parameter.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceivedFriendView extends GetView<SentRequestContactController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingReceived.isTrue
          ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
          : ListLoader(
              onRefresh: controller.onReceived,
              onLoad: () => controller.onReceived(isRefresh: false),
              hasNext: controller.friendRequest.value?.hasNext ?? false,
              child: Obx(
                () {
                  final groupedData = (controller.friendRequest.value?.data ?? []).groupByMonth();

                  return groupedData.isNotEmpty
                      ? Column(
                          children: groupedData.entries.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: padding(horizontal: 16, vertical: 8),
                                  child: Text(entry.key, style: StyleThemeData.size12Weight600()),
                                ),
                                ...entry.value.map((e) => _buildReceivedFriendItem(e)),
                              ],
                            );
                          }).toList(),
                        )
                      : const Center(child: NoDataWidget());
                },
              ),
            ),
    );
  }

  Widget _buildReceivedFriendItem(FriendRequest e) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.MAKE_FRIENDS,
        arguments: MakeFriendsParameter(
          id: e.id!,
          contact: e.receiver,
          type: MakeFriendsType.friend,
        ),
      ),
      child: Padding(
        padding: padding(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                CustomImageWidget(
                  imageUrl: e.receiver?.avatar ?? '',
                  size: 41,
                  colorBoder: appTheme.allSidesColor,
                  showBoder: true,
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.receiver?.name ?? '', style: StyleThemeData.size14Weight600()),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          e.createdAt?.timeAgo ?? '',
                          style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                        ),
                        Text(' • ', style: StyleThemeData.size10Weight400(color: appTheme.grayColor)),
                        Text(
                          e.receiver?.phone ?? '',
                          style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Obx(
              () => Row(
                children: [
                  SizedBox(width: 49.w),
                  Flexible(
                    child: CustomButton(
                      buttonText: 'reject'.tr,
                      color: appTheme.allSidesColor,
                      textColor: appTheme.blackColor,
                      colorLoading: appTheme.blackColor,
                      width: 128.w,
                      isLoading: controller.isLoadingCancel.isTrue,
                      onPressed: () => controller.cancelFriendRequest(e.id!),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    child: CustomButton(
                      buttonText: 'accept'.tr,
                      color: appTheme.blueFFColor,
                      textColor: appTheme.appColor,
                      colorLoading: appTheme.appColor,
                      width: 128.w,
                      isLoading: controller.isLoadingAccept.isTrue,
                      onPressed: () => controller.acceptFriendRequest(e.id!),
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
