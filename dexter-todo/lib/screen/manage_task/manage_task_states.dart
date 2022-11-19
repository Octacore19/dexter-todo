part of 'manage_task_bloc.dart';

class ManageTaskState extends Equatable {
  const ManageTaskState._({
    required this.enableSubmission,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.shift,
    required this.selectedUser,
    required this.isCompleted,
    required this.patient,
    required this.success,
  });

  factory ManageTaskState.init(
    Shift shift,
    User user,
    String? date,
    bool? isCompleted,
  ) {
    return ManageTaskState._(
      enableSubmission: false,
      title: "",
      description: "",
      dateTime: date ?? "",
      shift: shift,
      selectedUser: user,
      isCompleted: isCompleted ?? false,
      patient: Patient.empty(),
      success: false,
    );
  }

  factory ManageTaskState.success() {
    return ManageTaskState._(
      enableSubmission: false,
      title: "",
      description: "",
      dateTime: "",
      shift: Shift.empty(),
      selectedUser: const User(username: "", id: ""),
      isCompleted: false,
      patient: Patient.empty(),
      success: true,
    );
  }

  factory ManageTaskState.updated({
    required bool enableSubmission,
    required String title,
    required String description,
    required String dateTime,
    required Shift shift,
    required User user,
    required bool isCompleted,
    required Patient patient,
  }) {
    return ManageTaskState._(
      enableSubmission: enableSubmission,
      title: title,
      description: description,
      dateTime: dateTime,
      shift: shift,
      selectedUser: user,
      isCompleted: isCompleted,
      patient: patient,
      success: false,
    );
  }

  final bool enableSubmission;
  final String title;
  final String description;
  final String dateTime;
  final Shift shift;
  final User selectedUser;
  final bool isCompleted;
  final Patient patient;
  final bool success;

  @override
  List<Object?> get props => [
        enableSubmission,
        title,
        description,
        dateTime,
        shift,
        selectedUser,
        isCompleted,
        patient,
        success,
      ];
}
