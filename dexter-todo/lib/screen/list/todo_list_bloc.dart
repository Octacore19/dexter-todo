import 'dart:async';

import 'package:dexter_todo/domain/models/date_filter.dart';
import 'package:dexter_todo/domain/models/shift.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:dexter_todo/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_list_events.dart';

part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvents, TodoListState> {
  TodoListBloc({
    required List<DateFilter> filters,
    required this.taskRepo,
  }) : super(TodoListState.init(filters)) {
    on<OnFilterDateChanged>(_onDateFilterChanged);
    on<OnLoadAllTasks>(_onLoadAllTasks);

    _taskSub = taskRepo.tasks.listen((data) {
      if (data.isNotEmpty) {
        add(OnLoadAllTasks(data));
      }
    });
  }

  late StreamSubscription _taskSub;
  final TaskRepo taskRepo;

  void _onLoadAllTasks(
    OnLoadAllTasks event,
    Emitter<TodoListState> emit,
  ) {
    final tasks = event.tasks.groupBy((m) => m.shift);
    for (var element in tasks.keys) {
      final value = tasks[element]!;
      value.insert(0, Task.empty());
      tasks[element] = value;
    }
    final sortedTasks = Map.fromEntries(tasks.entries.toList()
      ..sort((a, b) => a.key.start.compareTo(b.key.start)));
    emit(
      TodoListState.updated(
        filters: state.filters,
        tasks: sortedTasks,
      ),
    );
  }

  void _onDateFilterChanged(
    OnFilterDateChanged event,
    Emitter<TodoListState> emit,
  ) {
    DateFilter newFilter = event.filter;
    List<DateFilter> filters = state.filters
        .map((e) => e.longDateIso == newFilter.longDateIso
            ? e.copyWith(isSelected: true)
            : e.copyWith(isSelected: false))
        .toList();
    emit(TodoListState.updated(
      filters: filters,
      tasks: state.tasks,
    ));
  }

  @override
  Future<void> close() {
    _taskSub.cancel();
    return super.close();
  }
}
