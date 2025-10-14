import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/usecases/activities/get_all_activities_usecase.dart';

// States
enum ActivitiesStatus { initial, loading, success, failure }

class ActivitiesState extends Equatable {
  final ActivitiesStatus status;
  final List<ActivityEntity> activities;
  final String? errorMessage;

  const ActivitiesState({
    this.status = ActivitiesStatus.initial,
    this.activities = const [],
    this.errorMessage,
  });

  ActivitiesState copyWith({
    ActivitiesStatus? status,
    List<ActivityEntity>? activities,
    String? errorMessage,
  }) {
    return ActivitiesState(
      status: status ?? this.status,
      activities: activities ?? this.activities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, activities, errorMessage];
}

// Cubit
class ActivitiesCubit extends Cubit<ActivitiesState> {
  final GetAllActivitiesUseCase _getAllActivitiesUseCase;

  ActivitiesCubit(this._getAllActivitiesUseCase)
      : super(const ActivitiesState());

  Future<void> fetchAllActivities() async {
    emit(state.copyWith(status: ActivitiesStatus.loading));
    try {
      final activities = await _getAllActivitiesUseCase();
      emit(state.copyWith(
          status: ActivitiesStatus.success, activities: activities));
    } catch (e) {
      emit(state.copyWith(
          status: ActivitiesStatus.failure, errorMessage: e.toString()));
    }
  }
}
