import 'package:dexter_todo/data/models/task_entity.dart';
import 'package:dexter_todo/domain/models/patient.dart';
import 'package:dexter_todo/domain/models/shift.dart';
import 'package:dexter_todo/domain/models/task.dart';

abstract class TaskRepo {
  Stream<List<Task>> get tasks;

  List<Shift> get shifts;

  List<Patient> get patients;

  Future<void> addNewTasks(TaskEntity task);

  Future<void> updateTask(Task task);
}