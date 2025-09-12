import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class TabNoteView extends StatelessWidget {
  const TabNoteView({
    super.key,
    required this.isSelect,
    required this.title,
    this.onTap,
    this.color = '',
  });

  final bool isSelect;
  final String title;
  final VoidCallback? onTap;
  final String color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: padding(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: isSelect
              ? color.isNotEmpty
                  ? color.toColor
                  : appTheme.appColor
              : color.toColor.withOpacity(0.1),
        ),
        child: Text(
          title,
          style: StyleThemeData.size14Weight400(
            color: isSelect ? appTheme.whiteColor : color.toColor,
          ),
        ),
      ),
    );
  }
}
