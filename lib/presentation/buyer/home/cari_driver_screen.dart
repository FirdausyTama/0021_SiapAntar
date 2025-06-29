import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/presentation/auth/login_screen.dart';

class TambahDriverScreen extends StatefulWidget {
  const TambahDriverScreen({super.key});

  @override
  State<TambahDriverScreen> createState() => _PenyewaHomeScreenState();
}

class _PenyewaHomeScreenState extends State<TambahDriverScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cari Driver', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/driver.png',
            ),
                        const SizedBox(height: 900),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    int count,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text(
              count.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(title),
        ),
      ),
    );
  }
}
