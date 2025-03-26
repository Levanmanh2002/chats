import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAppbar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppbar({
    super.key,
    this.title = '',
    this.actions,
    this.action,
    this.backgroundColor,
    this.onSubmitted,
    this.isLoadingSearch = false,
    this.isShowBack = false,
    this.isSearch = true,
    this.widgetTitle,
    this.onBack,
    this.isActiveSearch = false,
    this.isOffSearch = false,
    this.sizeAction = 0,
    this.toggleNotifier = true,
    this.leftTitle = 0,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? action;
  final Color? backgroundColor;
  final void Function(String)? onSubmitted;
  final bool isLoadingSearch;
  final bool isShowBack;
  final bool isSearch;
  final Widget? widgetTitle;
  final VoidCallback? onBack;
  final bool isActiveSearch;
  final bool isOffSearch;
  final double sizeAction;
  final bool toggleNotifier;
  final double leftTitle;

  @override
  State<SearchAppbar> createState() => _SearchAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20.h);
}

class _SearchAppbarState extends State<SearchAppbar> {
  final TextEditingController _controller = TextEditingController();

  late final ValueNotifier<bool> _toggleNotifier;

  final ValueNotifier<String> _searchValueNotifier = ValueNotifier<String>('');

  var searchValue = '';

  @override
  void initState() {
    super.initState();
    _toggleNotifier = ValueNotifier<bool>(widget.toggleNotifier);
  }

  void _doToggle() => _toggleNotifier.value = !_toggleNotifier.value;

  @override
  void didUpdateWidget(covariant SearchAppbar oldWidget) {
    if (widget.toggleNotifier != oldWidget.toggleNotifier) {
      _toggleNotifier.value = widget.toggleNotifier;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor ?? appTheme.whiteColor,
      titleSpacing: 0,
      leadingWidth: 0,
      toolbarHeight: kToolbarHeight + 20.h,
      leading: const SizedBox(),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: _toggleNotifier,
          builder: (context, toggle, child) {
            if (toggle) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.actions ??
                    [
                      if (widget.isSearch)
                        IconButton(
                          onPressed: _doToggle,
                          icon: ImageAssetCustom(
                            imagePath: IconsAssets.searchIcon,
                            size: 24.w,
                            color: appTheme.whiteColor,
                          ),
                        ),
                      widget.action ?? const SizedBox(),
                      widget.sizeAction > 0 ? SizedBox(width: widget.sizeAction) : const SizedBox(),
                    ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
      centerTitle: false,
      title: ValueListenableBuilder<bool>(
        valueListenable: _toggleNotifier,
        builder: (context, toggle, child) {
          return Padding(
            padding: padding(vertical: 16, left: widget.isShowBack ? 0 : 16, right: 16),
            child: toggle
                ? Padding(
                    padding: padding(left: widget.leftTitle),
                    child: widget.widgetTitle ??
                        Text(
                          widget.title,
                          style: StyleThemeData.size24Weight600(color: appTheme.whiteColor),
                        ),
                  )
                : Row(
                    children: [
                      (widget.isShowBack == true)
                          ? IconButton(
                              onPressed: widget.isOffSearch == true ? _doToggle : widget.onBack ?? () => Get.back(),
                              icon: ImageAssetCustom(
                                imagePath: IconsAssets.arrowLeftIcon,
                                size: 24.w,
                                color: appTheme.whiteColor,
                              ),
                            )
                          : const SizedBox(),
                      Flexible(
                        child: CustomTextField(
                          controller: _controller,
                          hintText: 'search'.tr,
                          onSubmit: widget.onSubmitted,
                          showLine: false,
                          prefixIcon: IconButton(
                            onPressed: null,
                            icon: ImageAssetCustom(
                              imagePath: IconsAssets.searchIcon,
                              color: appTheme.grayColor,
                              size: 24.w,
                            ),
                          ),
                          onChanged: (value) => _searchValueNotifier.value = value,
                          suffixIcon: ValueListenableBuilder<String>(
                            valueListenable: _searchValueNotifier,
                            builder: (context, searchValue, child) {
                              if (widget.isLoadingSearch) {
                                return IconButton(
                                  onPressed: null,
                                  icon: SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: CircularProgressIndicator(color: appTheme.appColor, strokeWidth: 2.w),
                                  ),
                                );
                              } else if (searchValue.isNotEmpty) {
                                return IconButton(
                                  onPressed: () {
                                    _controller.clear();
                                    _searchValueNotifier.value = '';
                                    if (widget.isOffSearch == false) _doToggle();
                                    widget.onSubmitted?.call('');
                                  },
                                  icon: ImageAssetCustom(imagePath: IconsAssets.closeCircleIcon, size: 24.w),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _toggleNotifier.dispose();
    _controller.dispose();
    _searchValueNotifier.dispose();
    super.dispose();
  }
}
