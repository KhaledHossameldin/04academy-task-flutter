import 'extensions.dart';

class Validators {
  // These two lines follow the Singleton design pattern as Validators will be
  // used across the application in case there is a register screen
  static final instance = Validators._();
  Validators._();

  // This function is used to validate Email Address anywhere in the entire
  // application
  String? email(String? email) {
    if (email.isNullOrEmpty) {
      return 'Muse enter an Email Address';
    }
    // Regular Expression is used to validate the inserted Email Address
    final isValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email!);
    if (!isValid) {
      return 'Must enter a valid Email Address';
    }
    return null;
  }

  // This function is used to validate Password anywhere in the entire
  // application
  String? password(String? password) {
    if (password.isNullOrEmpty) {
      return 'Must enter a Password';
    }
    if (password!.length < 6) {
      return 'Cannot be less than 6 characters';
    }
    // Any level of security for password validation can be added in this
    // function and it will affect every password field in the entire
    // application
    // For example if password needs to include a capital letter
    return null;
  }
}
