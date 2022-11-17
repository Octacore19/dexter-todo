import 'package:dexter_todo/domain/models/date_filter.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_list_events.dart';

part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvents, TodoListStates> {
  TodoListBloc({
    required List<DateFilter> filters,
  }) : super(InitialTodoListState(filters: filters)) {
    on<OnFilterDateChanged>(_onDateFilterChanged);
    on<OnLoadAllTasks>(_onLoadAllTasks);

    add(OnLoadAllTasks());
  }

  void _onLoadAllTasks(
    TodoListEvents events,
    Emitter<TodoListStates> emit,
  ) {
    emit(
      UpdatedTodoListState(
        filters: state.filters,
        firstShift: state.firstShift,
        secondShift: state.secondShift,
        thirdShift: state.thirdShift,
      ),
    );
  }

  void _onDateFilterChanged(
    TodoListEvents event,
    Emitter<TodoListStates> emit,
  ) {
    DateFilter newFilter = (event as OnFilterDateChanged).filter;
    List<DateFilter> filters = state.filters
        .map((e) => e.longDateIso == newFilter.longDateIso
            ? e.copyWith(isSelected: true)
            : e.copyWith(isSelected: false))
        .toList();
    emit(UpdatedTodoListState(
      filters: filters,
      firstShift: state.firstShift,
      secondShift: state.secondShift,
      thirdShift: state.thirdShift,
    ));
  }
}
