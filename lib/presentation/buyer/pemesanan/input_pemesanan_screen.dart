import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/components/custom_text_field.dart';
import 'package:siapantar/core/components/spaces.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/data/model/request/penyewa/pemesanan_request_model.dart';
import 'package:siapantar/data/model/response/get_all_sopir_response_model.dart';
import 'package:siapantar/presentation/admin/admin_main_page.dart';
import 'package:siapantar/presentation/buyer/pemesanan/bloc/pemesanan_bloc.dart';

class PemesananFormPage extends StatefulWidget {
  const PemesananFormPage({super.key});

  @override
  State<PemesananFormPage> createState() => _PemesananFormPageState();
}

class _PemesananFormPageState extends State<PemesananFormPage> {
  // Controllers
  late final TextEditingController namaPenyewaController;
  late final TextEditingController noHpController;
  late final TextEditingController deskripsiController;
  late final TextEditingController alamatJemputController;
  late final TextEditingController alamatAntarController;
  late final TextEditingController tanggalMulaiController;
  late final TextEditingController tanggalSelesaiController;
  late final TextEditingController jamJemputController;
  late final TextEditingController totalHargaController;

  final _formKey = GlobalKey<FormState>();

  // Data lists
  final List<String> carTypes = ['Matic', 'Manual/Matic', 'Manual'];
  List<GetSopir> sopirList = [];

  // Selected values
  String? selectedCarType;
  int? selectedSopirId;
  DateTime? selectedTanggalMulai;
  DateTime? selectedTanggalSelesai;
  TimeOfDay? selectedJamJemput;

  @override
  void initState() {
    super.initState();
    namaPenyewaController = TextEditingController();
    noHpController = TextEditingController();
    deskripsiController = TextEditingController();
    alamatJemputController = TextEditingController();
    alamatAntarController = TextEditingController();
    tanggalMulaiController = TextEditingController();
    tanggalSelesaiController = TextEditingController();
    jamJemputController = TextEditingController();
    totalHargaController = TextEditingController();
    
    // Load sopir data
    context.read<PemesananBloc>().add(PemesananGetSopirTersediaEvent());
  }

  @override
  void dispose() {
    namaPenyewaController.dispose();
    noHpController.dispose();
    deskripsiController.dispose();
    alamatJemputController.dispose();
    alamatAntarController.dispose();
    tanggalMulaiController.dispose();
    tanggalSelesaiController.dispose();
    jamJemputController.dispose();
    totalHargaController.dispose();
    super.dispose();
  }

  // Date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          selectedTanggalMulai = picked;
          tanggalMulaiController.text = "${picked.day}/${picked.month}/${picked.year}";
        } else {
          selectedTanggalSelesai = picked;
          tanggalSelesaiController.text = "${picked.day}/${picked.month}/${picked.year}";
        }
        _calculateTotalPrice();
      });
    }
  }

  // Time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        selectedJamJemput = picked;
        jamJemputController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  // Calculate total price
  void _calculateTotalPrice() {
    if (selectedTanggalMulai != null && 
        selectedTanggalSelesai != null && 
        selectedSopirId != null) {
      
      final selectedSopir = sopirList.firstWhere(
        (sopir) => sopir.id == selectedSopirId,
        orElse: () => GetSopir(
          id: 0, namaSopir: '', noHp: '', deskripsi: '', 
          tipeMobil: '', fotoSopir: null, statusTersedia: false, hargaPerHari: '0',
        ),
      );
      
      final days = selectedTanggalSelesai!.difference(selectedTanggalMulai!).inDays + 1;
      final hargaPerHari = int.tryParse(selectedSopir.hargaPerHari?.replaceAll(RegExp(r'[^\d]'), '') ?? '0') ?? 0;
      final totalPrice = hargaPerHari * days;
      
      setState(() {
        totalHargaController.text = totalPrice.toString();
      });
    }
  }

  // Format date for API
  String _formatDateForApi(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Form Pemesanan', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceHeight(20),
                
                // Data Penyewa
                CustomTextField(
                  controller: namaPenyewaController,
                  label: 'Nama Penyewa',
                  validator: 'Nama penyewa tidak boleh kosong',
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
                  label: 'Catatan/Deskripsi (Opsional)',
                  validator: '', // Optional
                  maxLines: 3,
                ),
                const SpaceHeight(16),

                // Alamat
                CustomTextField(
                  controller: alamatJemputController,
                  label: 'Alamat Jemput',
                  validator: 'Alamat jemput tidak boleh kosong',
                  maxLines: 2,
                ),
                const SpaceHeight(16),
                CustomTextField(
                  controller: alamatAntarController,
                  label: 'Alamat Tujuan',
                  validator: 'Alamat tujuan tidak boleh kosong',
                  maxLines: 2,
                ),
                const SpaceHeight(16),

                // Tanggal
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: tanggalMulaiController,
                            label: 'Tanggal Mulai',
                            validator: 'Tanggal mulai tidak boleh kosong',
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SpaceWidth(16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: tanggalSelesaiController,
                            label: 'Tanggal Selesai',
                            validator: 'Tanggal selesai tidak boleh kosong',
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SpaceHeight(16),

                // Jam Jemput
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: jamJemputController,
                      label: 'Jam Jemput (Opsional)',
                      validator: '', // Optional
                      suffixIcon: const Icon(Icons.access_time),
                    ),
                  ),
                ),
                const SpaceHeight(16),

                // Tipe Mobil
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  hint: const Text('Pilih Tipe Mobil', style: TextStyle(fontSize: 14)),
                  items: carTypes.map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  )).toList(),
                  validator: (value) => value == null ? 'Tipe mobil tidak boleh kosong' : null,
                  onChanged: (value) => setState(() => selectedCarType = value),
                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SpaceHeight(16),

                // Sopir
                Text(
                  'Pilih Sopir',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceHeight(8),
                DropdownButtonFormField2<int>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  hint: const Text('Pilih Sopir', style: TextStyle(fontSize: 14)),
                  items: sopirList
                      .where((sopir) => sopir.statusTersedia)
                      .map((sopir) => DropdownMenuItem<int>(
                            value: sopir.id,
                            child: Text(
                              '${sopir.namaSopir} - ${sopir.tipeMobil}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ))
                      .toList(),
                  validator: (value) => value == null ? 'Sopir harus dipilih' : null,
                  onChanged: (value) => setState(() {
                    selectedSopirId = value;
                    _calculateTotalPrice();
                  }),
                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    maxHeight: 200,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SpaceHeight(16),

                // Total Harga
                CustomTextField(
                  controller: totalHargaController,
                  label: 'Total Harga',
                  validator: '',
                  keyboardType: TextInputType.number,
                  prefixText: 'Rp ',
                  readOnly: true,
                ),
                const SpaceHeight(32),

                // Submit Button
                BlocConsumer<PemesananBloc, PemesananState>(
                  listener: (context, state) {
                    if (state is PemesananCreateSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.responseModel.message)),
                      );
                      context.pushAndRemoveUntil(const AdminMainPage(), (route) => false);
                    } else if (state is PemesananSopirSuccessState) {
                      setState(() {
                        sopirList = state.responseModel.data;
                      });
                    } else if (state is PemesananErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Validation for dates
                          if (selectedTanggalMulai == null || selectedTanggalSelesai == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tanggal mulai dan selesai harus dipilih')),
                            );
                            return;
                          }
                          
                          if (selectedTanggalSelesai!.isBefore(selectedTanggalMulai!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tanggal selesai tidak boleh lebih awal dari tanggal mulai')),
                            );
                            return;
                          }

                          final pemesananRequest = PemesananRequestModel(
                            namaPenyewa: namaPenyewaController.text,
                            noHp: noHpController.text,
                            deskripsi: deskripsiController.text.isNotEmpty ? deskripsiController.text : null,
                            alamatJemput: alamatJemputController.text,
                            alamatAntar: alamatAntarController.text,
                            tanggalMulai: _formatDateForApi(selectedTanggalMulai!),
                            tanggalSelesai: _formatDateForApi(selectedTanggalSelesai!),
                            jamJemput: jamJemputController.text.isNotEmpty ? jamJemputController.text : null,
                            tipeMobil: selectedCarType ?? '',
                            sopirId: selectedSopirId ?? 0,
                            totalHarga: totalHargaController.text.isNotEmpty ? totalHargaController.text : null,
                            fotoFormulir: null,
                          );

                          context.read<PemesananBloc>().add(
                            PemesananCreateEvent(requestModel: pemesananRequest),
                          );
                        }
                      },
                      label: "Simpan Pemesanan",
                    );
                  },
                ),
                const SpaceHeight(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}