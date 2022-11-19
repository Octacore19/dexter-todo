import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_todo/data/models/user_entity.dart';
import 'package:dexter_todo/domain/models/user.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:flutter/foundation.dart';

class UserRepoImpl implements UserRepo {
  UserRepoImpl({required this.db}) {
    _fetchAllUsers();
  }

  final FirebaseFirestore db;

  CollectionReference<UserEntity> get _userRef =>
      db.collection('users').withConverter(
            fromFirestore: UserEntity.fromFirestore,
            toFirestore: (UserEntity entity, options) => entity.toFirestore(),
          );

  User? _user;
  final _users = List<User>.empty(growable: true);

  @override
  User get currentUser => _user ?? const User(id: '', username: '');

  @override
  Future<void> saveUserToFirebase(UserEntity user) async {
    try {
      final res = await _userRef
          .where("username", isEqualTo: user.username?.trim())
          .get();
      if (res.size == 0) {
        final userDocRef = db.collection('users').doc();
        final newUser = await db.runTransaction((transaction) {
          return transaction.get(userDocRef).then((userDoc) {
            transaction.set(userDocRef, user.toFirestore());
            final newUser = user.copyWith(id: userDocRef.id);
            transaction.update(userDocRef, newUser.toFirestore());
            return newUser;
          });
        });
        _user = User(
          id: newUser.id ?? '',
          username: newUser.username ?? '',
        );
      } else {
        final newUser = res.docs.first.data();
        _user = User(
          id: newUser.id ?? '',
          username: newUser.username ?? '',
        );
      }
    } catch (e) {
      debugPrint('Error occurred! => $e');
    }
  }

  @override
  List<User> get users => _users;

  Future<List<User>> _fetchAllUsers() async {
    final res = await _userRef.get();
    _users.clear();
    final s = res.docs.map(
      (e) => User(
        id: e.data().id ?? '',
        username: e.data().username ?? '',
      ),
    );
    _users.addAll(s);
    return s.toList();
  }
}
