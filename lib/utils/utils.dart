import 'package:intl/intl.dart';

String formatPrice(double price, {bool isSymbol = true}) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: isSymbol ? 'Rp. ' : '',
    decimalDigits: 0,
  ).format(price);
}
