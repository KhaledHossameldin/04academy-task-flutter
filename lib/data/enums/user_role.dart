// This file handles user role as it is easier in Flutter to work with enums
// instead of String or int so it handles the conversion.
// It is even easier whem combined with extensions.
enum UserRole { admin, user }

extension UserRoleExtension on String {
  UserRole get userRole {
    if (this == 'admin') {
      return UserRole.admin;
    }
    return UserRole.user;
  }
}
