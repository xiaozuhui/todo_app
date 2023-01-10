import 'package:intl/intl.dart';

class DateTool {
  static String fromMill(int mill) {
    return DateFormat("yyyy-MM-dd")
        .format(DateTime.fromMillisecondsSinceEpoch(mill));
  }

  static int fromString(String date) {
    return DateFormat("yyyy-MM-dd").parse(date).millisecondsSinceEpoch;
  }
}
