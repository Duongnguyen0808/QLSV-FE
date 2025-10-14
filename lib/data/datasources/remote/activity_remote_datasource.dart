import 'package:dio/dio.dart';
import 'package:qlsv/core/config/app_config.dart';
import 'package:qlsv/data/models/activity/activity_model.dart';

class ActivityRemoteDataSource {
  final Dio _dio;
  static const String _activitiesEndpoint = 'activities';
  static const String _usersEndpoint = 'users';

  ActivityRemoteDataSource(this._dio);

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

  Future<List<ActivityModel>> getAllActivities() async {
    try {
      final response =
          await _dio.get('${AppConfig.baseUrl}/$_activitiesEndpoint');
      final List<dynamic> data = response.data['content'];
      return data.map((json) => ActivityModel.fromJson(json)).toList();
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // Phương thức mới: lấy danh sách hoạt động đã đăng ký
  Future<List<ActivityModel>> getRegisteredActivities() async {
    try {
      final response = await _dio
          .get('${AppConfig.baseUrl}/$_usersEndpoint/me/registered-activities');
      final List<dynamic> data = response.data;
      return data.map((json) => ActivityModel.fromJson(json)).toList();
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> registerForActivity(int activityId) async {
    try {
      await _dio.post(
          '${AppConfig.baseUrl}/$_activitiesEndpoint/$activityId/register');
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> cancelRegistration(int activityId) async {
    try {
      await _dio.delete(
          '${AppConfig.baseUrl}/$_activitiesEndpoint/$activityId/register');
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<bool> isUserRegistered(int activityId) async {
    try {
      final response = await _dio.get(
          '${AppConfig.baseUrl}/$_activitiesEndpoint/$activityId/is-registered');
      return response.data as bool;
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
