import 'package:qlsv/domain/entities/attendance/registration_entity.dart';
import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class GetRegistrationsForActivityUseCase {
  final ActivityRepository _repository;

  GetRegistrationsForActivityUseCase(this._repository);

  Future<List<RegistrationEntity>> call(int activityId) async {
    return await _repository.getRegistrationsForActivity(activityId);
  }
}
