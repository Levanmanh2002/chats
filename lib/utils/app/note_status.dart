import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteStatus {
  static const STATUS_NEW = 'STATUS_NEW';
  static const STATUS_IN_PROGRESS = 'STATUS_IN_PROGRESS';
  static const STATUS_COMPLETED = 'STATUS_COMPLETED';
  static const STATUS_CANCELED = 'STATUS_CANCELED';
}

enum NoteStatusEnum {
  STATUS_NEW,
  STATUS_IN_PROGRESS,
  STATUS_COMPLETED,
  STATUS_CANCELED,
}

extension NoteStatusExtension on NoteStatusEnum {
  String get dislayName {
    switch (this) {
      case NoteStatusEnum.STATUS_NEW:
        return 'Chưa thực hiện'.tr;
      case NoteStatusEnum.STATUS_IN_PROGRESS:
        return 'Đang tiến hành'.tr;
      case NoteStatusEnum.STATUS_COMPLETED:
        return 'Hoàn thành'.tr;
      case NoteStatusEnum.STATUS_CANCELED:
        return 'Đã hủy'.tr;
    }
  }

  String get statusKey {
    switch (this) {
      case NoteStatusEnum.STATUS_NEW:
        return NoteStatus.STATUS_NEW;
      case NoteStatusEnum.STATUS_IN_PROGRESS:
        return NoteStatus.STATUS_IN_PROGRESS;
      case NoteStatusEnum.STATUS_COMPLETED:
        return NoteStatus.STATUS_COMPLETED;
      case NoteStatusEnum.STATUS_CANCELED:
        return NoteStatus.STATUS_CANCELED;
    }
  }
}

extension NoteStatusColorExtension on String {
  Color get color {
    switch (this) {
      case NoteStatus.STATUS_NEW:
        return Colors.blue;
      case NoteStatus.STATUS_IN_PROGRESS:
        return Colors.orange;
      case NoteStatus.STATUS_COMPLETED:
        return Colors.green;
      case NoteStatus.STATUS_CANCELED:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case NoteStatus.STATUS_NEW:
        return Colors.blue.withOpacity(0.1);
      case NoteStatus.STATUS_IN_PROGRESS:
        return Colors.orange.withOpacity(0.1);
      case NoteStatus.STATUS_COMPLETED:
        return Colors.green.withOpacity(0.1);
      case NoteStatus.STATUS_CANCELED:
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
}
