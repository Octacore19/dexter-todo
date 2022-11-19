import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_todo/data/models/patient_entity.dart';
import 'package:dexter_todo/data/models/shift_entity.dart';
import 'package:dexter_todo/data/models/task_entity.dart';
import 'package:dexter_todo/domain/models/patient.dart';
import 'package:dexter_todo/domain/models/shift.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:flutter/foundation.dart';

class TaskRepoImpl implements TaskRepo {
  TaskRepoImpl({
    required this.db,
    required this.userRepo,
  }) {
    fetchAllPatients();
  }

  final FirebaseFirestore db;
  final UserRepo userRepo;

  CollectionReference<TaskEntity> get _taskRef =>
      db.collection('tasks').withConverter(
            fromFirestore: TaskEntity.fromFirestore,
            toFirestore: (TaskEntity entity, options) => entity.toFirestore(),
          );

  final _shifts = List<Shift>.empty(growable: true);
  final _patients = List<Patient>.empty(growable: true);

  @override
  Stream<List<Task>> get tasks => _taskRef.snapshots().asyncMap(
        (event) async {
          final s = await getAllShifts();
          return event.docs.map(
            (e) {
              final data = e.data();
              final shift = s.firstWhere(
                (element) => element.id.trim() == data.shift?.trim(),
                orElse: () => Shift.empty(),
              );
              return Task(
                title: data.title ?? '',
                id: data.id ?? '',
                isCompleted: data.isCompleted ?? false,
                shift: shift,
                dateTime: data.dateTime ?? '',
                user: data.user ?? '',
                description: data.description ?? '',
                patient: data.patient ?? '',
              );
            },
          ).toList();
        },
      );

  @override
  Future<void> addNewTasks(TaskEntity task) async {
    try {
      final taskRef = _taskRef.doc();
      db.runTransaction((transaction) async {
        transaction.set(taskRef, task);
        final newTask = task.copyWith(id: taskRef.id);
        transaction.update(taskRef, newTask.toFirestore());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final taskDocRef = _taskRef.doc(task.id);
      await db.runTransaction((transaction) {
        return transaction.get(taskDocRef).then((taskRef) {
          final oldTask = taskRef.data();
          final updatedTask = oldTask?.copyWith(
            id: task.id,
            title: task.title,
            dateTime: task.dateTime,
            description: task.description,
            isCompleted: task.isCompleted,
            shift: task.shift.id,
            user: task.user,
          );
          transaction.update(taskDocRef, updatedTask?.toFirestore() ?? {});
          return updatedTask;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  List<Shift> get shifts => _shifts;

  @override
  List<Patient> get patients => _patients;

  Future<List<Shift>> getAllShifts() async {
    final res = await db
        .collection('shifts')
        .withConverter(
          fromFirestore: ShiftEntity.fromFirestore,
          toFirestore: (ShiftEntity entity, options) => entity.toFirestore(),
        )
        .get();
    _shifts.clear();
    final s = res.docs.map(
      (e) => Shift(
        type: e.data().type ?? '',
        id: e.data().id ?? '',
        start: e.data().startTime ?? '',
      ),
    );
    _shifts.addAll(s);
    _shifts.sort((a, b) => a.start.compareTo(b.start));
    return s.toList();
  }

  Future<List<Patient>> fetchAllPatients() async {
    final res = await db
        .collection('patients')
        .withConverter(
          fromFirestore: PatientEntity.fromFirestore,
          toFirestore: (PatientEntity entity, options) => entity.toFirestore(),
        )
        .get();
    _patients.clear();
    final s = res.docs.map(
      (e) => Patient.create(
        name: e.data().name ?? '',
        id: e.data().id ?? '',
        dob: e.data().dob ?? '',
        bloodGroup: e.data().bloodGroup ?? '',
      ),
    );
    _patients.addAll(s);
    _patients.sort((a, b) => a.name.compareTo(b.name));
    return s.toList();
  }
}
