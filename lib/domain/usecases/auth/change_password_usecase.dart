import 'package:qlsv/domain/repositories/auth/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
    required String confirmationPassword,
  }) async {
    return await _repository.changePassword(
      currentPassword,
      newPassword,
      confirmationPassword,
    );
  }
}
