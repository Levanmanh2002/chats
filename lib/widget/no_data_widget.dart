import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, this.height, this.isSearch = true});

  final double? height;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height),
          (isSearch)
              ? Image.asset(ImagesAssets.searchEmptyImage, width: 140.w)
              : Image.asset(ImagesAssets.noFolderImage),
          SizedBox(height: 12.h),
          Text('refresh_no_more'.tr, style: StyleThemeData.size16Weight600(color: appTheme.grayColor)),
        ],
      ),
    );
  }
}
