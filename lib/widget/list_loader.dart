import 'package:chats/theme/style/style_theme.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListLoader extends StatelessWidget {
  final Widget child;
  final Future<dynamic>? Function()? onLoad;
  final Future<dynamic>? Function()? onRefresh;
  final bool hasNext;
  final bool forceScrollable;
  final Color? color;

  const ListLoader({
    super.key,
    required this.child,
    this.onRefresh,
    this.hasNext = false,
    this.onLoad,
    this.forceScrollable = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: const MaterialHeader(),
      footer: ClassicFooter(
        showMessage: false,
        failedText: 'refresh_load_failed'.tr,
        processingText: 'loading'.tr,
        readyText: 'refresh_can_loading'.tr,
        noMoreText: 'refresh_no_more'.tr,
        processedText: ''.tr,
        // processedText: 'succeeded'.tr,
        textStyle: StyleThemeData.size14Weight400(color: color),
        iconTheme: IconThemeData(color: color),
      ),
      onRefresh: onRefresh,
      onLoad: hasNext ? onLoad : null,
      child: forceScrollable
          ? CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: child,
                )
              ],
            )
          : child,
    );
  }
}
