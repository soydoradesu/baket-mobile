import 'package:intl/intl.dart';

class DateConverter {
  static String getTime(DateTime postDate) {
    final now = DateTime.now();
    final difference = now.difference(postDate);

    final diffInSeconds = difference.inSeconds;
    final diffInMinutes = difference.inMinutes;
    final diffInHours = difference.inHours;

    if (diffInSeconds < 60) {
      return '${diffInSeconds}s';
    } else if (diffInMinutes < 60) {
      return '${diffInMinutes}m';
    } else if (diffInHours < 24) {
      return '${diffInHours}h';
    } else {
      return DateFormat('dd MMM yyyy').format(postDate);
    }
  }
}
