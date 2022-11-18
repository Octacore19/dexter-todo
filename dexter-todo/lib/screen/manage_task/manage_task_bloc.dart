import 'package:dexter_todo/data/models/task_entity.dart';
import 'package:dexter_todo/domain/models/shift.dart';
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
  }) : super(ManageTaskState.init(
          taskRepo.shifts.first,
          userRepo.currentUser,
        )) {
    on<OnTaskTitleChanged>(_onTaskTitleChanged);
    on<OnTaskDescriptionChanged>(_onTaskDescriptionChanged);
    on<OnTaskDateTimeSelected>(_onTaskDateTimeSelected);
    on<OnNewTaskSubmitted>(_onNewTaskSubmitted);
    on<OnTaskShiftSelected>(_onTaskShiftSelected);
    on<OnTaskUserSelected>(_onTaskUserSelected);
  }

  final TaskRepo taskRepo;
  final UserRepo userRepo;

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
    ));
  }

  void _onTaskDescriptionChanged(
    OnTaskDescriptionChanged event,
    Emitter<ManageTaskState> emit,
  ) {
    emit(ManageTaskState.updated(
      enableSubmission: state.enableSubmission,
      title: state.title,
      description: event.description,
      dateTime: state.dateTime,
      shift: state.shift,
      user: state.selectedUser,
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
    ));
  }

  void _onTaskShiftSelected(
    OnTaskShiftSelected event,
    Emitter<ManageTaskState> emit,
  ) {
    final shift = taskRepo.shifts
        .firstWhere((element) => element.id.trim() == event.shift);
    emit(ManageTaskState.updated(
      enableSubmission: state.enableSubmission,
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      shift: shift,
      user: state.selectedUser,
    ));
  }

  void _onTaskUserSelected(
    OnTaskUserSelected event,
    Emitter<ManageTaskState> emit,
  ) {
    final user =
        userRepo.users.firstWhere((element) => element.id.trim() == event.user);
    emit(ManageTaskState.updated(
      enableSubmission: state.enableSubmission,
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      shift: state.shift,
      user: user,
    ));
  }

  void _onNewTaskSubmitted(
    OnNewTaskSubmitted event,
    Emitter<ManageTaskState> emit,
  ) async {
    final task = TaskEntity(
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      isCompleted: false,
    );
    await taskRepo.addNewTasks(task);
    emit(ManageTaskState.init(state.shift, state.selectedUser));
  }

  bool _checkEnabled({
    String? title,
    String? dateTime,
  }) =>
      (title ?? state.title).isNotEmpty &&
      (dateTime ?? state.dateTime).isNotEmpty;
}
