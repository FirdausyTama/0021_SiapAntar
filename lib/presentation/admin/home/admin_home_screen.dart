import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/presentation/admin/home/detail_pesanan_screen.dart';
import 'package:siapantar/presentation/buyer/pemesanan/bloc/pemesanan_bloc.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late PemesananBloc _pemesananBloc;
  
  @override
  void initState() {
    super.initState();
    // Simpan referensi BLoC di initState untuk keamanan
    _pemesananBloc = context.read<PemesananBloc>();
    _pemesananBloc.add(PemesananGetAllEvent());
  }

  // Fungsi untuk memfilter data berdasarkan status
  List<dynamic> _getFilteredData(List<dynamic> data) {
    return data.where((pemesanan) {
      final status = pemesanan.statusPemesanan?.toLowerCase() ?? '';
      // Menghilangkan status 'completed' (selesai) dan 'cancelled' (ditolak)
      return status != 'completed' && status != 'cancelled';
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Pesanan Aktif',
          style: TextStyle(color: AppColors.lightSheet),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.lightSheet),
            onPressed: () {
              if (mounted) {
                _pemesananBloc.add(PemesananGetAllEvent());
              }
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
              bloc: _pemesananBloc, // Gunakan referensi yang disimpan
              listener: (context, state) {
                if (!mounted) return; // Safety check
                
                if (state is PemesananCreateSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pemesanan berhasil dibuat!')),
                  );
                  // Gunakan referensi yang disimpan
                  _pemesananBloc.add(PemesananGetAllEvent());
                }
              },
              child: BlocBuilder<PemesananBloc, PemesananState>(
                bloc: _pemesananBloc, // Gunakan referensi yang disimpan
                builder: (context, state) {
                  if (state is PemesananLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PemesananErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          const Text('Terjadi Kesalahan',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(state.errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (mounted) {
                                _pemesananBloc.add(PemesananGetAllEvent());
                              }
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is PemesananSuccessState) {
                    final allData = state.responseModel.data;
                    // Filter data untuk hanya menampilkan status selain completed dan cancelled
                    final filteredData = _getFilteredData(allData);

                    if (filteredData.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.assignment_outlined, size: 80, color: Colors.grey),
                            const SizedBox(height: 20),
                            const Text('Tidak Ada Pesanan Aktif',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                              'Saat ini tidak ada pesanan yang sedang berlangsung.\nSemua pesanan telah selesai atau dibatalkan.',
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
                        // Status summary cards
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildStatusCard(
                                  'Menunggu',
                                  filteredData.where((p) => p.statusPemesanan == 'pending').length,
                                  Colors.orange,
                                  Icons.access_time,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatusCard(
                                  'Dikonfirmasi',
                                  filteredData.where((p) => p.statusPemesanan == 'confirmed').length,
                                  Colors.green,
                                  Icons.check_circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatusCard(
                                  'Berlangsung',
                                  filteredData.where((p) => p.statusPemesanan == 'on_going').length,
                                  Colors.blue,
                                  Icons.directions_car,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.separated(
                          itemCount: filteredData.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final pemesanan = filteredData[index];
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  // Pastikan widget masih mounted sebelum navigasi
                                  if (!mounted) return;
                                  
                                  try {
                                    // NAVIGASI KE DETAIL SCREEN
                                    final result = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPesananScreen(
                                          pemesanan: pemesanan,
                                        ),
                                      ),
                                    );
                                    
                                    // REFRESH DATA JIKA ADA UPDATE
                                    // Gunakan addPostFrameCallback untuk keamanan maksimal
                                    if (result == true && mounted) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          _pemesananBloc.add(PemesananGetAllEvent());
                                        }
                                      });
                                    }
                                  } catch (e) {
                                    debugPrint('Navigation error: $e');
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Terjadi kesalahan: ${e.toString()}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
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
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Pemesanan #${pemesanan.id}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Colors.grey[400],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 16, color: Colors.green),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              pemesanan.alamatJemput,
                                              style: const TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 16, color: Colors.red),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              pemesanan.alamatAntar,
                                              style: const TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person, size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            pemesanan.sopir.namaSopir,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                          const Spacer(),
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

  // Widget untuk menampilkan summary status
  Widget _buildStatusCard(String title, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
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