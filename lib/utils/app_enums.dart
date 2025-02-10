import 'dart:ui';

import 'package:chats/utils/icons_assets.dart';
import 'package:get/get.dart';

extension LanguageExtension on Languages {
  String get title {
    switch (this) {
      case Languages.vi:
        return 'vietnamese'.tr;
      case Languages.en:
        return 'english'.tr;
    }
  }

  Locale get locale {
    switch (this) {
      case Languages.vi:
        return const Locale('vi', 'VN');
      case Languages.en:
        return const Locale('en', 'US');
    }
  }

  String get flagAsset {
    switch (this) {
      case Languages.vi:
        return IconsAssets.vietnamIcon;
      case Languages.en:
        return IconsAssets.englandIcon;
    }
  }
}

enum Languages {
  vi,
  en,
}

enum Gender { male, female, other }

extension GenderExtension on Gender {
  String get title {
    switch (this) {
      case Gender.male:
        return 'male'.tr;
      case Gender.female:
        return 'female'.tr;
      case Gender.other:
        return 'other'.tr;
    }
  }
}

enum TipsAction { love, unlove }
