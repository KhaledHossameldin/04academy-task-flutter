import 'package:flutter/material.dart';

// This file includes Extensions that are used to add more properties or
// function to existing Flutter objects which makes coding much easier if the
// added code is used very often

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension NumExtension on num {
  SizedBox get emptyHeight => SizedBox(height: toDouble());
  SizedBox get emptyWidth => SizedBox(width: toDouble());
}

extension StringExtension on String {
  void showSnackbar(BuildContext context, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(this),
      backgroundColor: isError ? Colors.red : null,
    ));
  }

  String get authError {
    switch (this) {
      case 'ERROR_WRONG_PASSWORD':
      case 'wrong-password':
        return 'Wrong email/password combination.';
      case 'ERROR_USER_NOT_FOUND':
      case 'user-not-found':
        return 'No user found with this email.';
      case 'ERROR_USER_DISABLED':
      case 'user-disabled':
        return 'User is disabled.';
      case 'ERROR_TOO_MANY_REQUESTS':
      case 'operation-not-allowed':
        return 'Too many requests to log into this account.';
      case 'ERROR_OPERATION_NOT_ALLOWED' || 'operation-not-allowed':
        return 'Server error, please try again later.';
      case 'ERROR_INVALID_EMAIL':
      case 'invalid-email':
        return 'Email address is invalid.';
      default:
        return 'Login failed. Please try again.';
    }
  }
}
