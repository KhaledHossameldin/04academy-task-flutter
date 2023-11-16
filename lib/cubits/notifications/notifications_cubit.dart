import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/services/repository.dart';

part 'notifications_state.dart';

/// This cubit handles sending notification logic by emitting states which
/// translates in the UI as loading animation and reverts everything back to
/// normal when the request is done
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial());

  final _repository = Repository.instance;

  Future<void> send({required String title, required String body}) async {
    try {
      emit(const NotificationsLoading());
      await _repository.sendNotification(title: title, body: body);
      emit(const NotificationsLoaded());
    } catch (e) {
      emit(NotificationsError('$e'));
    }
  }
}
