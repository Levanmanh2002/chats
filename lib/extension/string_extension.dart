import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension StringToInt on String? {
  int get toIntValue {
    return int.tryParse(this ?? '') ?? 0;
  }

  double get toDoubleValue {
    return double.tryParse(this ?? '') ?? 0;
  }
}

extension StringFormatting on String {
  String get formattedCurrency {
    final number = double.tryParse(this);
    if (number == null) {
      return this;
    }
    return '${number.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}₫';
  }

  String get formatPhoneNumber {
    String cleanPhoneNumber = replaceAll(RegExp(r'\D'), '');

    String formatted = '';
    for (int i = 0; i < cleanPhoneNumber.length; i++) {
      if (i > 0 && (cleanPhoneNumber.length - i) % 3 == 0) {
        formatted += ' ';
      }
      formatted += cleanPhoneNumber[i];
    }

    return formatted;
  }

  String get getFormattedPhoneNumber {
    if (isEmpty) {
      return "";
    }

    String phoneNumber = this;
    bool addPlus = phoneNumber.startsWith("1");
    if (addPlus) phoneNumber = phoneNumber.substring(1);
    bool addParents = phoneNumber.length >= 3;
    bool addDash = phoneNumber.length >= 8;

    String updatedNumber = "";
    if (addPlus) updatedNumber += "+1";

    if (addParents) {
      updatedNumber += "(";
      updatedNumber += phoneNumber.substring(0, 3);
      updatedNumber += ")";
    } else {
      updatedNumber += phoneNumber.substring(0);
      return updatedNumber;
    }

    if (addDash) {
      updatedNumber += phoneNumber.substring(3, 6);
      updatedNumber += "-";
    } else {
      updatedNumber += phoneNumber.substring(3);
      return updatedNumber;
    }

    updatedNumber += phoneNumber.substring(6);
    return updatedNumber;
  }

  String get toHourMinute {
    try {
      final time = DateFormat("HH:mm:ss").parse(this);
      return DateFormat("HH:mm").format(time);
    } catch (e) {
      return this;
    }
  }

  String get formatToHourMinute {
    try {
      final time = DateTime.parse(this).toLocal();
      return DateFormat("HH:mm").format(time);
    } catch (e) {
      return this;
    }
  }

  String get toCustomFormat {
    try {
      final date = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(this, true);
      return DateFormat("HH:mm, dd/MM/yyyy").format(date);
    } catch (e) {
      return this;
    }
  }

  String get addSpaceAfterComma {
    return replaceAllMapped(
      RegExp(r',(?!\s)'),
      (match) => ', ',
    );
  }

  String get maskedPhone {
    if (length < 4) return this;

    String firstChar = this[0];
    String lastThree = substring(length - 3);
    String maskedPart = '*' * (length - 4);

    return '$firstChar$maskedPart$lastThree';
  }

  String get formatPhoneCode {
    if (startsWith('+84')) {
      return replaceFirst('+84', '0');
    } else {
      return '+84${startsWith('0') ? substring(1) : this}';
    }
  }
}

extension TimeAgoExtension on String {
  String get timeAgo {
    DateTime createdTime = DateTime.parse(this);
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdTime);

    if (difference.inMinutes < 1) {
      return 'just_now'.tr;
    } else if (difference.inMinutes < 60) {
      return 'field_minutes_ago'.trParams({'field': '${difference.inMinutes}'});
    } else if (difference.inHours < 24) {
      return 'field_hours_ago'.trParams({'field': '${difference.inHours}'});
    } else if (difference.inDays < 30) {
      return 'field_days_ago'.trParams({'field': '${difference.inDays}'});
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return 'field_months_ago'.trParams({'field': '$months'});
    } else {
      int years = (difference.inDays / 365).floor();
      return 'field_years_ago'.trParams({'field': '$years'});
    }
  }
}
