part of 'logout_cubit.dart';

@immutable
sealed class LogoutState {
  const LogoutState();
}

final class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

final class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

final class LogoutLoaded extends LogoutState {
  const LogoutLoaded();
}

final class LogoutError extends LogoutState {
  final String message;
  const LogoutError(this.message);
}
