import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEntity {
  const TaskEntity._({
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

  factory TaskEntity.create({
    required String title,
    required String dateTime,
    required String description,
    required String shift,
    required String user,
    required bool isCompleted,
  }) {
    return TaskEntity._(
      id: '',
      title: title,
      description: description,
      dateTime: dateTime,
      isCompleted: isCompleted,
      shift: shift,
      user: user,
      timeAdded: FieldValue.serverTimestamp(),
      timeModified: FieldValue.serverTimestamp(),
    );
  }

  factory TaskEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final json = snapshot.data();
    return TaskEntity._(
      id: json?['id'],
      title: json?['title'],
      description: json?['description'],
      dateTime: json?['dateTime'],
      isCompleted: json?['isCompleted'],
      shift: json?['shift'],
      user: json?['user'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (dateTime != null) "dateTime": dateTime,
      if (isCompleted != null) "isCompleted": isCompleted,
      if (shift != null) "shift": shift,
      if (user != null) "user": user,
      if (timeAdded != null) "timeAdded": timeAdded,
      if (timeModified != null) "timeModified": timeModified,
    };
  }

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? dateTime,
    bool? isCompleted,
    String? shift,
    String? user,
  }) {
    return TaskEntity._(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeModified: FieldValue.serverTimestamp(),
      timeAdded: timeAdded,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      shift: shift ?? this.shift,
      user: user ?? this.user,
    );
  }
}
