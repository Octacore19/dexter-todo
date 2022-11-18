part of 'manage_task_bloc.dart';

class ManageTaskState extends Equatable {
  const ManageTaskState._({
    required this.enableSubmission,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.shift,
    required this.selectedUser,
  });

  factory ManageTaskState.init(Shift shift, User user) => ManageTaskState._(
        enableSubmission: false,
        title: "",
        description: "",
        dateTime: "",
        shift: shift,
        selectedUser: user,
      );

  factory ManageTaskState.updated({
    required bool enableSubmission,
    required String title,
    required String description,
    required String dateTime,
    required Shift shift,
    required User user,
  }) =>
      ManageTaskState._(
        enableSubmission: enableSubmission,
        title: title,
        description: description,
        dateTime: dateTime,
        shift: shift,
        selectedUser: user,
      );

  final bool enableSubmission;
  final String title;
  final String description;
  final String dateTime;
  final Shift shift;
  final User selectedUser;

  @override
  List<Object?> get props => [
        enableSubmission,
        title,
        description,
        dateTime,
        shift,
        selectedUser,
      ];
}
