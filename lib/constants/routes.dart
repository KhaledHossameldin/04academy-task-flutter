// ignore_for_file: constant_identifier_names

/// This class contains all routes used in the entire application
/// This way is way easier to handle sending and receiving data between screens
/// and makes navigating happen with just one line in the screen it self
class Routes {
  static final instance = Routes._();
  Routes._();

  final login = '/login-screen';
  final user = '/user-screen';
  final admin = '/admin-screen';
}
