import 'package:dexter_todo/domain/models/shift.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({
    required this.title,
    required this.id,
    required this.isCompleted,
    required this.shift,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final Shift shift;

  factory Task.empty() {
    return Task(
      title: '',
      id: '',
      isCompleted: false,
      shift: Shift.empty(),
    );
  }

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    Shift? shift,
  }) {
    return Task(
      title: title ?? this.title,
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      shift: shift ?? this.shift,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, shift];
}
