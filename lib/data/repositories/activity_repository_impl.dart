import 'package:qlsv/data/datasources/remote/activity_remote_datasource.dart';
import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ActivityEntity>> getAllActivities() async {
    final activityModels = await remoteDataSource.getAllActivities();
    return activityModels
        .map((model) => ActivityEntity(
              id: model.id,
              title: model.title,
              description: model.description,
              imageUrl: model.imageUrl,
              location: model.location,
              status: model.status,
              createdByUsername: model.createdByUsername,
              createdByFullName: model.createdByFullName,
              startTime: model.startTime,
              endTime: model.endTime,
              registrationStartDate: model.registrationStartDate,
              registrationEndDate: model.registrationEndDate,
            ))
        .toList();
  }

  @override
  Future<List<ActivityEntity>> getRegisteredActivities() async {
    final activityModels = await remoteDataSource.getRegisteredActivities();
    return activityModels
        .map((model) => ActivityEntity(
              id: model.id,
              title: model.title,
              description: model.description,
              imageUrl: model.imageUrl,
              location: model.location,
              status: model.status,
              createdByUsername: model.createdByUsername,
              createdByFullName: model.createdByFullName,
              startTime: model.startTime,
              endTime: model.endTime,
              registrationStartDate: model.registrationStartDate,
              registrationEndDate: model.registrationEndDate,
            ))
        .toList();
  }

  @override
  Future<void> registerForActivity(int activityId) {
    return remoteDataSource.registerForActivity(activityId);
  }

  @override
  Future<void> cancelRegistration(int activityId) {
    return remoteDataSource.cancelRegistration(activityId);
  }

  @override
  Future<bool> isUserRegistered(int activityId) {
    return remoteDataSource.isUserRegistered(activityId);
  }
}
