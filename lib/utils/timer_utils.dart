import 'package:get/get.dart';

class TimerUtils {
  static String formatTimeAgo(String createdAtString) {
    DateTime createdAt = DateTime.parse(createdAtString);

    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'just_now'.tr;
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${'minute_ago'.tr.toLowerCase()}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${'hour_ago'.tr.toLowerCase()}';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ${'day_ago'.tr.toLowerCase()}';
    } else if (difference.inDays < 365) {
      final months = now.month - createdAt.month + (now.year - createdAt.year) * 12;
      return '$months ${'month_ago'.tr.toLowerCase()}';
    } else {
      final years = now.year - createdAt.year;
      return '$years ${'year_ago'.tr.toLowerCase()}';
    }
  }

  static String formatTimeAgoDateTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'just_now'.tr;
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${'minute_ago'.tr.toLowerCase()}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${'hour_ago'.tr.toLowerCase()}';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ${'day_ago'.tr.toLowerCase()}';
    } else if (difference.inDays < 365) {
      final months = now.month - createdAt.month + (now.year - createdAt.year) * 12;
      return '$months ${'month_ago'.tr.toLowerCase()}';
    } else {
      final years = now.year - createdAt.year;
      return '$years ${'year_ago'.tr.toLowerCase()}';
    }
  }

  static String formatTimestamp(DateTime dateTime) {
    final now = DateTime.now().toLocal();
    final dateTimeWithoutTime = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = now.difference(dateTimeWithoutTime);
    var timeText = '';

    if (difference.inDays == 0) {
      timeText = 'today'.tr;
    } else if (difference.inDays == 1) {
      timeText = 'yesterday'.tr;
    } else if (difference.inDays < 7) {
      timeText = '${difference.inDays} ${'days_ago'.tr}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      timeText = '$weeks ${'weeks_ago'.tr}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      timeText = '$months ${'months_ago'.tr}';
    } else {
      final years = (difference.inDays / 365).floor();
      timeText = '$years ${'years_ago'.tr}';
    }

    return timeText;
  }

  static String formatDuration(String duration) {
    List<String> parts = duration.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    if (hours > 0) {
      return '$hours ${'hour'.tr.toLowerCase()}';
    } else {
      return '$minutes ${'minute'.tr.toLowerCase()}';
    }
  }

  static String getReadableDuration(String duration) {
    if (!duration.contains(':')) return '0 ${'minute'.tr.toLowerCase()}';

    List<String> parts = duration.split(':');
    if (parts.length < 2) return '0 ${'minute'.tr.toLowerCase()}';

    int hours = int.tryParse(parts[0]) ?? 0;
    int minutes = int.tryParse(parts[1]) ?? 0;

    if (hours > 0) {
      return '$hours ${'hour'.tr.toLowerCase()}';
    } else {
      return '$minutes ${'minute'.tr.toLowerCase()}';
    }
  }

  static String getTotalHours(String duration) {
    List<String> parts = duration.split(':');
    int minutes = int.tryParse(parts[1]) ?? 0;
    int hours = int.tryParse(parts[0]) ?? 0;

    return '${(hours * 60) + minutes} ${'minute'.tr.toLowerCase()}';
  }

  static String formatMonthYear(DateTime dateTime) {
    final month = dateTime.month;
    final year = dateTime.year;

    return '${'month'.tr} $month/$year';
  }
}
