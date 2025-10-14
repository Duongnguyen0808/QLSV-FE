import 'package:qlsv/data/models/auth/sign_in_request_model.dart';
import 'package:qlsv/data/models/auth/sign_up_request_model.dart';
import 'package:qlsv/domain/entities/user/user_entity.dart';

abstract class AuthRepository {
  Future<String> signIn(SignInRequestModel request);
  Future<String> signUp(SignUpRequestModel request);
  Future<UserEntity> getMe();
  Future<UserEntity> updateMe(String fullName, String email);
  Future<void> changePassword(
      String currentPassword, String newPassword, String confirmationPassword);
}
