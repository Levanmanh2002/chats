import 'package:chats/pages/dashboard/dashboard_controller.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupTickersView extends GetView<GroupMessageController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: GridView.builder(
        itemCount: Get.find<DashboardController>().tickersModel.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (ticker, index) {
          final ticker = Get.find<DashboardController>().tickersModel[index];
          return LayoutBuilder(
            builder: (context, constraint) => Padding(
              padding: padding(all: 4),
              child: InkWell(
                onTap: () {
                  controller.sendTicker(ticker);
                },
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: ticker.url ?? '',
                  borderRadius: 0,
                  showBoder: false,
                  size: constraint.maxWidth.w,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
