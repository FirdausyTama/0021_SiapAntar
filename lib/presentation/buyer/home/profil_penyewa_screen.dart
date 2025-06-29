import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siapantar/core/components/spaces.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/presentation/auth/login_screen.dart';

class ProfilPenyewaScreen extends StatefulWidget {
  const ProfilPenyewaScreen({super.key});

  @override
  State<ProfilPenyewaScreen> createState() => _ProfilPenyewaScreenState();
}

class _ProfilPenyewaScreenState extends State<ProfilPenyewaScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            CupertinoDialogAction(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Keluar"),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profil Penyewa',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Section
              Expanded(
                child: Column(
                  children: [
                    const SpaceHeight(30),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      // child: ClipOval(
                      //   child: Image.asset(
                      //     'assets/images/penyewa.png',
                      //     width: 120,
                      //     height: 120,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                    ),
                    const SpaceHeight(10),
                    TextButton(
                      onPressed: () {
                        // Action untuk ubah profil
                      },
                      child: Text(
                        'Ubah Profil',
                        style: TextStyle(color: AppColors.primary, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Logout Button di bawah
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SpaceHeight(20), // Spacing dari bottom
            ],
          ),
        ),
      ),
    );
  }
}