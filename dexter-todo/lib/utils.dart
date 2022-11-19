import 'package:dexter_todo/domain/models/date_filter.dart';
import 'package:dexter_todo/domain/models/modal_item.dart';
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

Future<T?> showOptionsBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<ModalItem> items,
  required ValueChanged<ModalItem> onItemSelected,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
          const Divider(thickness: 1.5),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
              itemBuilder: (_, index) {
                if (index == 0 && items[index].key.isEmpty) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    title: const Text('Create a new option'),
                  );
                }
                return ListTile(
                  onTap: () {
                    onItemSelected(items[index]);
                    Navigator.pop(context);
                  },
                  title: Text(items[index].value),
                );
              },
              separatorBuilder: (_, __) => const Divider(thickness: 1),
              itemCount: items.length,
            ),
          )
        ],
      ),
    ),
  );
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
        <K, List<E>>{},
        (Map<K, List<E>> map, E element) =>
            map..putIfAbsent(keyFunction(element), () => <E>[]).add(element),
      );
}
