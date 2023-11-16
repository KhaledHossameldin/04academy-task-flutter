import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../data/services/repository.dart';
import '../../utilities/extensions.dart';

part 'login_state.dart';

/// This cubit handles all login logic only by emitting states which translates
/// in the UI as login animation and navigating to HomeScreen when the request
/// is done
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  final repository = Repository.instance;

  Future<void> login({required String email, required String password}) async {
    try {
      emit(const LoginLoading());
      await repository.login(email: email, password: password);
      emit(const LoginLoaded());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.code.authError));
    } catch (e) {
      emit(LoginError('$e'));
    }
  }
}
