import 'package:chats/utils/app_constants.dart';
import 'package:chats/widget/input_formatter/currency_input_formatter.dart';
import 'package:chats/widget/input_formatter/money_input_formatter.dart';
import 'package:chats/widget/input_formatter/no_diacritics_text_formatter.dart';
import 'package:chats/widget/input_formatter/no_initial_spaceInput_formatter_widgets.dart';
import 'package:flutter/services.dart';

/// NoInitialSpaceInputFormatterWidgets: loại bỏ khoảng trắng đầu
/// NoDiacriticsTextFormatter: loại bỏ các ký tự có dấu

class FormatterUtil {
  static final List<TextInputFormatter> fullNameFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\sÀ-ỹ]')),
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatterWidgets(),
    LengthLimitingTextInputFormatter(25),
  ];

  static final List<TextInputFormatter> phoneFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(20),
  ];

  static final List<TextInputFormatter> passwordFormatter = [
    NoDiacriticsTextFormatter(),
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
    LengthLimitingTextInputFormatter(50),
  ];

  static final List<TextInputFormatter> referralCodeFormatter = [
    NoDiacriticsTextFormatter(),
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
  ];

  static final List<TextInputFormatter> emailFormatter = [
    NoDiacriticsTextFormatter(),
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
    LengthLimitingTextInputFormatter(50),
  ];

  static final List<TextInputFormatter> notesFormatter = [
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatterWidgets(),
    LengthLimitingTextInputFormatter(AppConstants.maxNameLength),
  ];

  static final List<TextInputFormatter> moneyFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(10),
    MoneyInputFormatter(),
  ];

  static final List<TextInputFormatter> currencyFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(10),
    CurrencyInputFormatter(),
  ];

  static final List<TextInputFormatter> addressFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\sÀ-ỹ]')),
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatterWidgets(),
    LengthLimitingTextInputFormatter(50),
  ];

  static final List<TextInputFormatter> createGroupFormatter = [
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatterWidgets(),
    LengthLimitingTextInputFormatter(50),
  ];

  static final List<TextInputFormatter> shortcutFormatter = [
    FilteringTextInputFormatter.deny('  '),
    NoInitialSpaceInputFormatterWidgets(),
    LengthLimitingTextInputFormatter(15),
  ];

  static final List<TextInputFormatter> chatMessageFormatter = [
    NoInitialSpaceInputFormatterWidgets(),
    LengthLimitingTextInputFormatter(1000),
  ];
}
