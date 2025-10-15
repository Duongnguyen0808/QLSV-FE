import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class GetActivitiesForAttendanceUseCase {
  final ActivityRepository _repository;

  GetActivitiesForAttendanceUseCase(this._repository);

  Future<List<ActivityEntity>> call() async {
    return await _repository.getActivitiesForAttendance();
  }
}
