part of 'user_data_cubit.dart';

// These are all the states related to fetching user data request
@immutable
sealed class UserDataState {
  const UserDataState();
}

final class UserDataInitial extends UserDataState {
  const UserDataInitial();
}

final class UserDataLoading extends UserDataState {
  const UserDataLoading();
}

final class UserDataLoaded extends UserDataState {
  final UserData data;
  const UserDataLoaded(this.data);
}

final class UserDataError extends UserDataState {
  final String message;
  const UserDataError(this.message);
}
