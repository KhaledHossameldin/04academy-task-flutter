import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/services/repository.dart';

part 'logout_state.dart';

/// This cubit handles all logout logic only by emitting states which translates
/// in the UI as loading animation and navigating to LoginScreen when the
/// request is done
class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(const LogoutInitial());

  final _repository = Repository.instance;

  Future<void> logout() async {
    try {
      emit(const LogoutLoading());
      await _repository.logout();
      emit(const LogoutLoaded());
    } catch (e) {
      emit(LogoutError('$e'));
    }
  }
}
