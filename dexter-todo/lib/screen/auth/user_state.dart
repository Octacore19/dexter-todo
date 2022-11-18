part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState({
    required this.username,
    required this.status,
  });

  final Status status;

  final String username;

  @override
  List<Object?> get props => [username, status];
}

class UpdatedUserState extends UserState {
  const UpdatedUserState({super.username = '', required super.status});

  @override
  List<Object?> get props => [super.username, super.status];
}

enum Status {
  loading,
  success,
  failure,
  pending,
}
