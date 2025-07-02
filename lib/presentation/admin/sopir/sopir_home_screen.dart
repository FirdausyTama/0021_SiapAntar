import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/components/spaces.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/presentation/admin/home/admin_home_screen.dart';
import 'package:siapantar/presentation/admin/sopir/bloc/sopir_bloc.dart';
import 'package:siapantar/presentation/admin/sopir/form_sopir_screen.dart';
import 'package:siapantar/presentation/admin/sopir/sopir_detail_screen.dart';

class SopirHomeScreen extends StatefulWidget {
  const SopirHomeScreen({super.key});

  @override
  State<SopirHomeScreen> createState() => _SopirHomeScreenState();
}

class _SopirHomeScreenState extends State<SopirHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SopirBloc>().add(SopirGetAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Data Sopir',
          style: TextStyle(color: AppColors.lightSheet),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
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
            child: BlocBuilder<SopirBloc, SopirState>(
              builder: (context, state) {
                if (state is SopirLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SopirErrorState) {
                  return Center(child: Text(state.errorMessage));
                } else if (state is SopirSuccessState) {
                  final data = state.responseModel.data;
                  if (data.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada data sopir'),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Daftar Sopir",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SpaceHeight(16.0),
                      ListView.separated(
                        itemCount: data.length,
                        shrinkWrap: true, // 🟢 penting
                        physics:
                            const NeverScrollableScrollPhysics(), // biar scroll ikut SingleChildScrollView
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final sopir = data[index];
                          return ListTile(
                            onTap: () {
                              context.push(SopirDetailScreen(data: sopir));
                            },
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  (sopir.fotoSopir != null &&
                                      sopir.fotoSopir!.isNotEmpty)
                                  ? NetworkImage(sopir.fotoSopir!)
                                  : AssetImage('assets/images/driver.png') as ImageProvider,
                              backgroundColor: AppColors.lightSheet,
                            ),
                            title: Text(sopir.namaSopir),
                            subtitle: Text(
                              '${sopir.tipeMobil} - ${sopir.noHp}'
                              '${sopir.hargaPerHari != null && sopir.hargaPerHari!.isNotEmpty ? ' - Rp ${sopir.hargaPerHari}' : ''}'
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: sopir.statusTersedia
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                sopir.statusTersedia ? 'Tersedia' : 'Tidak Tersedia',
                                style: TextStyle(
                                  color: sopir.statusTersedia
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'tambah-sopir',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SopirFormPage()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.lightSheet),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}