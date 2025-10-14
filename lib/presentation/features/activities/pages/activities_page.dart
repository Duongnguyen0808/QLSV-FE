import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlsv/presentation/features/activities/bloc/activities_cubit.dart';
import 'package:qlsv/presentation/features/activities/pages/activity_detail_page.dart';
import 'package:qlsv/presentation/features/activities/widgets/activity_card.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  @override
  void initState() {
    super.initState();
    // Gọi API khi widget được khởi tạo lần đầu tiên
    context.read<ActivitiesCubit>().fetchAllActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ActivitiesCubit, ActivitiesState>(
        builder: (context, state) {
          if (state.status == ActivitiesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ActivitiesStatus.success) {
            if (state.activities.isEmpty) {
              return const Center(
                  child: Text('Không có hoạt động nào đang diễn ra.'));
            }
            return ListView.builder(
              itemCount: state.activities.length,
              itemBuilder: (context, index) {
                final activity = state.activities[index];
                return ActivityCard(
                  activity: activity,
                  onTap: () {
                    // Điều hướng đến trang chi tiết khi thẻ được nhấn
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ActivityDetailPage(activity: activity),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state.status == ActivitiesStatus.failure) {
            return Center(child: Text('Lỗi: ${state.errorMessage}'));
          }
          return const Center(child: Text('Chưa có dữ liệu.'));
        },
      ),
    );
  }
}
