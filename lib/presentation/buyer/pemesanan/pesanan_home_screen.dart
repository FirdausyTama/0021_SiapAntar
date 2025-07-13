import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/components/spaces.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/presentation/buyer/pemesanan/bloc/pemesanan_bloc.dart';
import 'package:siapantar/presentation/buyer/pemesanan/input_pemesanan_screen.dart';

class PemesananHomeScreen extends StatefulWidget {
  const PemesananHomeScreen({super.key});

  @override
  State<PemesananHomeScreen> createState() => _PemesananHomeScreenState();
}

class _PemesananHomeScreenState extends State<PemesananHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Untuk buyer, mungkin perlu endpoint khusus untuk pemesanan user sendiri
    // Sementara gunakan get all dulu
    context.read<PemesananBloc>().add(PemesananGetAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Pemesanan Saya',
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
                  // Refresh data setelah buat pemesanan baru
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
                          Text(
                            'Terjadi Kesalahan',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
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
                            Text(
                              'Belum Ada Pemesanan',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
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
                        Row(
                          children: [
                            Icon(Icons.assignment, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              "Riwayat Pemesanan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${data.length} Pesanan',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(16.0),
                        
                        // Summary Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                'Menunggu',
                                data.where((p) => p.statusPemesanan == 'pending').length.toString(),
                                Colors.orange,
                                Icons.access_time,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildSummaryCard(
                                'Dikonfirmasi',
                                data.where((p) => p.statusPemesanan == 'confirmed').length.toString(),
                                Colors.green,
                                Icons.check_circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildSummaryCard(
                                'Selesai',
                                data.where((p) => p.statusPemesanan == 'completed').length.toString(),
                                Colors.blue,
                                Icons.done_all,
                              ),
                            ),
                          ],
                        ),
                        
                        const SpaceHeight(20.0),
                        
                        ListView.separated(
                          itemCount: data.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final pemesanan = data[index];
                            return _buildOrderCard(pemesanan);
                          },
                        ),
                      ],
                    );
                  }

                  return const Center(
                    child: Text('Ada masalah, silakan coba lagi'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Order Card - Design yang sama seperti di home screen
  Widget _buildOrderCard(dynamic pemesanan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Tambahkan navigasi ke detail jika diperlukan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detail Pesanan #${pemesanan.id}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor(pemesanan.statusPemesanan).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(pemesanan.statusPemesanan),
                  color: _getStatusColor(pemesanan.statusPemesanan),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Text(
                          'Pesanan #${pemesanan.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(pemesanan.statusPemesanan).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            pemesanan.statusText,
                            style: TextStyle(
                              color: _getStatusColor(pemesanan.statusPemesanan),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Route dengan icon terpisah
                    Column(
                      children: [
                        // Alamat Jemput
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.my_location,
                                size: 12, 
                                color: Colors.green[700],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Jemput: ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                pemesanan.alamatJemput,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        
                        // Alamat Antar
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.location_on,
                                size: 12, 
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tujuan: ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                pemesanan.alamatAntar,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Driver & Price Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 12, 
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          pemesanan.sopir.namaSopir,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        if (pemesanan.totalHarga != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              pemesanan.formattedTotalHarga,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
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
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}