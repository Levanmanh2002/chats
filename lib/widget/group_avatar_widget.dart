import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class GroupAvatarWidget extends StatelessWidget {
  const GroupAvatarWidget({
    super.key,
    required this.imageUrls,
    this.size = 60,
    this.showBoder = false,
    this.colorBoder,
    this.sizeBorder,
  });

  final List<String> imageUrls;
  final double size;
  final bool showBoder;
  final Color? colorBoder;
  final double? sizeBorder;

  @override
  Widget build(BuildContext context) {
    switch (imageUrls.length) {
      case 0:
        return CustomImageWidget(
          size: size,
          noImage: false,
          showBoder: showBoder,
          colorBoder: colorBoder,
        );

      case 1:
        return CustomImageWidget(
          imageUrl: imageUrls[0],
          size: size,
          noImage: false,
          showBoder: showBoder,
          colorBoder: colorBoder,
        );

      case 2:
        return _build2Images();

      case 3:
        return _build3Images();

      case 4:
        return _build4Images();

      default:
        return _buildFiveOrMoreOverlap();
    }
  }

  Widget _build2Images() {
    double radius = size * 0.3;

    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: (size - radius * 2) / 2,
            child: CustomImageWidget(
              imageUrl: imageUrls[0],
              size: size / 1.7,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
          Positioned(
            right: 0,
            top: (size - radius * 2) / 2,
            child: CustomImageWidget(
              imageUrl: imageUrls[1],
              size: size / 1.7,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3Images() {
    double radius = size * 0.3;

    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: CustomImageWidget(
              imageUrl: imageUrls[1],
              size: size / 1.9,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: CustomImageWidget(
              imageUrl: imageUrls[2],
              size: size / 1.9,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
          Positioned(
            left: (size - 2 * radius) / 2,
            top: 0,
            child: CustomImageWidget(
              imageUrl: imageUrls[0],
              size: size / 1.9,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build4Images() {
    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        children: [
          Positioned(
            right: 2,
            bottom: 0,
            child: CustomImageWidget(
              imageUrl: imageUrls[3],
              size: size / 2.2,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
          Positioned(
            left: 2,
            bottom: 0,
            child: CustomImageWidget(
              imageUrl: imageUrls[2],
              size: size / 2.2,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
          Positioned(
            right: size * 0.05,
            top: size * 0.05,
            child: CustomImageWidget(
              imageUrl: imageUrls[1],
              size: size / 2.2,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
          Positioned(
            left: size * 0.05,
            top: size * 0.05,
            child: CustomImageWidget(
              imageUrl: imageUrls[0],
              size: size / 2.2,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiveOrMoreOverlap() {
    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        children: [
          Positioned(
            right: 2,
            bottom: 0,
            child: Container(
              width: size / 2.2,
              height: size / 2.2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    showBoder ? Border.all(width: sizeBorder ?? 1.w, color: colorBoder ?? appTheme.grayColor) : null,
                color: appTheme.kLightGrayBackground,
              ),
              child: Text(
                imageUrls.length.toString(),
                style: StyleThemeData.size12Weight400(color: appTheme.kSlateBlueGray),
              ),
            ),
          ),
          Positioned(
            left: 2,
            bottom: 0,
            child: CustomImageWidget(
              imageUrl: imageUrls[2],
              size: size / 2.2,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
          Positioned(
            right: size * 0.05,
            top: size * 0.05,
            child: CustomImageWidget(
              imageUrl: imageUrls[1],
              size: size / 2.2,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
          Positioned(
            left: size * 0.05,
            top: size * 0.05,
            child: CustomImageWidget(
              imageUrl: imageUrls[0],
              size: size / 2.2,
              showBoder: showBoder,
              colorBoder: colorBoder,
              sizeBorder: sizeBorder,
              noImage: false,
            ),
          ),
        ],
      ),
    );
  }
}
