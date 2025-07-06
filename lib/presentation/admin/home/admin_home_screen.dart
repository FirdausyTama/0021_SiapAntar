import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/presentation/admin/home/bloc/admin_stats_bloc.dart';
import 'package:siapantar/presentation/admin/home/detail_pesanan_screen.dart';
import 'package:siapantar/presentation/auth/login_screen.dart';
import 'package:siapantar/presentation/buyer/pemesanan/bloc/pemesanan_bloc.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PemesananBloc>().add(PemesananGetAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Pesanan Baru',
          style: TextStyle(color: AppColors.lightSheet),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.lightSheet),
            onPressed: () {
              context.read<PemesananBloc>().add(PemesananGetAllEvent());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.06),
                blurRadius: 10.0,
                blurStyle: BlurStyle.outer,
                offset: const Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocListener<PemesananBloc, PemesananState>(
              listener: (context, state) {
                if (state is PemesananCreateSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pemesanan berhasil dibuat!')),
                  );
                  context.read<PemesananBloc>().add(PemesananGetAllEvent());
                }
              },
              child: BlocBuilder<PemesananBloc, PemesananState>(
                builder: (context, state) {
                  if (state is PemesananLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PemesananErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text('Terjadi Kesalahan',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(state.errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600])),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<PemesananBloc>().add(PemesananGetAllEvent());
                            },
                            child: Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is PemesananSuccessState) {
                    final data = state.responseModel.data;

                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey),
                            SizedBox(height: 20),
                            Text('Belum Ada Pemesanan',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(
                              'Anda belum memiliki pemesanan.\nMulai buat pemesanan pertama Anda!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/adminop.png',
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ListView.separated(
                          itemCount: data.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final pemesanan = data[index];
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  // NAVIGASI KE DETAIL SCREEN
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPesananScreen(
                                        
                                      ),
                                    ),
                                  );
                                  
                                  // REFRESH DATA JIKA ADA UPDATE
                                  if (result == true) {
                                    context.read<PemesananBloc>().add(PemesananGetAllEvent());
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: _getStatusColor(pemesanan.statusPemesanan),
                                            child: Icon(
                                              _getStatusIcon(pemesanan.statusPemesanan),
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Pemesanan #${pemesanan.id}',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                ),
                                                Text(
                                                  pemesanan.tanggalMulai,
                                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(pemesanan.statusPemesanan).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              pemesanan.statusText,
                                              style: TextStyle(
                                                color: _getStatusColor(pemesanan.statusPemesanan),
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Colors.grey[400],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 16, color: Colors.green),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              pemesanan.alamatJemput,
                                              style: TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 16, color: Colors.red),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              pemesanan.alamatAntar,
                                              style: TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.person, size: 14, color: Colors.grey),
                                          SizedBox(width: 4),
                                          Text(
                                            pemesanan.sopir.namaSopir,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                          Spacer(),
                                          if (pemesanan.totalHarga != null)
                                            Text(
                                              pemesanan.formattedTotalHarga,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }

                  return const Center(child: Text('Ada masalah, silakan coba lagi'));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'on_going':
        return Colors.blue;
      case 'completed':
        return Colors.indigo;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.access_time;
      case 'confirmed':
        return Icons.check_circle;
      case 'on_going':
        return Icons.directions_car;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}