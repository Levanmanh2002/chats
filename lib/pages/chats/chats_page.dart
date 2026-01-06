import 'package:chats/main.dart';
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
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: controller.isLoading.isTrue
                    ? Center(child: Image.asset(GifUtils.noDataImageGif))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobileView = constraints.maxWidth < 768;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (controller.isMobileView.value != isMobileView) {
                              controller.updateViewMode(isMobileView);
                            }
                          });

                          if (!isMobileView) {
                            return Row(
                              children: [
                                Flexible(flex: 3, child: ChatAllView()),
                                VerticalDivider(thickness: 1, width: 0.5, color: appTheme.background),
                                Flexible(
                                  flex: 8,
                                  child: Obx(
                                    () => controller.messageModel.value != null
                                        ? controller.isGroup.isTrue
                                            ? GroupMessageWebPage()
                                            : MessageWebPage()
                                        : const Center(child: NoDataWidget()),
                                  ),
                                ),
                              ],
                            );
                          }

                          return _buildMobileView();
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView() {
    return Obx(() {
      if (controller.isShowChatList.value) {
        return ChatAllView();
      }

      if (controller.messageModel.value != null) {
        return controller.isGroup.isTrue ? GroupMessageWebPage() : MessageWebPage();
      }

      return const Center(child: NoDataWidget());
    });
  }
}
