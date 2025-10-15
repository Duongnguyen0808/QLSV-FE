import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/entities/attendance/registration_entity.dart';
import 'package:qlsv/domain/entities/attendance/attendance_update_entity.dart';

abstract class ActivityRepository {
  Future<List<ActivityEntity>> getAllActivities();
  Future<List<ActivityEntity>> getActivitiesForAttendance();
  Future<void> registerForActivity(int activityId);
  Future<void> cancelRegistration(int activityId);
  Future<bool> isUserRegistered(int activityId);
  Future<List<ActivityEntity>> getRegisteredActivities();
  Future<List<RegistrationEntity>> getRegistrationsForActivity(int activityId);
  Future<void> updateBulkAttendance(
      int activityId, List<AttendanceUpdateEntity> updates);
}
