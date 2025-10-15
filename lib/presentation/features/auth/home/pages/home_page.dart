// file: lib/presentation/features/auth/home/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qlsv/core/constants/app_colors.dart';
import 'package:qlsv/domain/entities/user/user_entity.dart';
import 'package:qlsv/presentation/features/activities/pages/activities_page.dart';
import 'package:qlsv/presentation/features/registered_activities/pages/registered_activities_page.dart';
import 'package:qlsv/presentation/features/attendance_check/pages/attendance_check_page.dart';
import 'package:qlsv/presentation/features/profile/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Khởi tạo các danh sách có thể thay đổi
  List<Widget> _pages = [];
  List<BottomNavigationBarItem> _navItems = [];

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    // Khởi tạo danh sách bằng cách sử dụng dấu ngoặc vuông [] thay vì const []
    _pages = [
      const ActivitiesPage(),
      const RegisteredActivitiesPage(),
      const ProfilePage(),
    ];
    _navItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.list_alt),
        label: 'Sự kiện',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.bookmark),
        label: 'Đã đăng ký',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Hồ sơ',
      ),
    ];

    // Thêm tab "Điểm danh" nếu người dùng là giảng viên hoặc admin
    if (widget.user.role == 'LECTURER' || widget.user.role == 'ADMIN') {
      _pages.insert(2, const AttendanceCheckPage());
      _navItems.insert(
        2,
        const BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Điểm danh',
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRƯỜNG ĐẠI HỌC TÀI NGUYÊN VÀ MÔI TRƯỜNG TP. HỒ CHÍ MINH',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
