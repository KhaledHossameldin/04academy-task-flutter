import 'package:firebase_auth/firebase_auth.dart';

/// This class handles all authentication logic only and will not be called
/// anywhere except in the Repository class
class AuthenticationService {
  static final instance = AuthenticationService._();
  AuthenticationService._();

  final _auth = FirebaseAuth.instance;

  Future<void> logout() async => await _auth.signOut();
}
