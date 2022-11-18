part of 'new_task_bloc.dart';

class NewTaskState extends Equatable {
  const NewTaskState._({
    required this.enableSubmission,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  factory NewTaskState.init() => const NewTaskState._(
        enableSubmission: false,
        title: "",
        description: "",
        dateTime: "",
      );

  factory NewTaskState.updated({
    required bool enableSubmission,
    required String title,
    required String description,
    required String dateTime,
  }) =>
      NewTaskState._(
        enableSubmission: enableSubmission,
        title: title,
        description: description,
        dateTime: dateTime,
      );

  final bool enableSubmission;
  final String title;
  final String description;
  final String dateTime;

  @override
  List<Object?> get props => [enableSubmission, title, description, dateTime];
}
