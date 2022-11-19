part of 'manage_task_bloc.dart';

abstract class ManageTaskEvents extends Equatable {
  const ManageTaskEvents();

  @override
  List<Object?> get props => [];
}

class OnTaskTitleChanged extends ManageTaskEvents {
  const OnTaskTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class OnTaskDescriptionChanged extends ManageTaskEvents {
  const OnTaskDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

class OnTaskDateTimeSelected extends ManageTaskEvents {
  const OnTaskDateTimeSelected(this.dateTime);

  final String dateTime;

  @override
  List<Object?> get props => [dateTime];
}

class OnTaskShiftSelected extends ManageTaskEvents {
  const OnTaskShiftSelected(this.shift);

  final String shift;

  @override
  List<Object?> get props => [shift];
}

class OnTaskUserSelected extends ManageTaskEvents {
  const OnTaskUserSelected(this.user);

  final String user;

  @override
  List<Object?> get props => [user];
}

class OnTaskStatusUpdated extends ManageTaskEvents {}

class OnTaskPatientSelected extends ManageTaskEvents {
  const OnTaskPatientSelected(this.patient);

  final String patient;

  @override
  List<Object?> get props => [props];
}

class OnManageTaskSubmitted extends ManageTaskEvents {
  const OnManageTaskSubmitted([this.editing = false]);

  final bool editing;

  @override
  List<Object?> get props => [editing];
}
