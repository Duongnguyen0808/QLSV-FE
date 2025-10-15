import 'package:equatable/equatable.dart';

class RegistrationEntity extends Equatable {
  final int registrationId;
  final int studentId;
  final String studentUsername;
  final String studentFullName;
  final DateTime registrationTime;
  final String attendanceStatus;

  const RegistrationEntity({
    required this.registrationId,
    required this.studentId,
    required this.studentUsername,
    required this.studentFullName,
    required this.registrationTime,
    required this.attendanceStatus,
  });

  @override
  List<Object?> get props => [
        registrationId,
        studentId,
        studentUsername,
        studentFullName,
        registrationTime,
        attendanceStatus,
      ];
}
