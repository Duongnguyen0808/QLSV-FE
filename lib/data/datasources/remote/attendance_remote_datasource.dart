import 'package:dio/dio.dart';
import 'package:qlsv/core/config/app_config.dart';
import 'package:qlsv/data/models/attendance/attendance_update_request_model.dart';
import 'package:qlsv/data/models/attendance/registration_response_model.dart';

class AttendanceRemoteDataSource {
  final Dio _dio;
  static const String _activitiesEndpoint = 'activities';

  AttendanceRemoteDataSource(this._dio);

  String _getErrorMessage(DioException e) {
    if (e.response != null) {
      if (e.response!.data is String && e.response!.data.isNotEmpty) {
        return e.response!.data;
      } else if (e.response!.data is Map &&
          e.response!.data.containsKey('message')) {
        return e.response!.data['message'];
      }
      return 'Lỗi không xác định từ server với mã trạng thái: ${e.response!.statusCode}';
    }
    return 'Lỗi kết nối mạng hoặc không xác định.';
  }

  Future<List<RegistrationResponseModel>> getRegistrationsForActivity(
      int activityId) async {
    try {
      final response = await _dio.get(
          '${AppConfig.baseUrl}/$_activitiesEndpoint/$activityId/registrations');
      final List<dynamic> data = response.data;
      return data
          .map((json) => RegistrationResponseModel.fromJson(json))
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
        data: request.toJson(),
      );
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
