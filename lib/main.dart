import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qlsv/core/di/injection_container.dart' as di;
import 'package:qlsv/presentation/features/activities/bloc/activities_cubit.dart';
import 'package:qlsv/presentation/features/activities/bloc/registered_activities_cubit.dart';
import 'package:qlsv/presentation/features/auth/bloc/auth_cubit.dart';
import 'package:qlsv/presentation/features/auth/pages/sign_in_page.dart';
import 'package:qlsv/core/constants/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Đảm bảo Flutter được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo dữ liệu locale cho tiếng Việt
  await initializeDateFormatting('vi_VN', null);

  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => GetIt.I<ActivitiesCubit>(),
        ),
        BlocProvider(
          create: (context) => GetIt.I<RegisteredActivitiesCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ứng dụng Quản lý Sinh viên',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            labelStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIconColor: AppColors.textSecondary,
            suffixIconColor: AppColors.textSecondary,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SignInPage(),
      ),
    );
  }
}
