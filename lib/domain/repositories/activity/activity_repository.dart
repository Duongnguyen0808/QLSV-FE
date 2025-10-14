import 'package:qlsv/domain/entities/activity/activity_entity.dart';

abstract class ActivityRepository {
  Future<List<ActivityEntity>> getAllActivities();
  Future<void> registerForActivity(int activityId);
  Future<void> cancelRegistration(int activityId);
  Future<bool> isUserRegistered(int activityId);
  Future<List<ActivityEntity>> getRegisteredActivities();
}
