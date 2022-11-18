import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  const UserEntity._({
    this.id,
    this.username,
    this.dateCreated,
    this.dateModified,
  });

  final String? id;
  final String? username;
  final FieldValue? dateCreated;
  final FieldValue? dateModified;

  factory UserEntity.create(String username) {
    return UserEntity._(
      id: '',
      username: username,
      dateCreated: FieldValue.serverTimestamp(),
      dateModified: FieldValue.serverTimestamp(),
    );
  }

  factory UserEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final json = snapshot.data();
    return UserEntity._(
      id: json?['id'],
      username: json?['username'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "username": username,
      "dateCreated": dateCreated,
      "dateModified": dateModified,
    };
  }

  UserEntity copyWith({
    String? id,
    String? username,
  }) {
    return UserEntity._(
      id: id ?? this.id,
      username: username ?? this.username,
      dateCreated: dateCreated,
      dateModified: FieldValue.serverTimestamp(),
    );
  }
}
