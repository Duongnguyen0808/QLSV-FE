import 'package:equatable/equatable.dart';
import 'package:qlsv/domain/entities/activity/activity_entity.dart';

enum AttendanceCheckStatus { initial, loading, success, failure }

class AttendanceCheckState extends Equatable {
  final AttendanceCheckStatus status;
  final List<ActivityEntity> activities;
  final String? errorMessage;

  const AttendanceCheckState({
    this.status = AttendanceCheckStatus.initial,
    this.activities = const [],
    this.errorMessage,
  });

  AttendanceCheckState copyWith({
    AttendanceCheckStatus? status,
    List<ActivityEntity>? activities,
    String? errorMessage,
  }) {
    return AttendanceCheckState(
      status: status ?? this.status,
      activities: activities ?? this.activities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, activities, errorMessage];
}
