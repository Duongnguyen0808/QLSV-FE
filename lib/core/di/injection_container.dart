import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:qlsv/core/utils/dio_interceptors.dart';
import 'package:qlsv/data/datasources/remote/auth_remote_datasource.dart';
import 'package:qlsv/data/datasources/remote/activity_remote_datasource.dart';
import 'package:qlsv/data/repositories/auth_repository_impl.dart';
import 'package:qlsv/data/repositories/activity_repository_impl.dart';
import 'package:qlsv/domain/repositories/activity/activity_repository.dart';
import 'package:qlsv/domain/repositories/auth/auth_repository.dart';
import 'package:qlsv/domain/usecases/auth/sign_in_usecase.dart';
import 'package:qlsv/domain/usecases/auth/sign_up_usecase.dart';
import 'package:qlsv/domain/usecases/activities/get_all_activities_usecase.dart';
import 'package:qlsv/domain/usecases/activities/register_for_activity_usecase.dart';
import 'package:qlsv/domain/usecases/activities/cancel_registration_usecase.dart';
import 'package:qlsv/domain/usecases/activities/is_user_registered_usecase.dart';
import 'package:qlsv/domain/usecases/activities/get_registered_activities_usecase.dart';
import 'package:qlsv/presentation/features/activities/bloc/activities_cubit.dart';
import 'package:qlsv/presentation/features/activities/bloc/registered_activities_cubit.dart';
import 'package:qlsv/presentation/features/auth/bloc/auth_cubit.dart';
import 'package:qlsv/domain/usecases/auth/get_me_usecase.dart';
import 'package:qlsv/domain/usecases/auth/update_profile_usecase.dart';
import 'package:qlsv/domain/usecases/auth/change_password_usecase.dart';
import 'package:qlsv/domain/usecases/attendance/get_activities_for_attendance_usecase.dart';
import 'package:qlsv/domain/usecases/attendance/get_registrations_for_activity_usecase.dart';
import 'package:qlsv/domain/usecases/attendance/update_bulk_attendance_usecase.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_cubit.dart';
import 'package:qlsv/presentation/features/attendance_check/bloc/attendance_check_detail_cubit.dart';

final sl = GetIt.instance;

void init() {
  // BLoCs
  sl.registerFactory(() => AuthCubit(
        sl<SignInUseCase>(),
        sl<SignUpUseCase>(),
      ));
  sl.registerFactory(() => ActivitiesCubit(sl<GetAllActivitiesUseCase>()));
  sl.registerFactory(
      () => RegisteredActivitiesCubit(sl<GetRegisteredActivitiesUseCase>()));
  sl.registerFactory(
      () => AttendanceCheckCubit(sl<GetActivitiesForAttendanceUseCase>()));
  sl.registerFactory(() => AttendanceCheckDetailCubit(
        sl<GetRegistrationsForActivityUseCase>(),
        sl<UpdateBulkAttendanceUseCase>(),
      ));

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
      () => GetAllActivitiesUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(
      () => RegisterForActivityUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(
      () => CancelRegistrationUsecase(sl<ActivityRepository>()));
  sl.registerLazySingleton(
      () => IsUserRegisteredUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(
      () => GetRegisteredActivitiesUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(() => GetMeUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
      () => GetActivitiesForAttendanceUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(
      () => GetRegistrationsForActivityUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(
      () => UpdateBulkAttendanceUseCase(sl<ActivityRepository>()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()));
  sl.registerLazySingleton<ActivityRepository>(
      () => ActivityRepositoryImpl(sl<ActivityRemoteDataSource>()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl<Dio>()));
  sl.registerLazySingleton<ActivityRemoteDataSource>(
      () => ActivityRemoteDataSource(sl<Dio>()));

  // External
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.interceptors.add(AuthInterceptor());
    return dio;
  });
}
