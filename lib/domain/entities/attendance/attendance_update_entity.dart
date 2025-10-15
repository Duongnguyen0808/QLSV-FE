import 'package:equatable/equatable.dart';

class AttendanceUpdateEntity extends Equatable {
  final int registrationId;
  final String newStatus;

  const AttendanceUpdateEntity({
    required this.registrationId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [registrationId, newStatus];
}
