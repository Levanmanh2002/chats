import 'package:chats/constant/date_format_constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String get toFormattedString {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year.toString();
    return "$day/$month/$year";
  }

  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  String get toDateOnly {
    return "$year-$month-$day";
  }

  String get toMMMMyyyy {
    final formattedDate = DateFormat(DateConstants.MMMMyyyy, Get.locale?.languageCode).format(this);
    return formattedDate[0].toUpperCase() + formattedDate.substring(1);
  }

  String get toyyyyMMdd {
    return DateFormat(DateConstants.yyyyMMdd).format(this);
  }

  String toStringDate() {
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  int get inMonths => (year * 12 + month);
}

extension DateFormatter on String? {
  String get toHHmmddMMyyyy {
    if (this == null || this!.isEmpty) return 'undefined'.tr;

    try {
      final dateTime = DateTime.parse(this!);
      final formattedDate = DateFormat(DateConstants.hhMMddMMMMyyyy).format(dateTime);
      return formattedDate;
    } catch (e) {
      return 'invalid_format'.tr;
    }
  }

  String get tohhmmddMMyyyy {
    if (this == null || this!.isEmpty) return 'undefined'.tr;

    try {
      final dateTime = DateTime.parse(this!);
      final formattedDate = DateFormat(DateConstants.hhmmddMMyyyy).format(dateTime);
      return formattedDate;
    } catch (e) {
      return 'invalid_format'.tr;
    }
  }

  String get toHm {
    if (this == null || this!.isEmpty) return '';
    try {
      return this!.substring(0, 5);
    } catch (e) {
      return '';
    }
  }

  String get toDayMonthYear {
    if (this == null || this!.isEmpty) return 'undefined'.tr;

    final dateTime = DateTime.parse(this ?? '');

    return DateFormat(DateConstants.ddMMyyyy).format(dateTime);
  }
}

extension DateTimeExtension on DateTime? {
  bool isSameDay(DateTime dateTime) {
    if (this == null) return false;
    return dateTime.day == this!.day && dateTime.month == this!.month && dateTime.year == this!.year;
  }

  bool get isToday {
    if (this == null) return false;
    final now = DateTime.now();
    return now.day == this!.day && now.month == this!.month && now.year == this!.year;
  }

  String get toHourMinute {
    if (this == null) return '--:--';
    return DateFormat(DateConstants.hhmm).format(this!);
  }

  String get toDateddMMyyyy {
    if (this == null) return '--/--/----';
    return DateFormat(DateConstants.ddMMyyyy).format(this!);
  }
}

extension DateFormatting on String {
  String get toTimeWithAMPM {
    try {
      final time = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(this);

      return DateFormat('h:mm a').format(time);
    } catch (e) {
      return this;
    }
  }
}
