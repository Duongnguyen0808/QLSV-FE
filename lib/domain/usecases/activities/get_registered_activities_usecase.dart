import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class GetRegisteredActivitiesUseCase {
  final ActivityRepository _repository;

  GetRegisteredActivitiesUseCase(this._repository);

  Future<List<ActivityEntity>> call() async {
    return await _repository.getRegisteredActivities();
  }
}
