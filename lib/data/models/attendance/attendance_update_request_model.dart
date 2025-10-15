import 'attendance_update_dto_model.dart';

class AttendanceUpdateRequestModel {
  final List<AttendanceUpdateDtoModel> updates;

  AttendanceUpdateRequestModel({required this.updates});

  Map<String, dynamic> toJson() {
    return {
      'updates': updates.map((update) => update.toJson()).toList(),
    };
  }
}
