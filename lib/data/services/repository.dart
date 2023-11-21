import '../models/user_data.dart';
import 'auth.dart';
import 'firestore.dart';
import 'network.dart';
import 'notifications.dart';

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
  final _firestore = FirestoreService.instance;
  final _notifications = NotificationsService.instance;
  final _network = NetworkService.instance;

  // Authentication Services
  Future<void> logout() async => await _auth.logout();

  // Firestore Services
  Future<UserData> login({
    required String email,
    required String password,
  }) async =>
      await _firestore.login(email: email, password: password);

  // Notifications Services
  Future<void> initNotifications() async => await _notifications.init();

  // Network Services
  Future<void> sendNotification({
    required String title,
    required String body,
  }) async {
    final token = await _notifications.getToken();
    await _network.sendNotification(token: token, title: title, body: body);
  }
}
