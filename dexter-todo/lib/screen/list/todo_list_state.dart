part of 'todo_list_bloc.dart';

abstract class TodoListStates extends Equatable {
  const TodoListStates({
    required this.filters,
    required this.firstShift,
    required this.secondShift,
    required this.thirdShift,
  });

  final List<DateFilter> filters;
  final List<Task> firstShift;
  final List<Task> secondShift;
  final List<Task> thirdShift;

  @override
  List<Object?> get props => [filters];
}

class InitialTodoListState extends TodoListStates {
  const InitialTodoListState({required super.filters})
      : super(
          firstShift: const [],
          secondShift: const [],
          thirdShift: const [],
        );

  @override
  List<Object?> get props => [super.filters];
}

class UpdatedTodoListState extends TodoListStates {
  const UpdatedTodoListState({
    required super.filters,
    required super.firstShift,
    required super.secondShift,
    required super.thirdShift,
  });

  @override
  List<Object?> get props => [
        super.filters,
        super.firstShift,
        super.secondShift,
        super.thirdShift,
      ];
}
