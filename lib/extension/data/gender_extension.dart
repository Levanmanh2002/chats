import 'package:chats/utils/app_enums.dart';

extension GenderStringExtension on String {
  Gender? get nameValue {
    switch (this) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'other':
        return Gender.other;

      default:
        return null;
    }
  }
}
