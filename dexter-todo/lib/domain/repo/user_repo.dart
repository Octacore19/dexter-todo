import 'package:dexter_todo/data/models/user_entity.dart';
import 'package:dexter_todo/domain/models/user.dart';

abstract class UserRepo {
  User get currentUser;

  List<User> get users;

  Future<void> saveUserToFirebase(UserEntity username);
}
