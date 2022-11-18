import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftEntity {
  const ShiftEntity({
    this.id,
    this.type,
    this.startTime,
    this.endTime,
  });

  final String? id;
  final String? type;
  final String? startTime;
  final String? endTime;

  factory ShiftEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final json = snapshot.data();
    return ShiftEntity(
      id: json?['id'],
      type: json?['type'],
      startTime: json?['startTime'],
      endTime: json?['endTime'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "type": type,
      "startTime": startTime,
      "endTime": endTime,
    };
  }
}
