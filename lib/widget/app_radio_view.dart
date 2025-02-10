import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AppRadioView extends StatelessWidget {
  final bool isSelected;
  final double? activeSize;
  final double? size;
  final Color? backgroundColor;

  const AppRadioView({
    super.key,
    this.isSelected = false,
    this.activeSize,
    this.size,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 18.w,
      height: size ?? 18.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected ? null : Border.all(color: appTheme.grayColor, width: 1),
        color: isSelected ? backgroundColor ?? appTheme.appColor : null,
      ),
      child: isSelected
          ? SizedBox(
              width: activeSize ?? 8.w,
              height: activeSize ?? 8.w,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: appTheme.whiteColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
