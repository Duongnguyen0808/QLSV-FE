// file: lib/presentation/features/auth/home/pages/home_page.dart
import 'package:flutter/material.dart';
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

  List<Widget> _pages = [];
  List<BottomNavigationBarItem> _navItems = [];

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [];
    _navItems = [];

    _pages.add(const ActivitiesPage());
    _navItems.add(
      const BottomNavigationBarItem(
        icon: Icon(Icons.list_alt),
        label: 'Sự kiện',
      ),
    );

    // Only add "Đã đăng ký" tab for students
    if (widget.user.role == 'STUDENT') {
      _pages.add(const RegisteredActivitiesPage());
      _navItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Đã đăng ký',
        ),
      );
    }

    // Add "Điểm danh" tab for lecturers and admins
    if (widget.user.role == 'LECTURER' || widget.user.role == 'ADMIN') {
      _pages.add(const AttendanceCheckPage());
      _navItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Điểm danh',
        ),
      );
    }

    _pages.add(const ProfilePage());
    _navItems.add(
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Hồ sơ',
      ),
    );
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
