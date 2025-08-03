import 'package:chats/main.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/chats/view/chat_all_view.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appTheme.background,
        appBar: _buildModernAppBar(),
        body: Column(
          children: [
            Expanded(child: ChatAllView()),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(120.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appTheme.primaryGradientStart,
              appTheme.primaryGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: padding(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'chat'.tr,
                        style: StyleThemeData.size24Weight700(color: appTheme.whiteColor),
                      ),
                    ),
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: appTheme.whiteColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.add,
                          color: appTheme.whiteColor,
                          size: 20.w,
                        ),
                        color: appTheme.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'add_friend',
                            child: Row(
                              children: [
                                Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    color: appTheme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.person_add,
                                    size: 16.w,
                                    color: appTheme.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'add_friend'.tr,
                                  style: StyleThemeData.size14Weight500(),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'create_group',
                            child: Row(
                              children: [
                                Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    color: appTheme.greenColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.group_add,
                                    size: 16.w,
                                    color: appTheme.greenColor,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'create_group'.tr,
                                  style: StyleThemeData.size14Weight500(),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'add_friend') {
                            Get.toNamed(Routes.ADD_FRIEND);
                          } else if (value == 'create_group') {
                            Get.toNamed(
                              Routes.CREATE_GROUP,
                              arguments: CreateGroupParameter(type: CreateGroupType.createGroup),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: appTheme.whiteColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    onSubmitted: controller.onSearchChat,
                    style: StyleThemeData.size14Weight400(color: appTheme.whiteColor),
                    cursorColor: appTheme.appColor,
                    decoration: InputDecoration(
                      hintText: 'search'.tr,
                      hintStyle: StyleThemeData.size14Weight400(color: appTheme.whiteColor.withOpacity(0.7)),
                      prefixIcon: Icon(
                        Icons.search,
                        color: appTheme.whiteColor.withOpacity(0.7),
                        size: 20.w,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
