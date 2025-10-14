import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlsv/data/models/auth/sign_in_request_model.dart';
import 'package:qlsv/data/models/auth/sign_up_request_model.dart';
import 'package:qlsv/domain/usecases/auth/sign_in_usecase.dart';
import 'package:qlsv/domain/usecases/auth/sign_up_usecase.dart';
import 'package:qlsv/presentation/features/auth/bloc/auth_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final _storage = const FlutterSecureStorage();

  AuthCubit(this._signInUseCase, this._signUpUseCase)
      : super(const AuthState());

  Future<void> signIn(
      {required String username, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final token = await _signInUseCase(
          SignInRequestModel(username: username, password: password));
      await _storage.write(key: 'jwt_token', value: token);
      emit(state.copyWith(
          status: AuthStatus.success, message: 'Đăng nhập thành công!'));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, message: e.toString()));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final message = await _signUpUseCase(SignUpRequestModel(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
      ));
      emit(state.copyWith(status: AuthStatus.success, message: message));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, message: e.toString()));
    }
  }
}
