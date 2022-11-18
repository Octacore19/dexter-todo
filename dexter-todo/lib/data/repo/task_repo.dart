import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_todo/data/models/shift_entity.dart';
import 'package:dexter_todo/data/models/task_entity.dart';
import 'package:dexter_todo/domain/models/shift.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:flutter/foundation.dart';

class TaskRepoImpl implements TaskRepo {
  TaskRepoImpl({
    required this.db,
    required this.userRepo,
  });

  final FirebaseFirestore db;
  final UserRepo userRepo;
  final _shifts = List<Shift>.empty(growable: true);

  @override
  Stream<List<Task>> get tasks => db
          .collection('tasks')
          .withConverter(
            fromFirestore: TaskEntity.fromFirestore,
            toFirestore: (TaskEntity entity, options) => entity.toFirestore(),
          )
          .snapshots()
          .asyncMap(
        (event) async {
          final s = await getAllShifts();
          return event.docs.map(
            (e) {
              final data = e.data();
              final shift = s.firstWhere(
                  (element) => element.id.trim() == data.shift?.trim(),
                  orElse: () => Shift.empty());
              return Task(
                title: data.title ?? '',
                id: data.id ?? '',
                isCompleted: data.isCompleted ?? false,
                shift: shift,
              );
            },
          ).toList();
        },
      );

  @override
  Future<void> addNewTasks(TaskEntity task) async {
    try {
      // final user = userRepo.currentUser;
      final taskRef = db.collection('tasks').doc();
      db.runTransaction((transaction) async {
        transaction.set(taskRef, task.toFirestore(id: taskRef.id));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  List<Shift> get shifts => _shifts;

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
    _shifts.sort((a,b) => a.start.compareTo(b.start));
    return s.toList();
  }
}
