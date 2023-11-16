import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsService {
  static final instance = NotificationsService._();
  NotificationsService._();

  final _firebase = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebase.requestPermission();
    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  void onMessage(RemoteMessage message) {
    log(message.toString(), name: 'onMessage');
  }
}

// This function was not declared inside the class because FirebaseMessaging
// insists that onBackgroundMessage must be declated outside any class it has to
// be a standalone function
Future<void> onBackgroundMessage(RemoteMessage message) async {
  log(message.toString(), name: 'onBackgroundMessage');
}
