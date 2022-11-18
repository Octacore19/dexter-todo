import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  const UserEntity({
    this.id,
    this.username,
    this.dateCreated,
    this.dateModified,
  });

  final String? id;
  final String? username;
  final FieldValue? dateCreated;
  final FieldValue? dateModified;

  factory UserEntity.fromFirestore(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "username": username,
      "dateCreated": FieldValue.serverTimestamp(),
      "dateModified": FieldValue.serverTimestamp(),
    };
  }

  UserEntity copyWith({
    String? id,
    String? username,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      dateCreated: dateCreated,
      dateModified: FieldValue.serverTimestamp(),
    );
  }
}
