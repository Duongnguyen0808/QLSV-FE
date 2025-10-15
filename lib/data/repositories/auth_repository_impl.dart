import 'package:qlsv/data/datasources/remote/auth_remote_datasource.dart';
import 'package:qlsv/data/models/auth/sign_in_request_model.dart';
import 'package:qlsv/data/models/auth/sign_up_request_model.dart';
import 'package:qlsv/domain/entities/user/user_entity.dart';
import 'package:qlsv/domain/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> signIn(SignInRequestModel request) {
    return remoteDataSource.signIn(request);
  }

  @override
  Future<String> signUp(SignUpRequestModel request) {
    return remoteDataSource.signUp(request);
  }

  // New methods
  @override
  Future<UserEntity> getMe() async {
    final userModel = await remoteDataSource.getMe();
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> updateMe(String fullName, String email) async {
    final userModel = await remoteDataSource.updateMe(fullName, email);
    return userModel.toEntity();
  }

  @override
  Future<void> changePassword(
      String currentPassword, String newPassword, String confirmationPassword) {
    return remoteDataSource.changePassword(
        currentPassword, newPassword, confirmationPassword);
  }
}
