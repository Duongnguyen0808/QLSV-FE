import 'package:qlsv/domain/repositories/activity/activity_repository.dart';

class CancelRegistrationUsecase {
  final ActivityRepository _repository;

  CancelRegistrationUsecase(this._repository);

  Future<void> call(int activityId) async {
    return await _repository.cancelRegistration(activityId);
  }
}
