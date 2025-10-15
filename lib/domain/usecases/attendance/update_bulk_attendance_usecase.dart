import 'package:qlsv/domain/entities/attendance/attendance_update_entity.dart';
import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class UpdateBulkAttendanceUseCase {
  final ActivityRepository _repository;

  UpdateBulkAttendanceUseCase(this._repository);

  Future<void> call(
      int activityId, List<AttendanceUpdateEntity> updates) async {
    return await _repository.updateBulkAttendance(activityId, updates);
  }
}
