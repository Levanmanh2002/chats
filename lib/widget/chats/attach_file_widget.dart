import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/images/selectable_image_widget.dart';
import 'package:chats/widget/video/video_player_widget.dart';
import 'package:flutter/material.dart';

class AttachFileWidget extends StatelessWidget {
  const AttachFileWidget({super.key, required this.item, required this.size, this.borderRadius = 8.0});

  final FilesModels item;
  final double size;
  final double borderRadius;

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
      default:
        return const SizedBox();
    }
  }
}
