// ignore_for_file: unused_field

import 'package:dio/dio.dart';
import 'package:qlsv/core/config/app_config.dart';
import 'package:qlsv/data/models/auth/sign_in_request_model.dart';
import 'package:qlsv/data/models/auth/sign_up_request_model.dart';
import 'package:qlsv/data/models/user/user_response_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  static const String _authEndpoint = 'auth';
  static const String _activitiesEndpoint = 'activities';
  static const String _usersEndpoint = 'users';

  AuthRemoteDataSource(this._dio);

  String _getErrorMessage(DioException e) {
    if (e.response != null) {
      if (e.response!.data is String && e.response!.data.isNotEmpty) {
        return e.response!.data;
      } else if (e.response!.data is Map &&
          e.response!.data.containsKey('message')) {
        return e.response!.data['message'];
      } else if (e.response!.statusCode == 403) {
        return 'Bạn không có quyền truy cập. Vui lòng đăng nhập lại.';
      }
      return 'Lỗi không xác định từ server với mã trạng thái: ${e.response!.statusCode}';
    }
    return 'Lỗi kết nối mạng hoặc không xác định.';
  }

  Future<String> signIn(SignInRequestModel request) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/$_authEndpoint/signin',
        data: request.toJson(),
      );
      // Giả định backend trả về token trong field 'token'
      return response.data['token'];
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<String> signUp(SignUpRequestModel request) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/$_authEndpoint/signup',
        data: request.toJson(),
      );
      return response.data as String;
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // Phương thức mới để lấy thông tin người dùng hiện tại
  Future<UserResponseModel> getMe() async {
    try {
      final response =
          await _dio.get('${AppConfig.baseUrl}/$_usersEndpoint/me');
      return UserResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // Phương thức mới để cập nhật thông tin người dùng
  Future<UserResponseModel> updateMe(String fullName, String email) async {
    try {
      final response = await _dio.put(
        '${AppConfig.baseUrl}/$_usersEndpoint/me',
        data: {'fullName': fullName, 'email': email},
      );
      return UserResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // Phương thức mới để đổi mật khẩu
  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmationPassword) async {
    try {
      await _dio.put(
        '${AppConfig.baseUrl}/$_usersEndpoint/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmationPassword': confirmationPassword
        },
      );
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
