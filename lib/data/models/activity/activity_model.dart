class ActivityModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final String status;
  final String createdByUsername;
  final String createdByFullName;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime registrationStartDate;
  final DateTime registrationEndDate;

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.status,
    required this.createdByUsername,
    required this.createdByFullName,
    required this.startTime,
    required this.endTime,
    required this.registrationStartDate,
    required this.registrationEndDate,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      createdByUsername: json['createdByUsername'] as String,
      createdByFullName: json['createdByFullName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      registrationStartDate:
          DateTime.parse(json['registrationStartDate'] as String),
      registrationEndDate:
          DateTime.parse(json['registrationEndDate'] as String),
    );
  }
}
