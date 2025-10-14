import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class GetAllActivitiesUseCase {
  final ActivityRepository _repository;

  GetAllActivitiesUseCase(this._repository);

  Future<List<ActivityEntity>> call() async {
    return await _repository.getAllActivities();
  }
}
