import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siapantar/core/core.dart';
import 'package:siapantar/data/model/response/penyewa/penyewa_profile_response_model.dart';
import 'package:siapantar/presentation/buyer/home/penyewa_home_screen.dart';
import 'package:siapantar/presentation/buyer/penyewa_nav_screen.dart';

// Import kamera page yang sudah dibuat
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  int _selectedCameraIdx = 0;
  FlashMode _flashMode = FlashMode.off;
  double _zoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  bool _isZoomSupported = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    await _setupCamera(_selectedCameraIdx);
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    final controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.max,
      enableAudio: false,
    );

    await controller.initialize();
    _minZoom = await controller.getMinZoomLevel();
    _maxZoom = await controller.getMaxZoomLevel();
    _isZoomSupported = _maxZoom > _minZoom;
    _zoom = _minZoom;
    await controller.setZoomLevel(_zoom);
    await controller.setFlashMode(_flashMode);

    if (mounted) {
      setState(() {
        _controller = controller;
        _selectedCameraIdx = cameraIndex;
      });
    }
  }

  Future<void> _captureImage() async {
    final XFile file = await _controller!.takePicture();
    Navigator.pop(context, File(file.path));
  }

  void _switchCamera() async {
    final nextIndex = (_selectedCameraIdx + 1) % _cameras.length;
    await _setupCamera(nextIndex);
  }

  void _toggleFlash() async {
    FlashMode next =
        _flashMode == FlashMode.off
            ? FlashMode.auto
            : _flashMode == FlashMode.auto
            ? FlashMode.always
            : FlashMode.off;
    await _controller!.setFlashMode(next);
    setState(() => _flashMode = next);
  }

  void _setZoom(double value) async {
    if (!_isZoomSupported) return;
    _zoom = value.clamp(_minZoom, _maxZoom);
    await _controller!.setZoomLevel(_zoom);
    setState(() {});
  }

  void _handleTap(TapDownDetails details, BoxConstraints constraints) {
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    _controller?.setFocusPoint(offset);
    _controller?.setExposurePoint(offset);
  }

  IconData _flasIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      default:
        return Icons.flash_off;
    }
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {double size = 50}) {
    return ClipOval(
      child: Material(
        color: Colors.white24,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    if (!_isZoomSupported) return const SizedBox.shrink();

    return Positioned(
      bottom: 160,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _circleButton(Icons.looks_one, () => _setZoom(1.0), size: 44),
              const SizedBox(width: 10),
              if (_maxZoom >= 3.0)
                _circleButton(Icons.looks_3, () => _setZoom(3.0), size: 44),
              const SizedBox(width: 10),
              if (_maxZoom >= 5.0)
                _circleButton(Icons.looks_5, () => _setZoom(5.0), size: 44),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.zoom_out, color: Colors.white),
              Expanded(
                child: Slider(
                  value: _zoom,
                  min: _minZoom,
                  max: _maxZoom,
                  divisions: ((_maxZoom - _minZoom) * 10).toInt(),
                  label: '${_zoom.toStringAsFixed(1)}x',
                  onChanged: (value) => _setZoom(value),
                ),
              ),
              const Icon(Icons.zoom_in, color: Colors.white),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${_zoom.toStringAsFixed(1)}x',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _controller?.value.isInitialized ?? false
              ? LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapDown: (details) => _handleTap(details, constraints),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: ClipRect(
                            child: SizedOverflowBox(
                              alignment: Alignment.center,
                              size: Size(360, 480),
                              child: CameraPreview(_controller!),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 20,
                          right: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circleButton(_flasIcon(), _toggleFlash),
                              _circleButton(
                                Icons.camera,
                                _captureImage,
                                size: 70,
                              ),
                              _circleButton(
                                Icons.flip_camera_android,
                                _switchCamera,
                              ),
                            ],
                          ),
                        ),
                        _buildZoomControls(),
                      ],
                    ),
                  );
                },
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

class ProfileViewBuyer extends StatefulWidget {
  final Data profile;
  const ProfileViewBuyer({super.key, required this.profile});

  @override
  State<ProfileViewBuyer> createState() => _ProfileViewBuyerState();
}

class _ProfileViewBuyerState extends State<ProfileViewBuyer> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Foto Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: Icons.camera_alt,
                  label: 'Kamera',
                  onTap: () => _getImageFromCamera(),
                ),
                _buildImageOption(
                  icon: Icons.photo_library,
                  label: 'Galeri',
                  onTap: () => _getImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFF244475).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF244475).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: const Color(0xFF244475)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF244475),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromCamera() async {
    Navigator.pop(context);
    try {
      final File? result = await Navigator.push<File>(
        context,
        MaterialPageRoute(builder: (context) => const CameraPage()),
      );
      
      if (result != null) {
        setState(() {
          _selectedImage = result;
        });
        _showSnackBar('Foto profil berhasil diambil!', Colors.green);
      }
    } catch (e) {
      _showSnackBar('Gagal mengambil foto dari kamera', Colors.red);
    }
  }

  Future<void> _getImage(ImageSource source) async {
    Navigator.pop(context);
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      _showSnackBar('Foto profil berhasil dipilih!', Colors.green);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),
                
                // Photo Upload Section
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(
                          color: const Color(0xFF244475),
                          width: 2,
                        ),
                      ),
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: const Color(0xFF244475),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Foto',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF244475),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Name Field
                _buildInputField(
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline,
                  value: widget.profile.name,
                ),
                
                const SizedBox(height: 16),
                
                // Address Field
                _buildInputField(
                  label: 'Alamat',
                  icon: Icons.location_on_outlined,
                  value: widget.profile.address,
                ),
                
                const SizedBox(height: 16),
                
                // Phone Field
                _buildInputField(
                  label: 'Nomor HP',
                  icon: Icons.phone_outlined,
                  value: widget.profile.phone,
                ),
                
                const SizedBox(height: 32),
                
                // Submit Button
                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       context.pushAndRemoveUntil(
                //         const PenyewaNavScreen(),
                //         (route) => false,
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFF244475),
                //       foregroundColor: Colors.white,
                //       elevation: 0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     child: const Text(
                //       "Konfirmasi",
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required String value,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: value,
      keyboardType: maxLines > 1 ? TextInputType.multiline : null,
      maxLines: maxLines,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF244475),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF244475), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}