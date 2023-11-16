part of 'notifications_cubit.dart';

@immutable
sealed class NotificationsState {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded();
}

final class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
}
