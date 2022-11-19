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
    required this.description,
    required this.patient,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final Shift shift;
  final String dateTime;
  final String user;
  final String patient;

  factory Task.empty() {
    return Task(
      title: '',
      id: '',
      description: '',
      isCompleted: false,
      shift: Shift.empty(),
      dateTime: '',
      user: '',
      patient: '',
    );
  }

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    Shift? shift,
    String? dateTime,
    String? user,
    String? description,
    String? patient,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      shift: shift ?? this.shift,
      dateTime: dateTime ?? this.dateTime,
      user: user ?? this.user,
      patient: patient ?? this.patient,
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
        description,
        patient,
      ];
}
