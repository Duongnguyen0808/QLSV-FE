import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlsv/presentation/features/activities/bloc/registered_activities_cubit.dart';
import 'package:qlsv/presentation/features/activities/pages/activity_detail_page.dart';
import 'package:qlsv/presentation/features/activities/widgets/activity_card.dart';

class RegisteredActivitiesPage extends StatefulWidget {
  const RegisteredActivitiesPage({super.key});

  @override
  State<RegisteredActivitiesPage> createState() =>
      _RegisteredActivitiesPageState();
}

class _RegisteredActivitiesPageState extends State<RegisteredActivitiesPage> {
  @override
  void initState() {
    super.initState();
    // Gọi API khi màn hình được khởi tạo
    context.read<RegisteredActivitiesCubit>().fetchRegisteredActivities();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Gọi API khi quay trở lại màn hình
    context.read<RegisteredActivitiesCubit>().fetchRegisteredActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RegisteredActivitiesCubit, RegisteredActivitiesState>(
        builder: (context, state) {
          if (state.status == RegisteredActivitiesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == RegisteredActivitiesStatus.success) {
            if (state.activities.isEmpty) {
              return const Center(
                  child: Text('Bạn chưa đăng ký hoạt động nào.'));
            }
            return ListView.builder(
              itemCount: state.activities.length,
              itemBuilder: (context, index) {
                final activity = state.activities[index];
                return ActivityCard(
                  activity: activity,
                  onTap: () {
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
          } else if (state.status == RegisteredActivitiesStatus.failure) {
            return Center(child: Text('Lỗi: ${state.errorMessage}'));
          }
          return const Center(child: Text('Chưa có dữ liệu.'));
        },
      ),
    );
  }
}
