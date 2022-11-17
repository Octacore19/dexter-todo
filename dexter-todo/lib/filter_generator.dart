import 'package:dexter_todo/domain/models/date_filter.dart';
import 'package:intl/intl.dart';

List<DateFilter> generateDateFilters() {
  List<DateFilter> result = List.empty(growable: true);
  for (int i = -2; i <= 2; i++) {
    var date = DateTime.now().add(Duration(days: i));
    result.add(
      DateFilter(
        currentDay: DateFormat('EEE').format(date),
        date: date.day,
        longDateIso: date.toIso8601String(),
        isSelected: i == 0,
      ),
    );
  }
  return result;
}
