import 'package:intl/intl.dart';

class Utils {
  static String formatPrice(double price) {
    final priceFormat = NumberFormat('###,###.00');
    return priceFormat.format(price);
  }

  static String formatDate(DateTime date) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return dateFormat.format(date);
  }

  static String formatTime(DateTime time) {
    final timeFormat = DateFormat('HH:mm');
    return timeFormat.format(time);
  }
}
