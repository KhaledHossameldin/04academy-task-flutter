import '../models/user_data.dart';
import 'auth.dart';
import 'firestore.dart';
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

  // Authentication Services
  Future<void> login({required String email, required String password}) async =>
      await _auth.login(email: email, password: password);

  // Firestore Services
  Future<UserData> getUserData() async {
    final uid = _auth.getUserUid();
    return _firestore.getUserData(uid: uid);
  }

  // Notifications Services
  Future<void> initNotifications() async => await _notifications.init();
}
