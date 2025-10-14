import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
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

  const ActivityEntity({
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

  @override
  List<Object?> get props =>
      [id, title, description, imageUrl, location, status];
}
