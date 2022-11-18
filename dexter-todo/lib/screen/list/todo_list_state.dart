part of 'todo_list_bloc.dart';

class TodoListState extends Equatable {
  const TodoListState._({
    required this.filters,
    required this.tasks,
  });

  final List<DateFilter> filters;
  final Map<Shift, List<Task>> tasks;

  factory TodoListState.init(List<DateFilter> filters) {
    return TodoListState._(
      filters: filters,
      tasks: const {},
    );
  }

  factory TodoListState.updated({
    required List<DateFilter> filters,
    required Map<Shift, List<Task>> tasks,
  }) {
    return TodoListState._(
      filters: filters,
      tasks: tasks,
    );
  }

  @override
  List<Object?> get props => [filters, tasks];
}
