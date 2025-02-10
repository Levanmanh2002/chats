import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class CustomButton extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final EdgeInsets? margin;
  final double? width;
  final double radius;
  final Widget? icon;
  // final Color? color;
  final Color? textColor;
  final bool isLoading;
  final EdgeInsets? paddings;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.margin,
    this.width,
    this.radius = 1000,
    this.icon,
    // this.color,
    this.textColor,
    this.isLoading = false,
    this.paddings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin == null ? EdgeInsets.zero : margin!,
      child: InkWell(
        onTap: isLoading
            ? null
            : () {
                FocusScope.of(context).unfocus();
                onPressed?.call();
              },
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: width != null ? width! : Get.size.width,
          padding: paddings ?? padding(all: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: onPressed == null ? appTheme.allSidesColor : null,
            gradient: onPressed == null
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [appTheme.blueFCColor, appTheme.appColor],
                    stops: const [0.0048, 0.8952],
                  ),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15.w,
                      width: 15.w,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(appTheme.whiteColor),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('loading'.tr, style: StyleThemeData.size12Weight400(color: appTheme.whiteColor)),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon != null ? Padding(padding: padding(right: 8), child: icon) : const SizedBox(),
                    Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: StyleThemeData.size14Weight600(
                        color: textColor ?? (onPressed != null ? appTheme.whiteColor : appTheme.grayColor),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
