
import 'package:flutter/material.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/data/model/response/admin_profile_response_model.dart';
import 'package:siapantar/presentation/admin/home/admin_home_screen.dart';
import 'package:siapantar/presentation/admin/home/riwayat/history_admin_screen.dart';
import 'package:siapantar/presentation/admin/home/driver/tambah_driver_screen.dart';
import 'package:siapantar/presentation/admin/profile/pages/admin_profile_screen.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _selectedIndex = 0;
  final _widgets = [
    const AdminHomeScreen(),
    const TambahDriverScreen(),
    const HistoryAdminScreen(),
    const AdminProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgets),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              blurStyle: BlurStyle.outer,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.primary,
            useLegacyColorScheme: false,
            currentIndex: _selectedIndex,
            onTap: (value) => setState(() {
              _selectedIndex = value;
            }),
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(color: AppColors.lightSheet),
            selectedIconTheme: const IconThemeData(color: AppColors.lightSheet),
            unselectedLabelStyle: TextStyle(color: AppColors.grey),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? AppColors.lightSheet
                      : AppColors.grey,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.drive_eta_rounded,
                  color: _selectedIndex == 1
                      ? AppColors.lightSheet
                      : AppColors.grey,
                ),
                label: 'Driver',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                  color: _selectedIndex == 2
                      ? AppColors.lightSheet
                      : AppColors.grey,
                ),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 3
                      ? AppColors.lightSheet
                      : AppColors.grey,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
