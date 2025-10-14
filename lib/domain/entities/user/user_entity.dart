import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final String role;
  final bool enabled;
  final bool locked;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.role,
    required this.enabled,
    required this.locked,
  });

  // New method: Translate role name to Vietnamese
  String getTranslatedRole() {
    switch (role) {
      case 'ADMIN':
        return 'Quản trị viên';
      case 'LECTURER':
        return 'Giảng viên';
      case 'STUDENT':
        return 'Sinh viên';
      default:
        return 'Không xác định';
    }
  }

  @override
  List<Object?> get props =>
      [id, fullName, username, email, role, enabled, locked];
}
