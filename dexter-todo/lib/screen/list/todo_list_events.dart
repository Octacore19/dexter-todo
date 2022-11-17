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

class OnLoadAllTasks extends TodoListEvents {}
