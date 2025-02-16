import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/scroll_date/scroll_number.dart';
import 'package:flutter/material.dart';

class ScrollDateView extends StatefulWidget {
  final DateTime? date;
  final void Function(DateTime)? onChanged;

  const ScrollDateView({
    super.key,
    this.date,
    this.onChanged,
  });

  @override
  State<ScrollDateView> createState() => _ScrollDateViewState();
}

class _ScrollDateViewState extends State<ScrollDateView> {
  final ValueNotifier<int> _day = ValueNotifier(1);
  final ValueNotifier<int> _month = ValueNotifier(1);
  final ValueNotifier<int> _year = ValueNotifier(DateTime.now().year - 3);
  final ValueNotifier<int> _maxDay = ValueNotifier(31);

  DateTime get _date => DateTime(_year.value, _month.value, _day.value);

  @override
  void initState() {
    if (widget.date != null) {
      _day.value = widget.date!.day;
      _month.value = widget.date!.month;
      _year.value = widget.date!.year;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ValueListenableBuilder<int>(
                valueListenable: _day,
                builder: (context, value, _) {
                  return ScrollNumber(
                    minValue: 1,
                    maxValue: _maxDay.value,
                    value: value,
                    infiniteLoop: true,
                    selectedTextStyle: StyleThemeData.size20Weight600(color: appTheme.gray58Color),
                    textStyle: StyleThemeData.size14Weight400(color: appTheme.gray58Color),
                    onChanged: (int newValue) {
                      _day.value = newValue;
                      widget.onChanged?.call(_date);
                    },
                  );
                }),
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
                valueListenable: _month,
                builder: (context, value, _) {
                  return ScrollNumber(
                    minValue: 1,
                    maxValue: 12,
                    value: value,
                    infiniteLoop: true,
                    selectedTextStyle: StyleThemeData.size20Weight600(color: appTheme.gray58Color),
                    textStyle: StyleThemeData.size14Weight400(color: appTheme.gray58Color),
                    onChanged: (int newValue) {
                      _month.value = newValue;
                      int maxDays = _getMaxDaysInMonth(newValue, _year.value);
                      _maxDay.value = maxDays;

                      if (_day.value > maxDays) {
                        _day.value = maxDays;
                      }

                      widget.onChanged?.call(_date);
                    },
                  );
                }),
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
                valueListenable: _year,
                builder: (context, value, _) {
                  return ScrollNumber(
                    minValue: 1975,
                    maxValue: DateTime.now().year,
                    value: value,
                    infiniteLoop: false,
                    selectedTextStyle: StyleThemeData.size20Weight600(color: appTheme.gray58Color),
                    textStyle: StyleThemeData.size14Weight400(color: appTheme.gray58Color),
                    onChanged: (int newValue) {
                      _year.value = newValue;
                      widget.onChanged?.call(_date);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  int _getMaxDaysInMonth(int month, int year) {
    if (month == 2) {
      // nam nhuan
      if (year % 4 == 0 || year % 400 == 0) {
        return 29;
      }
      return 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }
    return 31;
  }
}
