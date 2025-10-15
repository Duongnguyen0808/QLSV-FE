import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qlsv/core/constants/app_colors.dart';
import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_cubit.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_state.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_detail_cubit.dart';
import 'package:qlsv/presentation/features/attendance_check/pages/attendance_check_detail_page.dart';

class AttendanceCheckPage extends StatefulWidget {
  const AttendanceCheckPage({super.key});

  @override
  State<AttendanceCheckPage> createState() => _AttendanceCheckPageState();
}

class _AttendanceCheckPageState extends State<AttendanceCheckPage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceCheckCubit>().fetchActivitiesForAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCheckCubit, AttendanceCheckState>(
      builder: (context, state) {
        if (state.status == AttendanceCheckStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == AttendanceCheckStatus.success) {
          if (state.activities.isEmpty) {
            return const Center(
                child: Text('Không có hoạt động nào cần điểm danh.'));
          }
          return ListView.builder(
            itemCount: state.activities.length,
            itemBuilder: (context, index) {
              final activity = state.activities[index];
              return _buildActivityCard(context, activity);
            },
          );
        } else if (state.status == AttendanceCheckStatus.failure) {
          return Center(child: Text('Lỗi: ${state.errorMessage}'));
        }
        return const Center(child: Text('Chưa có dữ liệu.'));
      },
    );
  }

  Widget _buildActivityCard(BuildContext context, ActivityEntity activity) {
    return InkWell(
      onTap: () {
        // Thêm BlocProvider mới tại đây để cung cấp Cubit cho trang chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<AttendanceCheckDetailCubit>(
              create: (context) => GetIt.I<AttendanceCheckDetailCubit>(),
              child: AttendanceCheckDetailPage(activity: activity),
            ),
          ),
        ).then((_) => context
            .read<AttendanceCheckCubit>()
            .fetchActivitiesForAttendance());
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
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
              Text(
                'Địa điểm: ${activity.location}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                'Người tạo: ${activity.createdByFullName}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Thời gian: ${activity.startTime.toString().substring(0, 10)}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
