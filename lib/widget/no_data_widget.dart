import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height),
          Image.asset(ImagesAssets.noFolderImage),
          SizedBox(height: 12.h),
          Text('refresh_no_more'.tr, style: StyleThemeData.size14Weight700()),
        ],
      ),
    );
  }
}
