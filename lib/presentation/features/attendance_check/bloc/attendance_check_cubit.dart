import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlsv/domain/usecases/attendance/get_activities_for_attendance_usecase.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_state.dart';

class AttendanceCheckCubit extends Cubit<AttendanceCheckState> {
  final GetActivitiesForAttendanceUseCase _getActivitiesForAttendanceUseCase;

  AttendanceCheckCubit(this._getActivitiesForAttendanceUseCase)
      : super(const AttendanceCheckState());

  Future<void> fetchActivitiesForAttendance() async {
    emit(state.copyWith(status: AttendanceCheckStatus.loading));
    try {
      final activities = await _getActivitiesForAttendanceUseCase();
      emit(state.copyWith(
          status: AttendanceCheckStatus.success, activities: activities));
    } catch (e) {
      emit(state.copyWith(
          status: AttendanceCheckStatus.failure, errorMessage: e.toString()));
    }
  }
}
