import 'package:intl/intl.dart';

String getFormattedDate(DateTime date) {
  return DateFormat('d MMMM yyyy', Intl.systemLocale).format(date);
}
