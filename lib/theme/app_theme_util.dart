import 'package:chats/theme/base_theme_data.dart';
import 'package:chats/theme/style/base_app_theme.dart';
import 'package:chats/theme/theme.dart';
import 'package:flutter/material.dart';

class AppThemeUtil {
  final theme = AppThemeDefault();

  final ValueNotifier<ThemeType> themeType = ValueNotifier(ThemeType.light);

  BaseAppTheme get appTheme => theme;

  void dispose() {
    themeType.dispose();
  }

  ThemeData getThemeData() {
    return theme.getThemeData(themeType.value);
  }

  BaseThemeData getAppTheme() {
    return theme.getBaseTheme(themeType.value);
  }

  onChangeLightDarkMode() {
    if (themeType.value == ThemeType.light) {
      themeType.value = ThemeType.dark;
    } else {
      themeType.value = ThemeType.light;
    }
  }
}
