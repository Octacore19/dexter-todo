part of 'todo_list_bloc.dart';

abstract class TodoListEvents extends Equatable {
  const TodoListEvents();

  @override
  List<Object?> get props => [];
}

class OnFilterDateChanged extends TodoListEvents {
  const OnFilterDateChanged(this.filter);

  final DateFilter filter;

  @override
  List<Object?> get props => [filter];
}

class OnLoadAllTasks extends TodoListEvents {
  const OnLoadAllTasks(this.tasks);

  final List<Task> tasks;

  @override
  List<Object?> get props => [tasks];
}

class OnTaskStatusChanged extends TodoListEvents {
  const OnTaskStatusChanged(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}
