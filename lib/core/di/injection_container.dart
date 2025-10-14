import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:qlsv/core/utils/dio_interceptors.dart';
import 'package:qlsv/data/datasources/remote/auth_remote_datasource.dart';
import 'package:qlsv/data/datasources/remote/activity_remote_datasource.dart';
import 'package:qlsv/data/repositories/auth_repository_impl.dart';
import 'package:qlsv/data/repositories/activity_repository_impl.dart';
import 'package:qlsv/domain/repositories/auth_repository.dart';
import 'package:qlsv/domain/repositories/activity/activity_repository.dart';
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

// Import các file Use Case mới
import 'package:qlsv/domain/usecases/auth/get_me_usecase.dart';
import 'package:qlsv/domain/usecases/auth/update_profile_usecase.dart';
import 'package:qlsv/domain/usecases/auth/change_password_usecase.dart';

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
  // Thêm các use case cho profile
  sl.registerLazySingleton(() => GetMeUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl<AuthRepository>()));

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
