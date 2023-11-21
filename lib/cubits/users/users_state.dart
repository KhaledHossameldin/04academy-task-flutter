part of 'users_cubit.dart';

@immutable
sealed class UsersState {
  const UsersState();
}

final class UsersInitial extends UsersState {
  const UsersInitial();
}

final class UsersLoading extends UsersState {
  const UsersLoading();
}

final class UsersLoaded extends UsersState {
  final List<UserData> users;
  const UsersLoaded(this.users);
}

final class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);
}
