import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_parameter.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/dynamic_grid_item_view.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/video/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChastListView extends StatefulWidget {
  const ChastListView({super.key, required this.controller});

  final MessageController controller;

  @override
  State<ChastListView> createState() => ChastListViewState();
}

class ChastListViewState extends State<ChastListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
      //     !_scrollController.position.outOfRange) {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        widget.controller.fetchChatList(widget.controller.messageModel.value!.chat!.id!, isRefresh: false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = widget.controller.messageModel.value?.listMessages ?? [];
      if (data.isEmpty) {
        return const SizedBox();
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: data.length,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        reverse: true,
        itemBuilder: (context, int index) {
          final item = data[index];
          final previousItem = index < data.length - 1 ? data[index + 1] : null;

          final shouldShowTime =
              previousItem == null || item.createdAt?.formatToHourMinute != previousItem.createdAt?.formatToHourMinute;

          return Column(
            children: [
              if (shouldShowTime)
                Container(
                  margin: padding(all: 12),
                  padding: padding(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: appTheme.grayB9Color,
                  ),
                  child: Text(
                    item.createdAt?.formatToHourMinute ?? '',
                    style: StyleThemeData.size12Weight400(color: appTheme.whiteColor),
                  ),
                ),
              Padding(
                padding: padding(horizontal: 16),
                child: Column(
                  children: [
                    _itemListMessage(
                      text: item.message ?? '',
                      isCurrentUser: item.sender?.id == Get.find<ProfileController>().user.value?.id,
                    ),
                    if ((item.files ?? []).isNotEmpty) ...[
                      Align(
                        alignment: item.sender?.id == Get.find<ProfileController>().user.value?.id
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 300.w),
                          child: DynamicGridItemView<FilesModels>(
                            items: item.files ?? [],
                            borderRadius: 8,
                            itemBuilder: (file, index) {
                              return LayoutBuilder(
                                builder: (context, constraint) => Padding(
                                  padding: padding(all: 4),
                                  child: InkWell(
                                    onTap: () => Get.toNamed(
                                      Routes.ATTACHMENT_FULLSCREEN,
                                      arguments: AttachmentFullscreenParameter(
                                        files: item.files ?? [],
                                        index: index,
                                        user: item.sender,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    child: _buildAttachFileView(file, constraint.maxWidth.w),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Widget _itemListMessage({required String text, required bool isCurrentUser}) {
    return Padding(
      padding: padding(vertical: 2),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: 300.w),
          padding: padding(all: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isCurrentUser ? appTheme.appColor : appTheme.whiteColor,
          ),
          child: Text(
            text,
            style: StyleThemeData.size14Weight400(color: isCurrentUser ? appTheme.whiteColor : appTheme.blackColor),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachFileView(FilesModels item, double width) {
    switch (item.fileType?.getFileCategory) {
      case FileCategory.IMAGE:
        return CustomImageWidget(
          imageUrl: item.fileUrl ?? '',
          size: width,
          borderRadius: 8,
        );
      case FileCategory.VIDEO:
        return Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayerWidget(
              videoUrl: item.fileUrl ?? '',
            ),
            const ImageAssetCustom(imagePath: IconsAssets.playVideoIcon)
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
