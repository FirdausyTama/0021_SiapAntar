import 'package:flutter/material.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/presentation/buyer/home/history_penyewa_screen.dart';
import 'package:siapantar/presentation/buyer/home/penyewa_home_screen.dart';
import 'package:siapantar/presentation/buyer/home/profil_penyewa_screen.dart';
import 'package:siapantar/presentation/buyer/home/cari_driver_screen.dart';
import 'package:siapantar/presentation/buyer/pemesanan/pesanan_home_screen.dart';

class PenyewaNavScreen extends StatefulWidget {
  const PenyewaNavScreen({super.key});

  @override
  State<PenyewaNavScreen> createState() => _PenyewaNavScreenState();
}

class _PenyewaNavScreenState extends State<PenyewaNavScreen> {
  int _selectedIndex = 0;
  final _widgets = [
    const PenyewaHomeScreen(),
    const SopirsHomeScreen(),
    const PemesananHomeScreen(),
    const ProfilPenyewaScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: _widgets),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              blurStyle: BlurStyle.outer,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
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
              unselectedLabelStyle: const TextStyle(color: AppColors.grey),
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
                    Icons.drive_eta_outlined,
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
      ),
    );
  }
}