import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qlsv/domain/entities/activity/activity_entity.dart';
import 'package:qlsv/domain/usecases/activities/get_registered_activities_usecase.dart';

enum RegisteredActivitiesStatus { initial, loading, success, failure }

class RegisteredActivitiesState extends Equatable {
  final RegisteredActivitiesStatus status;
  final List<ActivityEntity> activities;
  final String? errorMessage;

  const RegisteredActivitiesState({
    this.status = RegisteredActivitiesStatus.initial,
    this.activities = const [],
    this.errorMessage,
  });

  RegisteredActivitiesState copyWith({
    RegisteredActivitiesStatus? status,
    List<ActivityEntity>? activities,
    String? errorMessage,
  }) {
    return RegisteredActivitiesState(
      status: status ?? this.status,
      activities: activities ?? this.activities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, activities, errorMessage];
}

class RegisteredActivitiesCubit extends Cubit<RegisteredActivitiesState> {
  final GetRegisteredActivitiesUseCase _getRegisteredActivitiesUseCase;

  RegisteredActivitiesCubit(this._getRegisteredActivitiesUseCase)
      : super(const RegisteredActivitiesState());

  Future<void> fetchRegisteredActivities() async {
    emit(state.copyWith(status: RegisteredActivitiesStatus.loading));
    try {
      final activities = await _getRegisteredActivitiesUseCase();
      emit(state.copyWith(
          status: RegisteredActivitiesStatus.success, activities: activities));
    } catch (e) {
      emit(state.copyWith(
          status: RegisteredActivitiesStatus.failure,
          errorMessage: e.toString()));
    }
  }
}
