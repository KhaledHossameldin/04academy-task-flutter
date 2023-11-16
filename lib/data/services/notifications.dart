import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// This class handles all notification logic only and will not be called
/// anywhere except in the Repository class
class NotificationsService {
  static final instance = NotificationsService._();
  NotificationsService._();

  final _firebase = FirebaseMessaging.instance;
  // Local Notifications are added because the default behavior of
  // FirebaseMessaging is not showing any notification to the user while the app
  // is opened. The app must be in the background in order for the notification
  // to be displayed.
  final _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    _initLocal();
    await _initFirebase();
  }

  Future<void> _initFirebase() async {
    await _firebase.requestPermission();
    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  void _initLocal() {
    _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  Future<String> getToken() async {
    final token = await _firebase.getToken();
    if (token == null) {
      throw Exception('No FirebaseMessaging token is saved');
    }
    return token;
  }

  void onMessage(RemoteMessage message) {
    _local.show(
      0,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'local-notifications',
          '04academy_channel',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}

// This function was not declared inside the class because FirebaseMessaging
// insists that onBackgroundMessage must be declated outside any class it has to
// be a standalone function
Future<void> onBackgroundMessage(RemoteMessage message) async {}
