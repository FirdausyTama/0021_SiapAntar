import 'package:flutter/material.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/data/model/response/penyewa/penyewa_profile_response_model.dart';
import 'package:siapantar/presentation/buyer/home/penyewa_home_screen.dart';
import 'package:siapantar/presentation/buyer/penyewa_nav_screen.dart';

class ProfileViewBuyer extends StatelessWidget {
  final Data profile;
  const ProfileViewBuyer({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Profile Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF244475),
                  child: Text(
                    profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Name
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF244475),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Profile Info
                _buildInfoRow(Icons.location_on, profile.address),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.phone, profile.phone),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Home Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.pushAndRemoveUntil(
                  const PenyewaNavScreen(),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF244475),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Kembali ke Beranda",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF244475),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }
}