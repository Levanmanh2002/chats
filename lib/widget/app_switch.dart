import 'package:chats/main.dart';
import 'package:flutter/cupertino.dart';

class AppSwitch extends StatelessWidget {
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onChange;
  final Color? trackColor;

  const AppSwitch({
    super.key,
    this.activeColor,
    required this.isActive,
    this.onChange,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: isActive,
      activeColor: activeColor ?? appTheme.green44Color,
      trackColor: trackColor ?? appTheme.grayColor,
      onChanged: (bool value) {
        onChange?.call();
      },
    );
  }
}
