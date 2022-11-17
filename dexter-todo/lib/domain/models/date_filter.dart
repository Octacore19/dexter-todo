import 'package:equatable/equatable.dart';

class DateFilter extends Equatable {
  const DateFilter({
    required this.currentDay,
    required this.date,
    required this.longDateIso,
    this.isSelected = false,
  });

  final bool isSelected;
  final String currentDay;
  final int date;
  final String longDateIso;

  DateFilter copyWith({
    bool? isSelected,
    String? currentDay,
    String? longDateIso,
    int? date,
  }) {
    return DateFilter(
      currentDay: currentDay ?? this.currentDay,
      date: date ?? this.date,
      longDateIso: longDateIso ?? this.longDateIso,
      isSelected: isSelected ?? this.isSelected
    );
  }

  @override
  List<Object?> get props => [
        isSelected,
        date,
        currentDay,
        longDateIso,
      ];

  @override
  String toString() =>
      "DateFilter(\"currentDay\":$currentDay, \"longDateIso\":$longDateIso, \"date\":$date)";
}
