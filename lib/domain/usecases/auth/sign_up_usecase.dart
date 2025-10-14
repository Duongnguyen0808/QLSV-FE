import 'package:qlsv/data/models/auth/sign_up_request_model.dart';
import 'package:qlsv/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<String> call(SignUpRequestModel request) async {
    return await _repository.signUp(request);
  }
}
