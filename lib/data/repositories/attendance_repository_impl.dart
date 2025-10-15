import 'package:qlsv/domain/entities/attendance/registration_entity.dart';
import 'package:qlsv/domain/entities/attendance/attendance_update_entity.dart';

abstract class AttendanceRepository {
  Future<List<RegistrationEntity>> getRegistrationsForActivity(int activityId);
  Future<void> updateBulkAttendance(
      int activityId, List<AttendanceUpdateEntity> updates);
}
