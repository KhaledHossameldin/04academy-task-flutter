import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/services/repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial());

  final repository = Repository.instance;

  Future<void> send({required String title, required String body}) async {
    try {
      emit(const NotificationsLoading());
      await repository.sendNotification(title: title, body: body);
      emit(const NotificationsLoaded());
    } catch (e) {
      emit(NotificationsError('$e'));
    }
  }
}
