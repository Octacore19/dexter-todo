import 'package:dexter_todo/domain/models/shift.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({
    required this.title,
    required this.id,
    required this.isCompleted,
    required this.shift,
    required this.dateTime,
    required this.user,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final Shift shift;
  final String dateTime;
  final String user;

  factory Task.empty() {
    return Task(
      title: '',
      id: '',
      isCompleted: false,
      shift: Shift.empty(),
      dateTime: '',
      user: '',
    );
  }

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    Shift? shift,
    String? dateTime,
    String? user,
  }) {
    return Task(
      title: title ?? this.title,
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      shift: shift ?? this.shift,
      dateTime: dateTime ?? this.dateTime,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        isCompleted,
        shift,
        dateTime,
        user,
      ];
}
