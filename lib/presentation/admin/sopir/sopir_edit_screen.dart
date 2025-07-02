import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/components/custom_text_field.dart';
import 'package:siapantar/core/components/spaces.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/data/model/request/admin/admin_sopir_request.dart';
import 'package:siapantar/data/model/response/get_all_sopir_response_model.dart';

import 'package:siapantar/presentation/admin/sopir/bloc/sopir_bloc.dart';

class SopirEditPage extends StatefulWidget {
  final GetSopir sopir;

  const SopirEditPage({super.key, required this.sopir});

  @override
  State<SopirEditPage> createState() => _SopirEditPageState();
}

class _SopirEditPageState extends State<SopirEditPage> {
  late final TextEditingController namaSopirController;
  late final TextEditingController noHpController;
  late final TextEditingController deskripsiController;
  late final TextEditingController hargaPerHariController;

  final _formKey = GlobalKey<FormState>();

  final List<String> carTypes = [
    'Matic',
    'Manual/Matic',
    'Manual',
  ];

  final List<String> statusItems = ['Tersedia', 'Tidak Tersedia'];

  String? selectedCarType;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers dengan data existing
    namaSopirController = TextEditingController(text: widget.sopir.namaSopir);
    noHpController = TextEditingController(text: widget.sopir.noHp);
    deskripsiController = TextEditingController(text: widget.sopir.deskripsi ?? '');
    hargaPerHariController = TextEditingController(text: widget.sopir.hargaPerHari ?? '');
    
    // Set selected values
    selectedCarType = widget.sopir.tipeMobil;
    selectedStatus = widget.sopir.statusTersedia ? 'Tersedia' : 'Tidak Tersedia';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Sopir', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceHeight(30),
                CustomTextField(
                  controller: namaSopirController,
                  label: 'Nama Sopir',
                  validator: 'Nama sopir tidak boleh kosong',
                ),
                const SpaceHeight(16),
                CustomTextField(
                  controller: noHpController,
                  label: 'Nomor HP',
                  validator: 'Nomor HP tidak boleh kosong',
                  keyboardType: TextInputType.phone,
                ),
                const SpaceHeight(16),
                CustomTextField(
                  controller: deskripsiController,
                  label: 'Deskripsi',
                  validator: "Wajib Di Isi", // Optional field
                  maxLines: 3,
                ),
                const SpaceHeight(16),
                Text(
                  'Tipe Mobil',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceHeight(8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  hint: const Text(
                    'Pilih Tipe Mobil',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: selectedCarType,
                  items: carTypes
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Tipe mobil tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedCarType = value;
                    });
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SpaceHeight(16),
                CustomTextField(
                  controller: hargaPerHariController,
                  label: 'Harga Per Hari (Opsional)',
                  validator: "Harus Di Isi", // Optional field
                  keyboardType: TextInputType.number,
                  prefixText: 'Rp ',
                ),
                const SpaceHeight(16),
                Text(
                  'Status Ketersediaan',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceHeight(8),
                Row(
                  children: statusItems.map((status) {
                    return Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(status),
                        value: status,
                        groupValue: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SpaceHeight(32),
                BlocConsumer<SopirBloc, SopirState>(
                  listener: (context, state) {
                    if (state is SopirUpdateSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Data sopir berhasil diperbarui')),
                      );
                      Navigator.pop(context); // Kembali ke detail
                    } else if (state is SopirErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final sopirRequest = SopirRequestModel(
                            namaSopir: namaSopirController.text,
                            noHp: noHpController.text,
                            deskripsi: deskripsiController.text.isNotEmpty
                                ? deskripsiController.text
                                : null,
                            tipeMobil: selectedCarType ?? '',
                            statusTersedia: selectedStatus == 'Tersedia',
                            hargaPerHari: hargaPerHariController.text.isNotEmpty
                                ? hargaPerHariController.text
                                : null,
                            fotoSopir: null, // Tidak ada upload foto
                          );

                          context.read<SopirBloc>().add(
                            SopirUpdateEvent(
                              id: widget.sopir.id,
                              requestModel: sopirRequest,
                            ),
                          );
                        }
                      },
                      label: "Update",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaSopirController.dispose();
    noHpController.dispose();
    deskripsiController.dispose();
    hargaPerHariController.dispose();
    super.dispose();
  }
}