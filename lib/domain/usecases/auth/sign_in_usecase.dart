import 'package:qlsv/data/models/auth/sign_in_request_model.dart';
import 'package:qlsv/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<String> call(SignInRequestModel request) async {
    return await _repository.signIn(request);
  }
}
