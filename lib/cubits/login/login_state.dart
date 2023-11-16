part of 'login_cubit.dart';

// These are all the states related to logging in request
@immutable
sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginLoaded extends LoginState {
  const LoginLoaded();
}

final class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}
