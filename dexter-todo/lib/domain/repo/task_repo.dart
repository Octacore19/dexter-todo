import 'package:dexter_todo/data/models/task_entity.dart';
import 'package:dexter_todo/domain/models/shift.dart';
import 'package:dexter_todo/domain/models/task.dart';

abstract class TaskRepo {
  Stream<List<Task>> get tasks;

  List<Shift> get shifts;

  Future<void> addNewTasks(TaskEntity task);
}