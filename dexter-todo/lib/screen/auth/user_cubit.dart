import 'package:dexter_todo/data/models/user_entity.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.repo})
      : super(const UserState(
          status: Status.pending,
          username: '',
        ));

  final UserRepo repo;

  void onUserNameChanged(String username) {
    emit(UserState(username: username, status: Status.pending));
  }

  void submitUsername() async {
    final user = UserEntity.create(state.username);
    await repo.saveUserToFirebase(user);
    emit(UserState(username: state.username, status: Status.success));
  }
}
