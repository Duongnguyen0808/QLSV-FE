import 'package:equatable/equatable.dart';
import 'package:qlsv/domain/entities/attendance/registration_entity.dart';

enum AttendanceCheckDetailStatus { initial, loading, success, failure }

class AttendanceCheckDetailState extends Equatable {
  final AttendanceCheckDetailStatus status;
  final List<RegistrationEntity> registrations;
  final String? errorMessage;

  const AttendanceCheckDetailState({
    this.status = AttendanceCheckDetailStatus.initial,
    this.registrations = const [],
    this.errorMessage,
  });

  AttendanceCheckDetailState copyWith({
    AttendanceCheckDetailStatus? status,
    List<RegistrationEntity>? registrations,
    String? errorMessage,
  }) {
    return AttendanceCheckDetailState(
      status: status ?? this.status,
      registrations: registrations ?? this.registrations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, registrations, errorMessage];
}
