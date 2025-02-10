import 'package:chats/resourese/service/localization_service.dart';
import 'package:chats/utils/app_enums.dart';
import 'package:intl/intl.dart';

extension CurrencyFormatter on num {
  String get formattedCurrency {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: LocalizationService.language.locale.languageCode,
      symbol: '',
      decimalDigits: 0,
    );
    return '${currencyFormat.format(this).trim()}₫';
  }

  String get formattedWithoutCurrency {
    final NumberFormat currencyFormat = NumberFormat.decimalPattern(LocalizationService.language.locale.languageCode);
    return currencyFormat.format(this).trim();
  }
}
