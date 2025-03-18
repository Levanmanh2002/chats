import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/launch_url.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/images/selectable_image_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/video/video_player_widget.dart';
import 'package:flutter/material.dart';

class AttachFileWidget extends StatelessWidget {
  const AttachFileWidget({
    super.key,
    required this.item,
    required this.size,
    this.borderRadius = 8.0,
    this.isCurrentUser,
  });

  final FilesModels item;
  final double size;
  final double borderRadius;
  final bool? isCurrentUser;

  @override
  Widget build(BuildContext context) {
    switch (item.fileType?.getFileCategory) {
      case FileCategory.IMAGE:
        return SelectableImageView(
          fileUrl: item.fileUrl ?? '',
          isLocal: item.isLocal,
          size: size,
          borderRadius: borderRadius,
        );
      case FileCategory.VIDEO:
        return Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayerWidget(videoPath: item.fileUrl ?? '', isLocal: item.isLocal),
            const ImageAssetCustom(imagePath: IconsAssets.playVideoIcon)
          ],
        );
      case FileCategory.DOCUMENT:
        return InkWell(
          onTap: () {
            openUrlInBrowser(item.fileUrl ?? '');
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            padding: padding(all: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isCurrentUser == true ? appTheme.appColor : appTheme.whiteColor,
            ),
            child: Row(
              children: [
                ImageAssetCustom(
                  imagePath: IconsAssets.paperclipIcon,
                  size: 24.w,
                  color: isCurrentUser == true ? appTheme.whiteColor : null,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    item.fileUrl?.split('/').last ?? '',
                    style: StyleThemeData.size12Weight400(
                      color: isCurrentUser == true ? appTheme.whiteColor : appTheme.appColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
