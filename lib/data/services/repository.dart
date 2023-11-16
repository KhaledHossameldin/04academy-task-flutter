import 'auth.dart';

/// This class collects all handlers of all services and this class will be the
/// only service class one to be called to handle logic from the screens

/// You will not find any service called from anywhere other than this service

/// It also follows the Singleton design pattern as it in not necessary to
/// declare an object every time it is needed to be used as it only carries
/// references of other services
class Repository {
  static final instance = Repository._();
  Repository._();

  final _auth = AuthenticationService.instance;

  // Authentication Services
  Future<void> login({required String email, required String password}) async =>
      await _auth.login(email: email, password: password);
}
