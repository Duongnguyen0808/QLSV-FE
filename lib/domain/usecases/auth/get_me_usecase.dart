import 'package:qlsv/domain/entities/user/user_entity.dart';
import 'package:qlsv/domain/repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository _repository;

  GetMeUseCase(this._repository);

  Future<UserEntity> call() async {
    return await _repository.getMe();
  }
}
