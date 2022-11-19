import 'package:dexter_todo/data/models/task_entity.dart';
import 'package:dexter_todo/domain/models/patient.dart';
import 'package:dexter_todo/domain/models/shift.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:dexter_todo/domain/models/user.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_task_events.dart';

part 'manage_task_states.dart';

class ManageTasksBloc extends Bloc<ManageTaskEvents, ManageTaskState> {
  ManageTasksBloc({
    required this.taskRepo,
    required this.userRepo,
    this.task,
  }) : super(ManageTaskState.init(
          task?.shift ?? taskRepo.shifts.first,
          (task == null)
              ? userRepo.currentUser
              : userRepo.users.firstWhere(
                  (element) => element.id.trim() == task.user.trim()),
          (task == null)
              ? null
              : taskRepo.patients.firstWhere(
                  (element) => element.id.trim() == task.patient.trim(),
                  orElse: () => Patient.empty()),
          task,
        )) {
    on<OnTaskTitleChanged>(_onTaskTitleChanged);
    on<OnTaskDescriptionChanged>(_onTaskDescriptionChanged);
    on<OnTaskDateTimeSelected>(_onTaskDateTimeSelected);
    on<OnManageTaskSubmitted>(_onManageTaskSubmitted);
    on<OnTaskShiftSelected>(_onTaskShiftSelected);
    on<OnTaskUserSelected>(_onTaskUserSelected);
    on<OnTaskStatusUpdated>(_onTaskStatusUpdated);
    on<OnTaskPatientSelected>(_onTaskPatientSelected);
  }

  final TaskRepo taskRepo;
  final UserRepo userRepo;
  final Task? task;

  void _onTaskTitleChanged(
    OnTaskTitleChanged event,
    Emitter<ManageTaskState> emit,
  ) {
    emit(ManageTaskState.updated(
      enableSubmission: _checkEnabled(title: event.title),
      title: event.title,
      description: state.description,
      dateTime: state.dateTime,
      shift: state.shift,
      user: state.selectedUser,
      isCompleted: state.isCompleted,
      patient: state.patient,
    ));
  }

  void _onTaskDescriptionChanged(
    OnTaskDescriptionChanged event,
    Emitter<ManageTaskState> emit,
  ) {
    emit(ManageTaskState.updated(
      enableSubmission: _checkEnabled(),
      title: state.title,
      description: event.description,
      dateTime: state.dateTime,
      shift: state.shift,
      user: state.selectedUser,
      isCompleted: state.isCompleted,
      patient: state.patient,
    ));
  }

  void _onTaskDateTimeSelected(
    OnTaskDateTimeSelected event,
    Emitter<ManageTaskState> emit,
  ) {
    emit(ManageTaskState.updated(
      enableSubmission: _checkEnabled(dateTime: event.dateTime),
      title: state.title,
      description: state.description,
      dateTime: event.dateTime,
      shift: state.shift,
      user: state.selectedUser,
      isCompleted: state.isCompleted,
      patient: state.patient,
    ));
  }

  void _onTaskShiftSelected(
    OnTaskShiftSelected event,
    Emitter<ManageTaskState> emit,
  ) {
    final shift = taskRepo.shifts
        .firstWhere((element) => element.id.trim() == event.shift.trim());
    emit(ManageTaskState.updated(
      enableSubmission: _checkEnabled(),
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      shift: shift,
      user: state.selectedUser,
      isCompleted: state.isCompleted,
      patient: state.patient,
    ));
  }

  void _onTaskUserSelected(
    OnTaskUserSelected event,
    Emitter<ManageTaskState> emit,
  ) {
    final user = userRepo.users
        .firstWhere((element) => element.id.trim() == event.user.trim());
    emit(ManageTaskState.updated(
      enableSubmission: _checkEnabled(),
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      shift: state.shift,
      user: user,
      isCompleted: state.isCompleted,
      patient: state.patient,
    ));
  }

  void _onTaskStatusUpdated(
    OnTaskStatusUpdated event,
    Emitter<ManageTaskState> emit,
  ) {
    emit(ManageTaskState.updated(
      enableSubmission: _checkEnabled(),
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      shift: state.shift,
      user: state.selectedUser,
      isCompleted: !state.isCompleted,
      patient: state.patient,
    ));
  }

  void _onTaskPatientSelected(
    OnTaskPatientSelected event,
    Emitter<ManageTaskState> emit,
  ) {
    final patient = taskRepo.patients
        .firstWhere((element) => element.id.trim() == event.patient.trim());
    emit(ManageTaskState.updated(
      enableSubmission: _checkEnabled(),
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      shift: state.shift,
      user: state.selectedUser,
      isCompleted: state.isCompleted,
      patient: patient,
    ));
  }

  void _onManageTaskSubmitted(
    OnManageTaskSubmitted event,
    Emitter<ManageTaskState> emit,
  ) async {
    if (!event.editing) {
      final task = TaskEntity.create(
        title: state.title,
        description: state.description,
        dateTime: state.dateTime,
        isCompleted: false,
        shift: state.shift.id,
        user: state.selectedUser.id,
        patient: state.patient.id,
      );
      await taskRepo.addNewTasks(task);
    } else {
      if (task != null) {
        final nTask = task!.copyWith(
          title: state.title,
          description: state.description,
          dateTime: state.dateTime,
          isCompleted: state.isCompleted,
          shift: state.shift,
          user: state.selectedUser.id,
          patient: state.patient.id,
        );
        await taskRepo.updateTask(nTask);
      }
    }
    emit(ManageTaskState.success());
  }

  bool _checkEnabled({
    String? title,
    String? dateTime,
  }) =>
      (title ?? state.title).isNotEmpty &&
      (dateTime ?? state.dateTime).isNotEmpty;
}
