import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlsv/core/constants/app_colors.dart';
import 'package:qlsv/domain/entities/activity/activity_entity.dart';

class ActivityCard extends StatelessWidget {
  final ActivityEntity activity;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
  });

  String _formatDateTimeRange(DateTime start, DateTime end) {
    final DateFormat formatter = DateFormat('dd/MM HH:mm');
    return '${formatter.format(start.toLocal())} - ${formatter.format(end.toLocal())}';
  }

  bool _isRegistrationExpired() {
    return activity.registrationEndDate.isBefore(DateTime.now());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return AppColors.secondary;
      case 'FINISHED':
        return AppColors.error;
      case 'PUBLISHED':
        return AppColors.primary;
      case 'DRAFT':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return 'Đang diễn ra';
      case 'FINISHED':
        return 'Đã kết thúc';
      case 'PUBLISHED':
        return 'Đã công bố';
      case 'DRAFT':
        return 'Bản nháp';
      case 'CANCELED':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = _isRegistrationExpired();
    final statusText = _getStatusText(activity.status);
    final statusColor = _getStatusColor(activity.status);

    return InkWell(
      onTap: isExpired ? null : onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                activity.imageUrl,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: AppColors.textSecondary,
                  child: const Center(
                    child:
                        Icon(Icons.image_not_supported, color: AppColors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTimeRange(
                            activity.startTime, activity.endTime),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        activity.location,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isExpired)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Center(
                    child: Text(
                      'Đã hết hạn đăng ký',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
