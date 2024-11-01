import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  static parseIdr(String string) {}
}
