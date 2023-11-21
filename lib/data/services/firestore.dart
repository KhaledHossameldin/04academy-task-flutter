import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/user_role.dart';
import '../models/user_data.dart';

/// This class handles all Firebase Firestore Database logic only and will not
///  be called anywhere except in the Repository class
class FirestoreService {
  static final instance = FirestoreService._();
  FirestoreService._();

  final _firestore = FirebaseFirestore.instance;
  late final _collection = _firestore.collection('users');

  Future<UserData> getUserData({required String uid}) async {
    final result = await _collection.doc(uid).get();
    if (result.data() == null) {
      throw Exception('User is not found');
    }
    return UserData.fromMap(result.data()!);
  }

  Future<UserData> login({
    required String email,
    required String password,
  }) async {
    final result = await _collection
        .where(Filter.and(Filter('email', isEqualTo: email),
            Filter('password', isEqualTo: password)))
        .get();
    if (result.docs.isEmpty) {
      throw 'There are no accounts with these credentials';
    }
    return UserData.fromMap(result.docs[0].data());
  }

  Future<List<UserData>> getUsers({bool withAdmins = false}) async {
    final result = await _collection
        .where('role', isEqualTo: !withAdmins ? UserRole.user.name : null)
        .get();
    return result.docs.map((user) => UserData.fromMap(user.data())).toList();
  }
}
