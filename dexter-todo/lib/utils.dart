import 'package:dexter_todo/domain/models/date_filter.dart';
import 'package:flutter/material.dart';
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

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
}) async {

  final datePicked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    initialDatePickerMode: DatePickerMode.day,
    firstDate: DateTime(1910),
    lastDate: DateTime.now().add(const Duration(days: 3650)),
  );
  if (datePicked != null) {
    final timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timePicked != null) {
      String fDate = DateFormat('yyyy-MM-dd').format(datePicked);
      String fHour = timePicked.hour.toString().padLeft(2, '0');
      String fMinutes = timePicked.minute.toString().padLeft(2, '0');

      if (timePicked.period.index == 0 && fHour == "12") {
        fHour = "00";
      }
      String fTime = "$fHour:$fMinutes";
      String fDateTime = "$fDate $fTime";
      final picked = DateTime.tryParse(fDateTime);
      return picked;
    }
  }
  return null;
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
          (Map<K, List<E>> map, E element) =>
      map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
