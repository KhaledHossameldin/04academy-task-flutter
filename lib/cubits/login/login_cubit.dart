import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../data/models/user_data.dart';
import '../../data/services/repository.dart';

part 'login_state.dart';

/// This cubit handles all login logic only by emitting states which translates
/// in the UI as loading animation and navigating to HomeScreen when the request
/// is done
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  final _repository = Repository.instance;

  // This getter variable gets user data wherever it is needed
  UserData? get userData {
    if (state is! LoginLoaded) {
      return null;
    }
    return (state as LoginLoaded).userData;
  }

  Future<void> login({required String email, required String password}) async {
    try {
      emit(const LoginLoading());
      final data = await _repository.login(email: email, password: password);
      emit(LoginLoaded(data));
    } on FirebaseException catch (e) {
      emit(LoginError(e.message ?? 'Unknown error has occured'));
    } catch (e) {
      emit(LoginError('$e'));
    }
  }
}
