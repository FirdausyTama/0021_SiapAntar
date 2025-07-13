import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/presentation/buyer/pemesanan/bloc/pemesanan_bloc.dart';

class HistoryPenyewaScreen extends StatefulWidget {
  const HistoryPenyewaScreen({super.key});

  @override
  State<HistoryPenyewaScreen> createState() => _HistoryPenyewaScreenState();
}

class _HistoryPenyewaScreenState extends State<HistoryPenyewaScreen> {
  String selectedFilter = 'Semua'; // Filter default
  
  @override
  void initState() {
    super.initState();
    // Load data pemesanan saat halaman dibuka
    _loadPemesananData();
  }

  // Method untuk load data
  void _loadPemesananData() {
    context.read<PemesananBloc>().add(PemesananGetAllEvent());
  }

  // Method untuk refresh data
  void _refreshData() {
    _loadPemesananData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil diperbarui'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Method untuk filter pesanan berdasarkan status
  List<dynamic> _filterOrders(List<dynamic> orders) {
    if (selectedFilter == 'Semua') {
      return orders;
    }
    
    String filterStatus = '';
    switch (selectedFilter) {
      case 'Menunggu':
        filterStatus = 'pending';
        break;
      case 'Dikonfirmasi':
        filterStatus = 'confirmed';
        break;
      case 'Selesai':
        filterStatus = 'completed';
        break;
      case 'Dibatalkan':
        filterStatus = 'cancelled';
        break;
    }
    
    return orders.where((order) => order.statusPemesanan == filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterSection(),
          Expanded(child: _buildContentSection()),
        ],
      ),
    );
  }

  // AppBar Section
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Riwayat Perjalanan',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
          tooltip: 'Refresh Data',
        ),
      ],
    );
  }

  // Header Section dengan statistik
  Widget _buildHeader() {
    return BlocBuilder<PemesananBloc, PemesananState>(
      builder: (context, state) {
        if (state is PemesananSuccessState) {
          final data = state.responseModel.data;
          return _buildStatsHeader(data);
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Stats Header
  Widget _buildStatsHeader(List<dynamic> orders) {
    final totalOrders = orders.length;
    final pendingOrders = orders.where((o) => o.statusPemesanan == 'pending').length;
    final confirmedOrders = orders.where((o) => o.statusPemesanan == 'confirmed').length;
    final completedOrders = orders.where((o) => o.statusPemesanan == 'completed').length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total Orders
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.assignment, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Total Pesanan: $totalOrders',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats Grid
          Row(
            children: [
              _buildStatItem('Menunggu', pendingOrders, Colors.orange),
              _buildStatItem('Dikonfirmasi', confirmedOrders, Colors.green),
              _buildStatItem('Selesai', completedOrders, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  // Stat Item untuk header
  Widget _buildStatItem(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Section
  Widget _buildFilterSection() {
    final filters = ['Semua', 'Menunggu', 'Dikonfirmasi', 'Selesai', 'Dibatalkan'];
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary.withOpacity(0.1),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
            ),
          );
        },
      ),
    );
  }

  // Content Section
  Widget _buildContentSection() {
    return BlocBuilder<PemesananBloc, PemesananState>(
      builder: (context, state) {
        if (state is PemesananLoadingState) {
          return _buildLoadingState();
        } else if (state is PemesananSuccessState) {
          final allOrders = state.responseModel.data;
          final filteredOrders = _filterOrders(allOrders);
          
          if (filteredOrders.isEmpty) {
            return _buildEmptyState();
          }
          
          return _buildOrdersList(filteredOrders);
        } else if (state is PemesananErrorState) {
          return _buildErrorState(state.errorMessage);
        }
        
        return _buildEmptyState();
      },
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat data...'),
        ],
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              selectedFilter == 'Semua' 
                  ? 'Belum Ada Riwayat'
                  : 'Tidak Ada Pesanan $selectedFilter',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectedFilter == 'Semua'
                  ? 'Riwayat perjalanan Anda akan muncul di sini'
                  : 'Coba pilih filter lain untuk melihat pesanan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Error State
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // Orders List
  Widget _buildOrdersList(List<dynamic> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  // Order Card - Sama seperti di home screen
  Widget _buildOrderCard(dynamic order) {
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
            SnackBar(content: Text('Detail Pesanan #${order.id}')),
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
                  color: _getStatusColor(order.statusPemesanan).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(order.statusPemesanan),
                  color: _getStatusColor(order.statusPemesanan),
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
                          'Pesanan #${order.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.statusPemesanan).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.statusText,
                            style: TextStyle(
                              color: _getStatusColor(order.statusPemesanan),
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
                                order.alamatJemput,
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
                                order.alamatAntar,
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
                          order.sopir.namaSopir,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        if (order.totalHarga != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              order.formattedTotalHarga,
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

  // Helper Methods
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