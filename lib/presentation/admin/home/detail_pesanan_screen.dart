import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/data/model/response/penyewa/get_all_pemesanan_response.dart';
import 'package:siapantar/presentation/buyer/pemesanan/bloc/pemesanan_bloc.dart';

class DetailPesananScreen extends StatefulWidget {
  final GetPemesanan pemesanan;
  
  const DetailPesananScreen({
    super.key,
    required this.pemesanan,
  });

  @override
  State<DetailPesananScreen> createState() => _DetailPesananScreenState();
}

class _DetailPesananScreenState extends State<DetailPesananScreen> {
  late GetPemesanan currentPemesanan;
  String? selectedNewStatus;
  bool _isDisposed = false;
  
  @override
  void initState() {
    super.initState();
    currentPemesanan = widget.pemesanan;
  }
  
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Detail Pesanan #${currentPemesanan.id}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {
              _showContactPenyewa();
            },
          ),
        ],
      ),
      body: BlocListener<PemesananBloc, PemesananState>(
        listener: (context, state) {
          if (_isDisposed) return; // Cegah operasi jika widget sudah dispose
          
          if (state is PemesananUpdateStatusSuccessState) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Status pesanan berhasil diupdate'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true); // Return true untuk refresh
            }
          } else if (state is PemesananErrorState) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status & Order ID Card
                _buildOrderStatusCard(),
                
                const SizedBox(height: 16),
                
                // Penyewa Info Card
                _buildPenyewaInfoCard(),
                
                const SizedBox(height: 16),
                
                // Sopir Info Card
                _buildSopirInfoCard(),
                
                const SizedBox(height: 16),
                
                // Schedule & Route Card
                _buildScheduleRouteCard(),
                
                const SizedBox(height: 16),
                
                // Price Card
                _buildPriceCard(),
                
                if (currentPemesanan.deskripsi != null && currentPemesanan.deskripsi!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildNotesCard(),
                ],
                
                const SizedBox(height: 24),
                
                // Admin Action Buttons
                _buildAdminActions(),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    Color statusColor = _getStatusColor(currentPemesanan.statusPemesanan);
    IconData statusIcon = _getStatusIcon(currentPemesanan.statusPemesanan);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withOpacity(0.1),
            statusColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pesanan #${currentPemesanan.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        currentPemesanan.statusText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dibuat: ${_formatDate(currentPemesanan.createdAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (currentPemesanan.statusPemesanan == 'pending')
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notification_important,
                    color: Colors.orange.shade600,
                    size: 20,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPenyewaInfoCard() {
    return _buildInfoCard(
      title: 'Informasi Penyewa',
      icon: Icons.person,
      iconColor: Colors.blue.shade600,
      children: [
        _buildInfoRow(Icons.person, 'Nama Penyewa', currentPemesanan.namaPenyewa),
        const Divider(height: 20),
        _buildInfoRow(Icons.phone, 'No. HP', currentPemesanan.noHp),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _showContactPenyewa();
                },
                icon: const Icon(Icons.phone, size: 20),
                label: const Text('Hubungi Penyewa'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue.shade600,
                  side: BorderSide(color: Colors.blue.shade600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSopirInfoCard() {
    return _buildInfoCard(
      title: 'Informasi Sopir',
      icon: Icons.directions_car,
      iconColor: Colors.green.shade600,
      children: [
        _buildInfoRow(Icons.person, 'Nama Sopir', currentPemesanan.sopir.namaSopir),
        const Divider(height: 20),
        _buildInfoRow(Icons.phone, 'No. HP Sopir', currentPemesanan.sopir.noHp),
        const Divider(height: 20),
        _buildInfoRow(Icons.directions_car, 'Tipe Mobil', currentPemesanan.sopir.tipeMobil),
        if (currentPemesanan.sopir.hargaPerHari != null) ...[
          const Divider(height: 20),
          _buildInfoRow(Icons.attach_money, 'Harga/Hari', _formatCurrency(currentPemesanan.sopir.hargaPerHari!)),
        ],
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.assignment_turned_in, color: Colors.green.shade600, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pastikan sopir sudah siap dan kendaraan dalam kondisi baik',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleRouteCard() {
    return _buildInfoCard(
      title: 'Jadwal & Rute Perjalanan',
      icon: Icons.schedule,
      iconColor: Colors.orange.shade600,
      children: [
        _buildInfoRow(Icons.calendar_today, 'Tanggal Mulai', currentPemesanan.tanggalMulai),
        const Divider(height: 20),
        _buildInfoRow(Icons.calendar_today, 'Tanggal Selesai', currentPemesanan.tanggalSelesai),
        if (currentPemesanan.jamJemput != null) ...[
          const Divider(height: 20),
          _buildInfoRow(Icons.access_time, 'Jam Jemput', currentPemesanan.jamJemput!),
        ],
        if (currentPemesanan.durasiHari != null) ...[
          const Divider(height: 20),
          _buildInfoRow(Icons.timer, 'Durasi', '${currentPemesanan.durasiHari} hari'),
        ],
        const SizedBox(height: 16),
        
        // Alamat Jemput
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Alamat Jemput',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                currentPemesanan.alamatJemput,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Alamat Antar
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Alamat Antar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                currentPemesanan.alamatAntar,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.directions_car, color: Colors.orange.shade600, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Koordinasi dengan sopir 30 menit sebelum jadwal dimulai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard() {
    return _buildInfoCard(
      title: 'Detail Pembayaran',
      icon: Icons.payment,
      iconColor: Colors.purple.shade600,
      children: [
        _buildInfoRow(Icons.directions_car, 'Tipe Mobil', currentPemesanan.tipeMobil),
        const Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.purple.shade600, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Total Harga',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              currentPemesanan.formattedTotalHarga,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.purple.shade600, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pembayaran dilakukan setelah perjalanan selesai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return _buildInfoCard(
      title: 'Catatan Khusus',
      icon: Icons.note,
      iconColor: Colors.teal.shade600,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal.shade200),
          ),
          child: Text(
            currentPemesanan.deskripsi!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminActions() {
    bool canProcess = currentPemesanan.statusPemesanan == 'pending';
    bool inProgress = currentPemesanan.statusPemesanan == 'confirmed';
    bool isCompleted = currentPemesanan.statusPemesanan == 'completed';
    bool isCancelled = currentPemesanan.statusPemesanan == 'cancelled';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Admin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        if (canProcess) ...[
          // Accept and Reject buttons for pending orders
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _updateOrderStatus('confirmed');
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Terima Pesanan',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showRejectDialog();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text(
                    'Tolak Pesanan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        
        if (inProgress) ...[
          // Complete button for confirmed orders
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _updateOrderStatus('completed');
              },
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                'Selesaikan Pesanan',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        
        if (isCompleted || isCancelled) ...[
          // Show completion info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCompleted ? Colors.green.shade200 : Colors.red.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.cancel,
                  color: isCompleted ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isCompleted 
                        ? 'Pesanan telah selesai dikerjakan'
                        : 'Pesanan telah dibatalkan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _updateOrderStatus(String newStatus) {
    if (_isDisposed || !mounted) return;
    
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Konfirmasi"),
          content: Text("Ubah status pesanan menjadi '${_getStatusText(newStatus)}'?"),
          actions: [
            CupertinoDialogAction(
              child: const Text("Batal"),
              onPressed: () {
                if (mounted) Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text("Ya, Update"),
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pop();
                  context.read<PemesananBloc>().add(
                    PemesananUpdateStatusEvent(id: currentPemesanan.id, status: newStatus),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog() {
    if (_isDisposed || !mounted) return;
    
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Tolak Pesanan"),
          content: const Text("Apakah Anda yakin ingin menolak pesanan ini?"),
          actions: [
            CupertinoDialogAction(
              child: const Text("Batal"),
              onPressed: () {
                if (mounted) Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Ya, Tolak"),
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pop();
                  _updateOrderStatus('cancelled');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showContactPenyewa() {
    if (_isDisposed || !mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hubungi ${currentPemesanan.namaPenyewa}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.phone, color: Colors.green.shade600),
                  ),
                  title: const Text('Telepon'),
                  subtitle: Text(currentPemesanan.noHp),
                  onTap: () {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Menghubungi ${currentPemesanan.noHp}...')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.message, color: Colors.blue.shade600),
                  ),
                  title: const Text('WhatsApp'),
                  subtitle: const Text('Chat via WhatsApp'),
                  onTap: () {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka WhatsApp...')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    List<String> monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return "${date.day} ${monthNames[date.month - 1]} ${date.year}";
  }

  String _formatCurrency(String amount) {
    final cleanAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
    final intAmount = int.tryParse(cleanAmount) ?? 0;
    return "Rp ${intAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Status Tidak Diketahui';
    }
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
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
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }
}