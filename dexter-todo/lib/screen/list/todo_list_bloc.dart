import 'dart:async';

import 'package:dexter_todo/domain/models/date_filter.dart';
import 'package:dexter_todo/domain/models/shift.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:dexter_todo/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'todo_list_events.dart';

part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvents, TodoListState> {
  TodoListBloc({
    required List<DateFilter> filters,
    required this.taskRepo,
    required UserRepo userRepo,
  }) : super(TodoListState.init(filters)) {
    on<OnFilterDateChanged>(_onDateFilterChanged);
    on<OnLoadAllTasks>(_onLoadAllTasks);
    on<OnTaskStatusChanged>(_onTaskStatusChanged);

    _taskSub = taskRepo.tasks.listen((data) {
      if (data.isNotEmpty) {
        data.removeWhere((element) => element.user != userRepo.currentUser.id);
        _tasks.clear();
        _tasks.addAll(data);
        add(OnLoadAllTasks(data));
      }
    });
    _currentFilter = state.filters.firstWhere((element) => element.isSelected);
  }

  late StreamSubscription _taskSub;
  final TaskRepo taskRepo;
  final List<Task> _tasks = List.empty(growable: true);
  DateFilter? _currentFilter;

  void _onLoadAllTasks(
    OnLoadAllTasks event,
    Emitter<TodoListState> emit,
  ) {
    emit(
      TodoListState.updated(
        filters: state.filters,
        tasks: _filterTasks(event.tasks, _currentFilter),
      ),
    );
  }

  void _onDateFilterChanged(
    OnFilterDateChanged event,
    Emitter<TodoListState> emit,
  ) {
    _currentFilter = event.filter;
    List<DateFilter> filters = state.filters
        .map((e) => e.longDateIso == event.filter.longDateIso
            ? e.copyWith(isSelected: true)
            : e.copyWith(isSelected: false))
        .toList();
    List<Task> oldTasks = List.empty(growable: true);
    for (var tasks in state.tasks.values) {
      oldTasks.addAll(tasks);
    }
    oldTasks.removeWhere((e) => e.id.isEmpty);
    emit(TodoListState.updated(
      filters: filters,
      tasks: _filterTasks(oldTasks, event.filter),
    ));
  }

  void _onTaskStatusChanged(
    OnTaskStatusChanged event,
    Emitter<TodoListState> emit,
  ) {
    List<Task> oldTasks = List.empty(growable: true);
    final oTask = event.task;
    final nTask = oTask.copyWith(isCompleted: !oTask.isCompleted);
    for (var tasks in state.tasks.values) {
      oldTasks.addAll(tasks);
    }
    oldTasks.removeWhere((e) => e.id.isEmpty);
    int index = oldTasks.indexWhere((e) => e.id.trim() == nTask.id.trim());
    oldTasks[index] = nTask;
    emit(
      TodoListState.updated(
        filters: state.filters,
        tasks: _filterTasks(oldTasks, _currentFilter),
      ),
    );
  }

  Map<Shift, List<Task>> _filterTasks([List<Task>? tasks, DateFilter? filter]) {
    List<Task> fTasks = List.empty(growable: true);
    if (filter != null) {
      final format = DateFormat('yyyy-MM-dd');
      final t = tasks == null || tasks.isEmpty ? _tasks : tasks;
      fTasks = t
          .where((element) =>
              format.parse(element.dateTime).millisecondsSinceEpoch ==
              format.parse(filter.longDateIso).millisecondsSinceEpoch)
          .toList();
    }
    final nTasks = fTasks.groupBy((m) => m.shift);
    for (var element in nTasks.keys) {
      final value = nTasks[element]!;
      value.insert(0, Task.empty());
      nTasks[element] = value;
    }
    final sortedTasks = Map.fromEntries(nTasks.entries.toList()
      ..sort((a, b) => a.key.start.compareTo(b.key.start)));
    return sortedTasks;
  }

  @override
  Future<void> close() {
    _taskSub.cancel();
    return super.close();
  }
}
