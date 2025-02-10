import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class CustomBorderButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final EdgeInsets? margin;
  final double? width;
  final double radius;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final TextStyle? styleButtonText;
  final EdgeInsets? paddings;

  const CustomBorderButtonWidget({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.margin,
    this.width,
    this.radius = 12,
    this.icon,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.styleButtonText,
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
          padding: paddings ?? padding(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              width: 1.w,
              color: onPressed == null ? appTheme.allSidesColor : color ?? appTheme.appColor,
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
                        valueColor: AlwaysStoppedAnimation<Color>(textColor ?? appTheme.appColor),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('loading'.tr, style: StyleThemeData.size12Weight400(color: textColor ?? appTheme.appColor)),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon != null ? Padding(padding: padding(right: 8), child: icon) : const SizedBox(),
                    Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: styleButtonText ??
                          StyleThemeData.size14Weight600(
                            color: (onPressed != null ? textColor : appTheme.grayColor) ??
                                (onPressed != null ? appTheme.appColor : appTheme.grayColor),
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
