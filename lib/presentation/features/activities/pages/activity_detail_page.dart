import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlsv/core/constants/app_colors.dart';
import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/usecases/activities/register_for_activity_usecase.dart';
import 'package:qlsv/domain/usecases/activities/cancel_registration_usecase.dart';
import 'package:qlsv/domain/usecases/activities/is_user_registered_usecase.dart';
import 'package:get_it/get_it.dart';

class ActivityDetailPage extends StatefulWidget {
  final ActivityEntity activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage>
    with RouteAware {
  bool _isRegistered = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkInitialRegistrationStatus();
  }

  void _checkInitialRegistrationStatus() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final isRegistered =
          await GetIt.I<IsUserRegisteredUseCase>()(widget.activity.id);
      if (mounted) {
        setState(() {
          _isRegistered = isRegistered;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
        Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Lỗi kiểm tra trạng thái đăng ký: $_errorMessage')),
            ));
      }
    }
  }

  void _onRegister() async {
    final registerUseCase = GetIt.I<RegisterForActivityUseCase>();
    setState(() {
      _isLoading = true;
    });
    try {
      await registerUseCase(widget.activity.id);
      if (mounted) {
        setState(() {
          _isRegistered = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký hoạt động thành công!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
    }
  }

  void _onCancelRegistration() async {
    final cancelUseCase = GetIt.I<CancelRegistrationUsecase>();
    setState(() {
      _isLoading = true;
    });
    try {
      await cancelUseCase(widget.activity.id);
      if (mounted) {
        setState(() {
          _isRegistered = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hủy đăng ký thành công!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String _formatDateTime(DateTime dateTime) {
      final DateFormat formatter =
          DateFormat('EEEE, dd MMMM yyyy, HH:mm', 'vi_VN');
      return formatter.format(dateTime.toLocal());
    }

    String _translateStatus(String status) {
      switch (status) {
        case 'DRAFT':
          return 'Bản nháp';
        case 'PUBLISHED':
          return 'Đã công bố';
        case 'IN_PROGRESS':
          return 'Đang diễn ra';
        case 'FINISHED':
          return 'Đã kết thúc';
        case 'CANCELED':
          return 'Đã hủy';
        default:
          return status;
      }
    }

    Widget _buildActionButton() {
      // Sửa lỗi: Thêm logic kiểm tra trạng thái IN_PROGRESS và FINISHED
      if (widget.activity.status == 'IN_PROGRESS') {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Hoạt động đang diễn ra',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      if (widget.activity.status == 'FINISHED') {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Hoạt động đã kết thúc',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_isRegistered) {
        return ElevatedButton(
          onPressed: _onCancelRegistration,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Hủy đăng ký'),
        );
      } else {
        return ElevatedButton(
          onPressed: _onRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Đăng ký tham gia'),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.activity.imageUrl,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: AppColors.textSecondary,
                child: const Center(
                  child: Icon(Icons.image_not_supported,
                      size: 50, color: AppColors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Mô tả',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.activity.description,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Thời gian',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Bắt đầu: ${_formatDateTime(widget.activity.startTime)}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Kết thúc: ${_formatDateTime(widget.activity.endTime)}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Địa điểm',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.activity.location,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Thông tin khác',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                      'Trạng thái: ${_translateStatus(widget.activity.status)}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Người tạo: ${widget.activity.createdByFullName}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  Center(child: _buildActionButton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
