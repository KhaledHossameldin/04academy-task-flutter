import '../../constants/contracts.dart';
import '../enums/user_role.dart';

/// This class handles all the logic related to user data whether it is parsing,
/// converting it to a string or comparing it to another object easily and many
/// other operations.
class UserData {
  final String name;
  final UserRole role;

  UserData({required this.name, required this.role});

  UserData copyWith({String? name, UserRole? role}) =>
      UserData(name: name ?? this.name, role: role ?? this.role);

  factory UserData.fromMap(Map<String, dynamic> map) {
    final contracts = Contracts.instance;
    return UserData(
      name: map[contracts.name] ?? '',
      role: (map[contracts.role] as String).userRole,
    );
  }

  @override
  String toString() => 'UserData(name: $name, role: $role)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData && other.name == name && other.role == role;
  }

  @override
  int get hashCode => name.hashCode ^ role.hashCode;
}
