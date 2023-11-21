import '../../constants/contracts.dart';
import '../enums/user_role.dart';

/// This class handles all the logic related to user data whether it is parsing,
/// converting it to a string or comparing it to another object easily and many
/// other operations.
class UserData {
  final int id;
  final String email;
  final bool isSuperAdmin;
  final String name;
  final UserRole role;

  UserData({
    required this.id,
    required this.email,
    required this.isSuperAdmin,
    required this.name,
    required this.role,
  });

  UserData copyWith({
    int? id,
    String? email,
    bool? isSuperAdmin,
    String? name,
    UserRole? role,
  }) {
    return UserData(
      id: id ?? this.id,
      email: email ?? this.email,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    final contract = Contracts.instance;
    return UserData(
      id: map[contract.id]?.toInt() ?? 0,
      email: map[contract.email] ?? '',
      isSuperAdmin: map[contract.isSuperAdmin] ?? false,
      name: map[contract.name] ?? '',
      role: (map[contract.role] as String).userRole,
    );
  }

  @override
  String toString() {
    return 'UserData(id: $id, email: $email, isSuperAdmin: $isSuperAdmin, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.id == id &&
        other.email == email &&
        other.isSuperAdmin == isSuperAdmin &&
        other.name == name &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        isSuperAdmin.hashCode ^
        name.hashCode ^
        role.hashCode;
  }
}
