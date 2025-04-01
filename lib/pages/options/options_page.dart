import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/pages/media_files/media_files_parameter.dart';
import 'package:chats/pages/options/options_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/calendar_config_util.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/app_switch.dart';
import 'package:chats/widget/border_title_icon_widget.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:chats/widget/dialog/show_update_namegroup_dialog.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionsPage extends GetWidget<OptionsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'options'.tr,
        backgroundColor: appTheme.appColor,
        colorIcon: appTheme.whiteColor,
        colorTitle: appTheme.whiteColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: padding(horizontal: 16),
              child: Column(
                children: [
                  CustomImageWidget(
                    imageUrl: controller.parameter.user?.avatar ?? '',
                    size: 100,
                    showBoder: true,
                    colorBoder: appTheme.allSidesColor,
                    name: controller.parameter.user?.name ?? '',
                    isShowNameAvatar: true,
                  ),
                  SizedBox(height: 8.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: controller.parameter.user?.name ?? '',
                          style: StyleThemeData.size20Weight600(),
                        ),
                        WidgetSpan(
                          child: InkWell(
                            onTap: () {
                              showUpdateNameGroupDialog(
                                groupName: controller.parameter.user?.name ?? '',
                                title: 'change_quick_name'.tr,
                                content: 'enter_new_name'.tr,
                                onSubmit: controller.changePrimaryName,
                              );
                            },
                            borderRadius: BorderRadius.circular(1000),
                            child: Container(
                              margin: padding(left: 8.w),
                              padding: padding(all: 6),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.allSidesColor),
                              child: const ImageAssetCustom(imagePath: IconsAssets.pen2Icon),
                            ),
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    controller.parameter.user?.phone ?? '',
                    style: StyleThemeData.size14Weight400(),
                  ),
                  SizedBox(height: 24.h),
                  InkWell(
                    onTap: controller.onShowSearchMessage,
                    borderRadius: BorderRadius.circular(1000),
                    child: Container(
                      padding: padding(all: 8),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.allSidesColor),
                      child: ImageAssetCustom(
                        imagePath: IconsAssets.searchIcon,
                        color: appTheme.blackColor,
                        size: 24.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text('search_messages'.tr, style: StyleThemeData.size12Weight400()),
                  SizedBox(height: 24.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.downloadIcon,
                    title: 'export_pdf_file'.tr,
                    onTap: () async {
                      final ranges = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarConfigUtil.getDefaultConfig(context),
                        dialogSize: Size(Get.width, Get.width),
                        borderRadius: BorderRadius.circular(15),
                        value: [
                          controller.earningRangeDate.value.start,
                          controller.earningRangeDate.value.end,
                        ],
                        dialogBackgroundColor: appTheme.whiteColor,
                      );
                      if (ranges?.isEmpty ?? true) return;
                      controller.changeRangeDate(
                        DateTimeRange(
                          start: ranges![0]!,
                          end: ranges.length == 1 ? ranges[0]! : ranges[1]!,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => Container(
                      padding: padding(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1.w, color: appTheme.allSidesColor),
                      ),
                      child: Row(
                        children: [
                          ImageAssetCustom(
                            imagePath: IconsAssets.eyeSlashIcon,
                            size: 24.w,
                            color: appTheme.blackColor,
                          ),
                          SizedBox(width: 12.w),
                          Text('hide_message'.tr, style: StyleThemeData.size14Weight400()),
                          const Spacer(),
                          AppSwitch(
                            isActive: controller.isHideMessage.value,
                            onChange: controller.onHideMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // BorderTitleIconWidget(
                  //   icon: IconsAssets.chatRoundLineIcon,
                  //   title: 'manage_instant_messages'.tr,
                  //   onTap: () => Get.toNamed(
                  //     Routes.INSTANT_MESSAGE,
                  //     arguments: InstantMessageParameter(
                  //       chatId: controller.parameter.chatId,
                  //       type: InstantMessageType.chat,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 8.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.galleryBorderIcon,
                    title: 'images_files'.tr,
                    onTap: () => Get.toNamed(
                      Routes.MEDIA_FILES,
                      arguments: MediaFilesParameter(chatId: controller.parameter.chatId),
                    ),
                    child: Obx(
                      () => (controller.mediaImageModel.value != null &&
                              (controller.mediaImageModel.value?.items ?? []).isNotEmpty)
                          ? Container(
                              margin: padding(top: 12),
                              padding: padding(all: 10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.w, color: appTheme.allSidesColor),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...(controller.mediaImageModel.value?.items ?? []).take(5).map((e) {
                                      return Padding(
                                        padding: padding(right: 4),
                                        child: CustomImageWidget(
                                          imageUrl: e.fileUrl ?? '',
                                          size: 47,
                                          colorBoder: appTheme.allSidesColor,
                                          showBoder: true,
                                          borderRadius: 4,
                                        ),
                                      );
                                    }),
                                    if ((controller.mediaImageModel.value?.items ?? []).length > 5) ...[
                                      Container(
                                        padding: padding(all: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(width: 1.w, color: appTheme.allSidesColor),
                                          color: appTheme.blueFFColor,
                                        ),
                                        child: ImageAssetCustom(
                                          imagePath: IconsAssets.arrowRightWhiteIcon,
                                          color: appTheme.appColor,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              margin: padding(top: 12),
                              padding: padding(horizontal: 6, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: appTheme.allSidesColor,
                              ),
                              child: Row(
                                children: [
                                  const ImageAssetCustom(imagePath: IconsAssets.borderAlbumIcon),
                                  SizedBox(width: 8.w),
                                  Flexible(
                                    child: Text(
                                      'media_files_in_the_conversation_will_appear_here'.tr,
                                      style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.userGroupTwoIcon,
                    title: 'create_a_group_with'.trParams({'field': controller.parameter.user?.name ?? ''}),
                    onTap: () => Get.toNamed(
                      Routes.CREATE_GROUP,
                      arguments: CreateGroupParameter(
                        type: CreateGroupType.createGroup,
                        user: controller.parameter.user,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.trashBinIcon,
                    title: 'delete_conversation'.tr,
                    color: appTheme.errorColor,
                    onTap: () {
                      showCommonDialog(
                        title: 'are_you_sure_you_want_to_delete_the_conversation'.tr,
                        onSubmit: controller.deleteChat,
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
