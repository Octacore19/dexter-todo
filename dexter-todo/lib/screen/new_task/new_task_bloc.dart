import 'package:dexter_todo/data/models/task_entity.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_task_events.dart';

part 'new_task_states.dart';

class NewTasksBloc extends Bloc<NewTaskEvents, NewTaskState> {
  NewTasksBloc({required this.repo}) : super(NewTaskState.init()) {
    on<OnTaskTitleChanged>(_onTaskTitleChanged);
    on<OnTaskDescriptionChanged>(_onTaskDescriptionChanged);
    on<OnTaskDateTimeSelected>(_onTaskDateTimeSelected);
    on<OnNewTaskSubmitted>(_onNewTaskSubmitted);
  }

  final TaskRepo repo;

  void _onTaskTitleChanged(
    OnTaskTitleChanged event,
    Emitter<NewTaskState> emit,
  ) {
    emit(NewTaskState.updated(
      enableSubmission: _checkEnabled(title: event.title),
      title: event.title,
      description: state.description,
      dateTime: state.dateTime,
    ));
  }

  void _onTaskDescriptionChanged(
    OnTaskDescriptionChanged event,
    Emitter<NewTaskState> emit,
  ) {
    emit(NewTaskState.updated(
      enableSubmission: state.enableSubmission,
      title: state.title,
      description: event.description,
      dateTime: state.dateTime,
    ));
  }

  void _onTaskDateTimeSelected(
    OnTaskDateTimeSelected event,
    Emitter<NewTaskState> emit,
  ) {
    emit(NewTaskState.updated(
      enableSubmission: _checkEnabled(dateTime: event.dateTime),
      title: state.title,
      description: state.description,
      dateTime: event.dateTime,
    ));
  }

  void _onNewTaskSubmitted(
    OnNewTaskSubmitted event,
    Emitter<NewTaskState> emit,
  ) async {
    final task = TaskEntity(
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      isCompleted: false,
    );
    await repo.addNewTasks(task);
    emit(NewTaskState.init());
  }

  bool _checkEnabled({
    String? title,
    String? dateTime,
  }) => (title ?? state.title).isNotEmpty && (dateTime ?? state.dateTime).isNotEmpty;
}
