import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlsv/domain/entities/attendance/attendance_update_entity.dart';
import 'package:qlsv/domain/usecases/attendance/get_registrations_for_activity_usecase.dart';
import 'package:qlsv/domain/usecases/attendance/update_bulk_attendance_usecase.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_detail_state.dart';

class AttendanceCheckDetailCubit extends Cubit<AttendanceCheckDetailState> {
  final GetRegistrationsForActivityUseCase _getRegistrationsForActivityUseCase;
  final UpdateBulkAttendanceUseCase _updateBulkAttendanceUseCase;

  AttendanceCheckDetailCubit(
    this._getRegistrationsForActivityUseCase,
    this._updateBulkAttendanceUseCase,
  ) : super(const AttendanceCheckDetailState());

  Future<void> fetchRegistrations(int activityId) async {
    emit(state.copyWith(status: AttendanceCheckDetailStatus.loading));
    try {
      final registrations =
          await _getRegistrationsForActivityUseCase(activityId);
      emit(state.copyWith(
          status: AttendanceCheckDetailStatus.success,
          registrations: registrations));
    } catch (e) {
      emit(state.copyWith(
          status: AttendanceCheckDetailStatus.failure,
          errorMessage: e.toString()));
    }
  }

  Future<void> updateBulkAttendance(
      int activityId, List<AttendanceUpdateEntity> updates) async {
    emit(state.copyWith(status: AttendanceCheckDetailStatus.loading));
    try {
      await _updateBulkAttendanceUseCase(activityId, updates);
      // Refresh the list after successful update
      await fetchRegistrations(activityId);
    } catch (e) {
      emit(state.copyWith(
          status: AttendanceCheckDetailStatus.failure,
          errorMessage: e.toString()));
    }
  }
}
