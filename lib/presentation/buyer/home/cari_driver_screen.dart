import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/components/spaces.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/presentation/admin/sopir/bloc/sopir_bloc.dart';
import 'package:siapantar/presentation/buyer/pemesanan/input_pemesanan_screen.dart';

class SopirsHomeScreen extends StatefulWidget {
  const SopirsHomeScreen({super.key});

  @override
  State<SopirsHomeScreen> createState() => _SopirHomeScreenState();
}

class _SopirHomeScreenState extends State<SopirsHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SopirBloc>().add(SopirGetAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Cari Sopir',
          style: TextStyle(color: AppColors.lightSheet),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<SopirBloc, SopirState>(
          builder: (context, state) {
            if (state is SopirLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SopirErrorState) {
              return Center(child: Text(state.errorMessage));
            } else if (state is SopirSuccessState) {
              final data = state.responseModel.data;
              if (data.isEmpty) {
                return const Center(child: Text('Tidak ada data sopir'));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/driver.png'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: Text(
                      "Daftar Sopir",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final sopir = data[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image(
                                      image: (sopir.fotoSopir != null &&
                                              sopir.fotoSopir!.isNotEmpty)
                                          ? NetworkImage(sopir.fotoSopir!)
                                          : const AssetImage('assets/images/siapantarbg.png')
                                              as ImageProvider,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.yellow.shade700,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        sopir.tipeMobil ?? '-',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sopir.namaSopir,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'No HP: ${sopir.noHp ?? '-'}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      sopir.hargaPerHari != null &&
                                              sopir.hargaPerHari!.isNotEmpty
                                          ? 'Rp ${sopir.hargaPerHari}'
                                          : 'Harga tidak tersedia',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: sopir.statusTersedia
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: Text(
                                        sopir.statusTersedia
                                            ? 'Tersedia'
                                            : 'Tidak Tersedia',
                                        style: TextStyle(
                                          color: sopir.statusTersedia
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SpaceHeight(16.0),
                ],
              );
            }

            return const Center(
              child: Text('Ada masalah, silakan coba lagi'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PemesananFormPage(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text('Pesan Sopir'),
      ),
    );
  }
}
