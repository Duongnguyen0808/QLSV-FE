import 'package:equatable/equatable.dart';

// Đổi tên các trạng thái để phân biệt giữa đăng nhập và đăng ký
enum AuthStatus { initial, loading, signInSuccess, signUpSuccess, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
