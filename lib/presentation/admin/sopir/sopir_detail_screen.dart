import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/data/model/response/get_all_sopir_response_model.dart';

import 'package:siapantar/presentation/admin/sopir/bloc/sopir_bloc.dart';

import 'package:siapantar/presentation/admin/sopir/sopir_edit_screen.dart';

class SopirDetailScreen extends StatelessWidget {
  final GetSopir data;

  const SopirDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Sopir', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SopirEditPage(sopir: data),
                  ),
                );
              } else if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<SopirBloc, SopirState>(
        listener: (context, state) {
          if (state is SopirDeleteSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Refresh list sebelum kembali
            context.read<SopirBloc>().add(SopirGetAllEvent());
            Navigator.pop(context); // Kembali ke list
          } else if (state is SopirUpdateSuccessState) {
            // Jika ada update dari edit page, refresh juga
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Data sopir berhasil diperbarui')),
            );
            context.read<SopirBloc>().add(SopirGetAllEvent());
          } else if (state is SopirErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto Sopir
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                    image: data.fotoSopir != null && data.fotoSopir!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(data.fotoSopir!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: data.fotoSopir == null || data.fotoSopir!.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.primary,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 24),

              // Status Badge
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: data.statusTersedia
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: data.statusTersedia ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Text(
                    data.statusTersedia ? 'TERSEDIA' : 'TIDAK TERSEDIA',
                    style: TextStyle(
                      color: data.statusTersedia ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Info Cards
              _buildInfoCard('Nama Sopir', data.namaSopir, Icons.person),
              SizedBox(height: 16),
              _buildInfoCard('Nomor HP', data.noHp, Icons.phone),
              SizedBox(height: 16),
              _buildInfoCard('Tipe Mobil', data.tipeMobil, Icons.directions_car),
              SizedBox(height: 16),
              if (data.hargaPerHari != null && data.hargaPerHari!.isNotEmpty)
                _buildInfoCard('Harga Per Hari', 'Rp ${data.hargaPerHari}', Icons.attach_money),
              if (data.hargaPerHari != null && data.hargaPerHari!.isNotEmpty)
                SizedBox(height: 16),
              if (data.deskripsi != null && data.deskripsi!.isNotEmpty)
                _buildInfoCard('Deskripsi', data.deskripsi!, Icons.description),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SopirEditPage(sopir: data),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
                label: Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showDeleteDialog(context),
                icon: Icon(Icons.delete),
                label: Text('Hapus'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus sopir ${data.namaSopir}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<SopirBloc>().add(SopirDeleteEvent(id: data.id));
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}