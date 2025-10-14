import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class IsUserRegisteredUseCase {
  final ActivityRepository _repository;

  IsUserRegisteredUseCase(this._repository);

  Future<bool> call(int activityId) async {
    return await _repository.isUserRegistered(activityId);
  }
}
