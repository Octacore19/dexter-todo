import 'package:dexter_todo/data/models/user_entity.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.repo})
      : super(const UpdatedUserState(
          status: Status.pending,
        ));

  final UserRepo repo;

  void onUserNameChanged(String username) {
    emit(UpdatedUserState(username: username, status: Status.pending));
  }

  void submitUsername() async {
    if (state is UpdatedUserState) {
      final user = UserEntity(username: (state as UpdatedUserState).username);
      repo.saveUserToFirebase(user);
    }
  }
}
