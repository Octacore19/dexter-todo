part of 'user_cubit.dart';

class UserState extends Equatable {
  const UserState({
    required this.username,
    required this.status,
  });

  final Status status;

  final String username;

  @override
  List<Object?> get props => [username, status];
}

enum Status {
  loading,
  success,
  failure,
  pending,
}
