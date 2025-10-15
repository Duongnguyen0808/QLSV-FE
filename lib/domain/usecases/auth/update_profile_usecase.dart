import 'package:qlsv/domain/entities/user/user_entity.dart';
import 'package:qlsv/domain/repositories/auth/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<UserEntity> call(
      {required String fullName, required String email}) async {
    return await _repository.updateMe(fullName, email);
  }
}
