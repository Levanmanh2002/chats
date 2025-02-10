import 'package:chats/main.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/widgets.dart';

class BorderGradientCircle extends StatelessWidget {
  const BorderGradientCircle({super.key, this.size, this.gradient, this.color});

  final double? size;
  final Gradient? gradient;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 8.w,
      height: size ?? 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: color != null ? null : gradient ?? appTheme.redOrangeGradient,
        color: color,
      ),
    );
  }
}
