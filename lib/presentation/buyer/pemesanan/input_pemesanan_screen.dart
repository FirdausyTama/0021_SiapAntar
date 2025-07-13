import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:siapantar/core/components/custom_text_field.dart';
import 'package:siapantar/core/components/spaces.dart';
import 'package:siapantar/core/constants/colors.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/data/model/request/penyewa/pemesanan_request_model.dart';
import 'package:siapantar/data/model/response/get_all_sopir_response_model.dart';
import 'package:siapantar/presentation/admin/admin_main_page.dart';
import 'package:siapantar/presentation/buyer/pemesanan/bloc/pemesanan_bloc.dart';
import 'package:siapantar/presentation/buyer/pemesanan/map_page.dart';
import 'package:siapantar/presentation/camera/storage_helper.dart';

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
  final ImagePicker _picker = ImagePicker();

  // Data lists
  final List<String> carTypes = ['Matic', 'Manual/Matic', 'Manual'];
  List<GetSopir> sopirList = [];

  // Selected values
  String? selectedCarType;
  int? selectedSopirId;
  DateTime? selectedTanggalMulai;
  DateTime? selectedTanggalSelesai;
  TimeOfDay? selectedJamJemput;
  String? selectedAlamatJemput; // Untuk alamat dari map
  String? selectedAlamatAntar; // Untuk alamat dari map
  File? selectedImage; // Untuk foto formulir

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

  // Method untuk memilih foto
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromSource(ImageSource.camera);
                },
              ),
              if (selectedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Hapus Foto', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      selectedImage = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Method untuk memilih dan menyimpan foto
  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        // Show loading
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Save image using StorageHelper
        final File tempFile = File(image.path);
        final File savedFile = await StorageHelper.saveImage(tempFile, 'pemesanan_');

        // Hide loading
        if (mounted) {
          Navigator.pop(context);
        }

        setState(() {
          selectedImage = savedFile;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto berhasil disimpan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Hide loading if still showing
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method untuk membuka map picker
  Future<void> _openMapPicker(bool isJemput) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapPage(),
        ),
      );

      if (result != null && result is String) {
        setState(() {
          if (isJemput) {
            selectedAlamatJemput = result;
            alamatJemputController.text = result;
          } else {
            selectedAlamatAntar = result;
            alamatAntarController.text = result;
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alamat ${isJemput ? "jemput" : "tujuan"} berhasil dipilih dari map'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka map: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  label: 'Catatan/Deskripsi',
                  validator: '', // Optional
                  maxLines: 3,
                ),
                const SpaceHeight(16),

                // Alamat Jemput dengan Map
                _buildAddressFieldWithMap(
                  controller: alamatJemputController,
                  label: 'Alamat Jemput',
                  selectedAddress: selectedAlamatJemput,
                  onMapTap: () => _openMapPicker(true),
                  onClear: () {
                    setState(() {
                      selectedAlamatJemput = null;
                      alamatJemputController.clear();
                    });
                  },
                ),
                const SpaceHeight(16),

                // Alamat Tujuan dengan Map
                _buildAddressFieldWithMap(
                  controller: alamatAntarController,
                  label: 'Alamat Tujuan',
                  selectedAddress: selectedAlamatAntar,
                  onMapTap: () => _openMapPicker(false),
                  onClear: () {
                    setState(() {
                      selectedAlamatAntar = null;
                      alamatAntarController.clear();
                    });
                  },
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

                // Form Pilih Foto
                _buildPhotoSection(),
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

                          // Gunakan alamat dari map jika tersedia
                          final finalAlamatJemput = selectedAlamatJemput ?? alamatJemputController.text;
                          final finalAlamatAntar = selectedAlamatAntar ?? alamatAntarController.text;

                          if (finalAlamatJemput.isEmpty || finalAlamatAntar.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Alamat jemput dan tujuan tidak boleh kosong')),
                            );
                            return;
                          }

                          final pemesananRequest = PemesananRequestModel(
                            namaPenyewa: namaPenyewaController.text,
                            noHp: noHpController.text,
                            deskripsi: deskripsiController.text.isNotEmpty ? deskripsiController.text : null,
                            alamatJemput: finalAlamatJemput,
                            alamatAntar: finalAlamatAntar,
                            tanggalMulai: _formatDateForApi(selectedTanggalMulai!),
                            tanggalSelesai: _formatDateForApi(selectedTanggalSelesai!),
                            jamJemput: jamJemputController.text.isNotEmpty ? jamJemputController.text : null,
                            tipeMobil: selectedCarType ?? '',
                            sopirId: selectedSopirId ?? 0,
                            totalHarga: totalHargaController.text.isNotEmpty ? totalHargaController.text : null,
                            // fotoFormulir: selectedImage?.path, // Pass file path
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

  // Widget untuk section foto
  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Formulir (Opsional)',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SpaceHeight(8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              // Preview foto atau placeholder
              if (selectedImage != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.file(
                    selectedImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Belum ada foto dipilih',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Tombol untuk memilih foto
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(16),
                    bottomRight: const Radius.circular(16),
                    topLeft: selectedImage != null ? Radius.zero : const Radius.circular(16),
                    topRight: selectedImage != null ? Radius.zero : const Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.photo_camera, 
                         color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedImage != null 
                            ? 'Foto berhasil dipilih'
                            : 'Tap untuk pilih foto',
                        style: TextStyle(
                          color: selectedImage != null 
                              ? Colors.green.shade700
                              : AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(
                        selectedImage != null ? Icons.edit : Icons.add_photo_alternate,
                        size: 16,
                      ),
                      label: Text(
                        selectedImage != null ? 'Ubah' : 'Pilih',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressFieldWithMap({
    required TextEditingController controller,
    required String label,
    required String? selectedAddress,
    required VoidCallback onMapTap,
    required VoidCallback onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SpaceHeight(8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              // Text field untuk alamat
              CustomTextField(
                controller: controller,
                label: 'Ketik alamat atau pilih dari map',
                validator: '$label tidak boleh kosong',
                maxLines: 2,
                showLabel: false,
              ),
              // Tombol untuk membuka map
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, 
                         color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedAddress != null 
                            ? 'Alamat dipilih dari map'
                            : 'Tap untuk pilih dari map',
                        style: TextStyle(
                          color: selectedAddress != null 
                              ? Colors.green.shade700
                              : AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onMapTap,
                      icon: Icon(Icons.map, size: 16),
                      label: Text('Map', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Show selected address preview
        if (selectedAddress != null) ...[
          const SpaceHeight(8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, 
                     color: Colors.green.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alamat dari Map:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedAddress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClear,
                  icon: Icon(Icons.clear, 
                           color: Colors.green.shade600, size: 18),
                  tooltip: 'Hapus alamat map',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}