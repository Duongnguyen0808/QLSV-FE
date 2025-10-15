import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/entities/attendance/attendance_update_entity.dart';
import 'package:qlsv/domain/entities/attendance/registration_entity.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_detail_cubit.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_detail_state.dart';
import 'package:qlsv/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class AttendanceCheckDetailPage extends StatefulWidget {
  final ActivityEntity activity;

  const AttendanceCheckDetailPage({super.key, required this.activity});

  @override
  State<AttendanceCheckDetailPage> createState() =>
      _AttendanceCheckDetailPageState();
}

class _AttendanceCheckDetailPageState extends State<AttendanceCheckDetailPage> {
  final Map<int, String> _updatedStatuses = {};

  @override
  void initState() {
    super.initState();
    context
        .read<AttendanceCheckDetailCubit>()
        .fetchRegistrations(widget.activity.id);
  }

  void _onStatusChanged(int registrationId, String? newStatus) {
    if (newStatus != null) {
      setState(() {
        _updatedStatuses[registrationId] = newStatus;
      });
      _saveChanges();
    }
  }

  void _saveChanges() async {
    final updates = _updatedStatuses.entries
        .map((e) =>
            AttendanceUpdateEntity(registrationId: e.key, newStatus: e.value))
        .toList();
    if (updates.isNotEmpty) {
      await context
          .read<AttendanceCheckDetailCubit>()
          .updateBulkAttendance(widget.activity.id, updates);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.title),
      ),
      body:
          BlocConsumer<AttendanceCheckDetailCubit, AttendanceCheckDetailState>(
        listener: (context, state) {
          if (state.status == AttendanceCheckDetailStatus.success) {
            // Hiển thị thông báo thành công
            Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Cập nhật điểm danh thành công!')),
                ));
            _updatedStatuses.clear();
          } else if (state.status == AttendanceCheckDetailStatus.failure) {
            // Hiển thị thông báo lỗi
            Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: ${state.errorMessage}')),
                ));
          }
        },
        builder: (context, state) {
          if (state.status == AttendanceCheckDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.registrations.isEmpty) {
            return const Center(child: Text('Chưa có sinh viên nào đăng ký.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.registrations.length,
                  itemBuilder: (context, index) {
                    final registration = state.registrations[index];
                    return _buildRegistrationCard(registration);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRegistrationCard(RegistrationEntity registration) {
    final currentStatus = _updatedStatuses[registration.registrationId] ??
        registration.attendanceStatus;

    Color statusColor;
    switch (currentStatus) {
      case 'PRESENT':
        statusColor = Colors.green;
        break;
      case 'ABSENT':
        statusColor = Colors.red;
        break;
      case 'NOT_YET':
      default:
        statusColor = Colors.orange;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: statusColor,
              child: Text(
                _getInitials(registration.studentFullName),
                style: const TextStyle(color: AppColors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    registration.studentFullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Đã đăng ký: ${_formatDateTime(registration.registrationTime)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: currentStatus,
              onChanged: (String? newValue) {
                _onStatusChanged(registration.registrationId, newValue);
              },
              items: <String>['NOT_YET', 'PRESENT', 'ABSENT']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_translateAttendanceStatus(value)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    List<String> parts = fullName.split(' ');
    if (parts.length >= 2) {
      return parts[0][0].toUpperCase() + parts.last[0].toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  String _translateAttendanceStatus(String status) {
    switch (status) {
      case 'NOT_YET':
        return 'Chưa điểm danh';
      case 'PRESENT':
        return 'Có mặt';
      case 'ABSENT':
        return 'Vắng mặt';
      default:
        return status;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm', 'vi_VN');
    return formatter.format(dateTime.toLocal());
  }
}
