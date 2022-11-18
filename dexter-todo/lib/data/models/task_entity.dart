import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEntity {
  const TaskEntity({
    this.id,
    this.title,
    this.dateTime,
    this.description,
    this.timeAdded,
    this.timeModified,
    this.isCompleted,
    this.shift,
    this.user,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? dateTime;
  final bool? isCompleted;
  final String? shift;
  final String? user;
  final FieldValue? timeAdded;
  final FieldValue? timeModified;

  factory TaskEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final json = snapshot.data();
    return TaskEntity(
      id: json?['id'],
      title: json?['title'],
      description: json?['description'],
      dateTime: json?['dateTime'],
      isCompleted: json?['isCompleted'],
      shift: json?['shift'],
      user: json?['user'],
    );
  }

  Map<String, dynamic> toFirestore({String? id}) {
    return {
      "id": id ?? this.id,
      "title": title,
      "description": description,
      "dateTime": dateTime,
      "isCompleted": isCompleted,
      "shift": shift,
      "user": user,
      "timeAdded": FieldValue.serverTimestamp(),
      "timeModified": FieldValue.serverTimestamp(),
    };
  }
}
