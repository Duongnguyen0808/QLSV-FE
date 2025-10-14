import 'package:qlsv/domain/entities/user/user_entity.dart';

class UserResponseModel {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final String role;
  final bool enabled;
  final bool locked;

  UserResponseModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.role,
    required this.enabled,
    required this.locked,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      enabled: json['enabled'] as bool,
      locked: json['locked'] as bool,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      username: username,
      email: email,
      role: role,
      enabled: enabled,
      locked: locked,
    );
  }
}
