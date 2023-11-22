import '../../constants/contracts.dart';
import '../enums/user_role.dart';

/// This class handles all the logic related to user data whether it is parsing,
/// converting it to a string or comparing it to another object easily and many
/// other operations.
class UserData {
  final String email;
  final String password;
  final bool isSuperAdmin;
  final String name;
  final UserRole role;

  UserData({
    required this.email,
    required this.password,
    this.isSuperAdmin = false,
    required this.name,
    required this.role,
  });

  UserData copyWith({
    String? email,
    String? password,
    bool? isSuperAdmin,
    String? name,
    UserRole? role,
  }) {
    return UserData(
      email: email ?? this.email,
      password: password ?? this.password,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    final contract = Contracts.instance;
    return UserData(
      password: map[contract.password] ?? '',
      email: map[contract.email] ?? '',
      isSuperAdmin: map[contract.isSuperAdmin] ?? false,
      name: map[contract.name] ?? '',
      role: (map[contract.role] as String).userRole,
    );
  }

  Map<String, dynamic> toMap() {
    final contract = Contracts.instance;
    return {
      contract.email: email,
      contract.password: password,
      contract.isSuperAdmin: isSuperAdmin,
      contract.name: name,
      contract.role: role.name,
    };
  }

  @override
  String toString() {
    return 'UserData(email: $email, password: $password, isSuperAdmin: $isSuperAdmin, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.email == email &&
        other.password == password &&
        other.isSuperAdmin == isSuperAdmin &&
        other.name == name &&
        other.role == role;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        isSuperAdmin.hashCode ^
        name.hashCode ^
        role.hashCode;
  }
}
