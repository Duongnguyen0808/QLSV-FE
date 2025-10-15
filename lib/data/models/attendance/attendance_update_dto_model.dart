class AttendanceUpdateDtoModel {
  final int registrationId;
  final String newStatus;

  AttendanceUpdateDtoModel({
    required this.registrationId,
    required this.newStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'registrationId': registrationId,
      'newStatus': newStatus,
    };
  }
}
