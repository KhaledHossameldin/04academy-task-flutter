import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_data.dart';

/// This class handles all Firebase Firestore Database logic only and will not
///  be called anywhere except in the Repository class
class FirestoreService {
  static final instance = FirestoreService._();
  FirestoreService._();

  final _firestore = FirebaseFirestore.instance;

  Future<UserData> getUserData({required String uid}) async {
    final result = await _firestore.collection('users').doc(uid).get();
    if (result.data() == null) {
      throw Exception('User is not found');
    }
    return UserData.fromMap(result.data()!);
  }
}
