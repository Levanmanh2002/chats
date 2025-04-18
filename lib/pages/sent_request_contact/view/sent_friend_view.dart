import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/contact/friend_request.dart';
import 'package:chats/pages/make_friends/make_friends_parameter.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SentFriendView extends GetView<SentRequestContactController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingSent.isTrue
          ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
          : ListLoader(
              onRefresh: controller.onSend,
              onLoad: () => controller.onSend(isRefresh: false),
              hasNext: controller.friendSendt.value?.hasNext ?? false,
              child: Obx(
                () {
                  final groupedData = (controller.friendSendt.value?.data ?? []).groupByMonth();

                  return groupedData.isNotEmpty
                      ? Column(
                          children: groupedData.entries.map(
                            (entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: padding(horizontal: 16, vertical: 8),
                                    child: Text(entry.key, style: StyleThemeData.size12Weight600()),
                                  ),
                                  ...entry.value.map((e) => _buildSentFriendItem(e)),
                                ],
                              );
                            },
                          ).toList(),
                        )
                      : const Center(child: NoDataWidget());
                },
              ),
            ),
    );
  }

  Widget _buildSentFriendItem(FriendRequest e) {
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
        child: Row(
          children: [
            Stack(
              children: [
                CustomImageWidget(
                  imageUrl: e.receiver?.avatar ?? '',
                  size: 41,
                  colorBoder: appTheme.allSidesColor,
                  showBoder: true,
                ),
                if (e.receiver?.isChecked == true)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: padding(all: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.greenColor,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 10.w,
                        color: appTheme.whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Column(
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
                        e.receiver?.phone?.formatPhoneCode ?? '',
                        style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => controller.removeFriend(e.id!),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: padding(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: appTheme.allSidesColor,
                ),
                child: Text('revoke'.tr, style: StyleThemeData.size12Weight600()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
