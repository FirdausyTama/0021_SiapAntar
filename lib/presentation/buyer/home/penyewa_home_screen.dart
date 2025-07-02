import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/presentation/auth/login_screen.dart';

class PenyewaHomeScreen extends StatefulWidget {
  const PenyewaHomeScreen({super.key});

  @override
  State<PenyewaHomeScreen> createState() => _PenyewaHomeScreenState();
}

class _PenyewaHomeScreenState extends State<PenyewaHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('Home', style: TextStyle(color: Colors.white)),
      //   centerTitle: true,
      //   backgroundColor: AppColors.primary,
      //   iconTheme: const IconThemeData(color: Colors.white),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/iklan50.png',
            ),
          ],
          
        ),
      ),
    );
  }
}
