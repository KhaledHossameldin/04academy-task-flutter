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

  Future<UserData> login({
    required String email,
    required String password,
  }) async {
    final result = await _firestore
        .collection('users')
        .where(Filter.and(Filter('email', isEqualTo: email),
            Filter('password', isEqualTo: password)))
        .get();
    if (result.docs.isEmpty) {
      throw 'There are no accounts with this email';
    }
    return UserData.fromMap(result.docs[0].data());
  }
}
