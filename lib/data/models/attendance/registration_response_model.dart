import 'package:qlsv/domain/entities/attendance/registration_entity.dart';

class RegistrationResponseModel {
  final int registrationId;
  final int studentId;
  final String studentUsername;
  final String studentFullName;
  final DateTime registrationTime;
  final String attendanceStatus;

  RegistrationResponseModel({
    required this.registrationId,
    required this.studentId,
    required this.studentUsername,
    required this.studentFullName,
    required this.registrationTime,
    required this.attendanceStatus,
  });

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResponseModel(
      registrationId: json['registrationId'] as int,
      studentId: json['studentId'] as int,
      studentUsername: json['studentUsername'] as String,
      studentFullName: json['studentFullName'] as String,
      registrationTime: DateTime.parse(json['registrationTime'] as String),
      attendanceStatus: json['attendanceStatus'] as String,
    );
  }

  RegistrationEntity toEntity() {
    return RegistrationEntity(
      registrationId: registrationId,
      studentId: studentId,
      studentUsername: studentUsername,
      studentFullName: studentFullName,
      registrationTime: registrationTime,
      attendanceStatus: attendanceStatus,
    );
  }
}
