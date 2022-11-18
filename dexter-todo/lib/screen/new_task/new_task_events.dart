part of 'new_task_bloc.dart';

abstract class NewTaskEvents extends Equatable {
  const NewTaskEvents();

  @override
  List<Object?> get props => [];
}

class OnTaskTitleChanged extends NewTaskEvents {
  const OnTaskTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class OnTaskDescriptionChanged extends NewTaskEvents {
  const OnTaskDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

class OnTaskDateTimeSelected extends NewTaskEvents {
  const OnTaskDateTimeSelected(this.dateTime);

  final String dateTime;

  @override
  List<Object?> get props => [dateTime];
}

class OnNewTaskSubmitted extends NewTaskEvents {}
