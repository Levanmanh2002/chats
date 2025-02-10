import 'package:chats/main.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineWidget extends StatelessWidget {
  const LineWidget({this.width, this.height, this.color, this.margin, super.key});

  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width?.w ?? Get.size.width,
      height: height?.h ?? 1.h,
      color: color ?? appTheme.allSidesColor,
    );
  }
}
