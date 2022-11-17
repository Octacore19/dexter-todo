import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({
    required this.title,
    required this.id,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final bool isCompleted;

  @override
  List<Object?> get props => [id, title, isCompleted];
}
