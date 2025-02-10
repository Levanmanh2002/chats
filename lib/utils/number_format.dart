import 'package:intl/intl.dart';

class NumberFormats {
  static final NumberFormat currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  static String formatCurrency(dynamic value) {
    return "${currencyFormat.format(value)}₫";
  }
}

String formatMatchNumber(String number) {
  return number.replaceAllMapped(RegExp(r".{1,3}"), (match) => '${match.group(0)} ');
}
