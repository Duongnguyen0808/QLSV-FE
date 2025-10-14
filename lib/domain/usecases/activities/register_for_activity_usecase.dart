import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class RegisterForActivityUseCase {
  final ActivityRepository _repository;

  RegisterForActivityUseCase(this._repository);

  Future<void> call(int activityId) async {
    return await _repository.registerForActivity(activityId);
  }
}
