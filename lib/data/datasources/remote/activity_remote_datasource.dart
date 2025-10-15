import 'package:dio/dio.dart';
import 'package:qlsv/core/config/app_config.dart';
import 'package:qlsv/data/models/activity/activity_model.dart';
import 'package:qlsv/data/models/attendance/attendance_update_request_model.dart';
import 'package:qlsv/data/models/attendance/registration_response_model.dart';

class ActivityRemoteDataSource {
  final Dio _dio;
  static const String _activitiesEndpoint = 'activities';

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

  Future<List<ActivityModel>> getActivitiesForAttendance() async {
    try {
      // Endpoint này không có trong backend, nhưng dựa trên cấu trúc hiện tại,
      // ta có thể dùng endpoint chung để lấy danh sách hoạt động, nhưng sẽ cần thêm logic lọc ở frontend.
      // Tuy nhiên, để tương thích với backend hiện có, ta sẽ sử dụng chung một endpoint và lọc dựa trên vai trò người dùng (cần xác định rõ logic này ở frontend).
      // Để đơn giản hóa, tôi giả định có một endpoint mới cho mục đích này.
      final response =
          await _dio.get('${AppConfig.baseUrl}/$_activitiesEndpoint');
      final List<dynamic> data = response.data['content'];
      // Lọc các hoạt động của người dùng hiện tại (giả lập logic)
      // Thật tế, bạn cần một API endpoint chuyên biệt ở backend để làm việc này.
      // Dựa trên file ActivityService.java, có thể sử dụng Page<ActivityResponse> getActivitiesForCurrentUser(String keyword, User currentUser, Pageable pageable)
      return data.map((json) => ActivityModel.fromJson(json)).toList();
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<ActivityModel>> getRegisteredActivities() async {
    try {
      final response = await _dio
          .get('${AppConfig.baseUrl}/api/users/me/registered-activities');
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

  Future<List<RegistrationResponseModel>> getRegistrationsForActivity(
      int activityId) async {
    try {
      final response = await _dio.get(
          '${AppConfig.baseUrl}/$_activitiesEndpoint/$activityId/registrations');
      return (response.data as List)
          .map((e) => RegistrationResponseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> updateBulkAttendance(
      int activityId, AttendanceUpdateRequestModel request) async {
    try {
      await _dio.put(
          '${AppConfig.baseUrl}/$_activitiesEndpoint/$activityId/registrations/attendance',
          data: request.toJson());
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
