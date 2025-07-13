import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/core/components/buttons.dart';
import 'package:siapantar/core/components/custom_text_field.dart';
import 'package:siapantar/core/components/spaces.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/data/model/request/admin/admin_profile_request.dart';
import 'package:siapantar/presentation/admin/admin_main_page.dart';
import 'package:siapantar/presentation/admin/profile/bloc/add_profile/add_profile_bloc.dart';
import 'package:siapantar/presentation/admin/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:siapantar/presentation/auth/login_screen.dart';

class AdminConfirmScreen extends StatefulWidget {
  const AdminConfirmScreen({super.key});

  @override
  State<AdminConfirmScreen> createState() => _AdminConfirmScreenState();
}

class _AdminConfirmScreenState extends State<AdminConfirmScreen> {
  late final TextEditingController nameController;
  late final GlobalKey<FormState> _key;
  bool _isLoggingOut = false;

  @override
  void initState() {
    nameController = TextEditingController();
    _key = GlobalKey<FormState>();
    context.read<GetProfileBloc>().add(FetchProfileEvent());
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    _key.currentState?.dispose();
    super.dispose();
  }

  // Method untuk handle logout dengan loading
  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Simulasi proses logout (clear token, preferences, etc.)
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implementasi logout logic sebenarnya
      // - Clear authentication token
      // - Clear user preferences
      // - Clear cache data
      // Example:
      // await AuthLocalDatasource().clearAuthData();
      
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil logout'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method untuk konfirmasi logout
  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                color: Colors.red[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text("Konfirmasi Logout"),
            ],
          ),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Apakah Anda yakin ingin keluar?\n\nData yang belum disimpan akan hilang.",
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "Batal",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Keluar"),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      _handleLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Admin Confirmation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Logout Button dengan Loading State
          _isLoggingOut
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: _showLogoutConfirmation,
                  tooltip: 'Logout',
                ),
        ],
      ),
      body: Stack(
        children: [
          // Main Content
          BlocBuilder<GetProfileBloc, GetProfileState>(
            builder: (context, state) {
              bool isReadOnly = false;
              bool hasData = false;
              if (state is GetProfileSuccess && state.responseModel.data != null) {
                final profile = state.responseModel.data!;
                nameController.text = profile.name ?? '';
                isReadOnly = true;
                hasData = true;
              }
              return Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header dengan Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      const SpaceHeight(20),
                      
                      Text(
                        'Admin Confirmation',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Text(
                        hasData 
                            ? 'Selamat datang kembali!'
                            : 'Lengkapi profil admin Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      CustomTextField(
                        readOnly: isReadOnly || _isLoggingOut,
                        controller: nameController,
                        label: 'Nama Lengkap',
                        validator: "Nama Lengkap tidak boleh kosong",
                        //prefixIcon: Icons.person,
                      ),
                      
                      const SpaceHeight(32),
                      
                      if (hasData)
                        Button.filled(
                          onPressed: _isLoggingOut 
                              ? null 
                              : () {
                                  context.pushAndRemoveUntil(
                                    const AdminMainPage(),
                                    (route) => false,
                                  );
                                },
                          label: "Lanjutkan",
                        )
                      else
                        BlocConsumer<AddProfileBloc, AddProfileState>(
                          listener: (context, state) {
                            if (state is AddProfileSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profile berhasil ditambahkan!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              context.pushAndRemoveUntil(
                                const AdminMainPage(),
                                (route) => false,
                              );
                            } else if (state is AddProfileFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Gagal menambah profile: ${state.error}',
                                  ),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is AddProfileLoading || _isLoggingOut;
                            return Button.filled(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_key.currentState!.validate()) {
                                        final request = AdminProfileRequestModel(
                                          name: nameController.text,
                                        );
                                        context.read<AddProfileBloc>().add(
                                          AddProfileRequested(
                                            requestModel: request,
                                          ),
                                        );
                                      }
                                    },
                              label: state is AddProfileLoading
                                  ? 'Menyimpan...'
                                  : _isLoggingOut
                                      ? 'Logging out...'
                                      : 'Konfirmasi',
                            );
                          },
                        ),
                      
                      const SpaceHeight(20),
                      
                      // Info Text
                      if (!hasData && !_isLoggingOut)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[700],
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Silakan masukkan nama lengkap Anda untuk melanjutkan ke dashboard admin.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Loading Overlay
          if (_isLoggingOut)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Logging out...',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please wait',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}