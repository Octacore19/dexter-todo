import 'package:cloud_firestore/cloud_firestore.dart';

class PatientEntity {
  const PatientEntity({
    this.id,
    this.name,
    this.dob,
    this.bloodGroup,
  });

  final String? id;
  final String? name;
  final String? dob;
  final String? bloodGroup;

  factory PatientEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final json = snapshot.data();
    return PatientEntity(
      id: json?['id'],
      name: json?['name'],
      dob: json?['dob'],
      bloodGroup: json?['bloodGroup'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "dob": dob,
      "bloodGroup": bloodGroup,
    };
  }
}
