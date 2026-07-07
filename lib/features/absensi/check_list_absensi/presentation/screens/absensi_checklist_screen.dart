import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_form_dialog.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../../../../core/services/camera/camera_service.dart';
import '../../../../../core/services/location/i_app_location_service.dart';
import '../../domain/entities/absensi_entity.dart';
import '../cubit/absensi_cubit.dart';
import '../cubit/absensi_state.dart';
import '../widgets/instrument_toggle_widget.dart';

enum ShiftFormType { checkIn, checkOut }

const Map<String, int> kInstrumentIds = {'EDC': 1, 'QRIS': 2, 'TSpark': 3};

class ShiftFormScreen extends StatefulWidget {
  final ShiftFormType type;
  final IAppLocationService locationService;

  const ShiftFormScreen({
    super.key,
    required this.type,
    required this.locationService,
  });

  @override
  State<ShiftFormScreen> createState() => _ShiftFormScreenState();
}

class _ShiftFormScreenState extends State<ShiftFormScreen> {
  final _motorController = TextEditingController();
  final _mobilController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 🔥 Key buat capture area foto + watermark jadi 1 gambar
  final GlobalKey _photoKey = GlobalKey();

  File? _photo; // foto asli dari kamera (dipakai buat preview UI)
  File? _watermarkedPhoto; // 🔥 hasil capture, ini yang dikirim ke API
  DateTime? _photoTakenAt;
  double? _latitude;
  double? _longitude;
  String? _placeName;
  String? _locationError;
  bool _isFetchingLocation = false;
  bool _isCapturing = false;
  bool _edc = false;
  bool _qris = false;
  bool _tsPark = false;

  bool get _isCheckIn => widget.type == ShiftFormType.checkIn;
  Color get _accentColor => _isCheckIn ? AppColors.success : AppColors.error;
  String get _title => _isCheckIn ? "Form Check In" : "Form Check Out";
  String get _submitLabel =>
      _isCheckIn ? "Simpan Check In" : "Simpan Check Out";
  IconData get _headerIcon =>
      _isCheckIn ? Icons.login_rounded : Icons.logout_rounded;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _motorController.dispose();
    _mobilController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _locationError = null;
    });

    try {
      final result = await widget.locationService.getCurrentLocation();

      setState(() {
        _latitude = double.tryParse(result.latitude);
        _longitude = double.tryParse(result.longitude);
        _placeName = result.address;
        _isFetchingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _isFetchingLocation = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    final file = await CameraService.takePhoto();
    if (file != null) {
      setState(() {
        _photo = file;
        _photoTakenAt = DateTime.now();
      });
      await _fetchLocation(); // Refresh lokasi saat foto diambil
    }
  }

  /// 🔥 Capture Stack (foto + overlay lokasi/waktu) jadi 1 file PNG baru.
  /// Ini yang bikin watermark "nempel" permanen di gambar, bukan cuma
  /// tampil di UI doang.
  Future<File?> _captureWatermarkedImage() async {
    try {
      final boundary =
          _photoKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/watermarked_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e) {
      debugPrint('Gagal capture watermark: $e');
      return null;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_photo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Foto wajah wajib diambil")));
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi belum terdeteksi, coba lagi")),
      );
      return;
    }

    if (_isFetchingLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tunggu lokasi selesai terdeteksi")),
      );
      return;
    }

    setState(() => _isCapturing = true);
    await Future.delayed(const Duration(milliseconds: 300));
    // 🔥 Capture foto + watermark jadi 1 file gambar
    final capturedFile = await _captureWatermarkedImage();

    if (!mounted) return;
    setState(() => _isCapturing = false);

    if (capturedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memproses foto, coba ambil ulang")),
      );
      return;
    }
    _watermarkedPhoto = capturedFile;

    final List<int> detailAlatIds = [
      if (_edc) kInstrumentIds['EDC']!,
      if (_qris) kInstrumentIds['QRIS']!,
      if (_tsPark) kInstrumentIds['TSpark']!,
    ];

    final entity = AbsensiEntity(
      latitude: _latitude!,
      longitude: _longitude!,
      totalMotor: int.tryParse(_motorController.text) ?? 0,
      totalMobil: int.tryParse(_mobilController.text) ?? 0,
      detailAlatIds: detailAlatIds,
      fotoPath: _watermarkedPhoto!
          .path, // 🔥 kirim gambar yang sudah ada watermark-nya
      isCheckIn: _isCheckIn,
    );

    if (!mounted) return;
    context.read<AbsensiCubit>().submitAbsensi(entity);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AbsensiCubit, AbsensiState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == AbsensiStatus.failure) {
          FormResultDialog.showError(
            context,
            title: "Gagal",
            description: state.errorMessage.isNotEmpty
                ? state.errorMessage
                : "Terjadi kesalahan, silakan coba lagi",
            onConfirm: () {
              // tetap di screen ini biar user bisa coba lagi
            },
          );
        } else if (state.status == AbsensiStatus.success) {
          FormResultDialog.showSuccess(
            context,
            title: _isCheckIn ? "Check In Berhasil" : "Check Out Berhasil",
            description: _isCheckIn
                ? "Absensi check in kamu sudah tersimpan"
                : "Absensi check out kamu sudah tersimpan",
            onConfirm: () {
              Navigator.of(context).pop(true);
            },
          );
        }
      },
      child: BlocBuilder<AbsensiCubit, AbsensiState>(
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.isLoading || _isCapturing,
            child: Scaffold(
              backgroundColor: Colors.grey.shade50,
              appBar: AppBar(
                title: Text(
                  _title,
                  style: AppTypography.heading5.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                backgroundColor: AppColors.surface,
                scrolledUnderElevation: 0,
                shape: const Border(
                  bottom: BorderSide(color: AppColors.primary, width: 1.0),
                ),
                elevation: 0,
                foregroundColor: Colors.black,
                iconTheme: const IconThemeData(color: AppColors.primary),
              ),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 16),
                    _buildPhotoSection(),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: "Data Kendaraan",
                      icon: Icons.directions_car_rounded,
                      child: Column(
                        children: [
                          _buildNumberField(
                            controller: _motorController,
                            label: "Jumlah Motor di Lapangan",
                            icon: Icons.two_wheeler_rounded,
                          ),
                          const SizedBox(height: 12),
                          _buildNumberField(
                            controller: _mobilController,
                            label: "Jumlah Mobil di Lapangan",
                            icon: Icons.directions_car_rounded,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: "Status Instrumen",
                      icon: Icons.devices_rounded,
                      child: Column(
                        children: [
                          InstrumentToggleWidget(
                            label: "EDC",
                            icon: Icons.credit_card_rounded,
                            isActive: _edc,
                            onChanged: (v) => setState(() => _edc = v),
                          ),
                          const SizedBox(height: 8),
                          InstrumentToggleWidget(
                            label: "QRIS",
                            icon: Icons.qr_code_2_rounded,
                            isActive: _qris,
                            onChanged: (v) => setState(() => _qris = v),
                          ),
                          const SizedBox(height: 8),
                          InstrumentToggleWidget(
                            label: "TSpark",
                            icon: Icons.touch_app_rounded,
                            isActive: _tsPark,
                            onChanged: (v) => setState(() => _tsPark = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  MediaQuery.of(context).padding.bottom > 0
                      ? MediaQuery.of(context).padding.bottom
                      : 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (state.isLoading || _isCapturing)
                        ? null
                        : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: (state.isLoading || _isCapturing)
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_headerIcon, size: 18, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                _submitLabel,
                                style: AppTypography.bodySemiBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    final now = DateTime.now();
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final dateStr = "${now.day} ${months[now.month - 1]} ${now.year}";
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accentColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_headerIcon, size: 22, color: _accentColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _title,
                style: AppTypography.bodySemiBold.copyWith(color: _accentColor),
              ),
              const SizedBox(height: 2),
              Text(
                "$dateStr  -  $timeStr",
                style: AppTypography.caption.copyWith(
                  color: _accentColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return _buildSectionCard(
      title: "Foto & Lokasi",
      icon: Icons.camera_alt_rounded,
      child: GestureDetector(
        onTap: _takePhoto,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          // 🔥 RepaintBoundary membungkus area yang akan di-capture
          // (foto + watermark overlay) supaya bisa "dibakar" jadi 1 gambar.
          child: RepaintBoundary(
            key: _photoKey,
            child: Container(
              width: double.infinity,
              height: 240,
              color: Colors.grey.shade100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_photo != null)
                    Image.file(_photo!, fit: BoxFit.cover)
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Ketuk untuk ambil foto",
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                  // watermark info lokasi & waktu, hanya muncul kalau sudah ada foto
                  if (_photo != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.0),
                              Colors.black.withValues(alpha: 0.75),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isFetchingLocation)
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Mendeteksi lokasi...",
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            else if (_locationError != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    size: 12,
                                    color: Colors.orangeAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _locationError!,
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.orangeAccent,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              if (_placeName != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2.0),
                                      child: Icon(
                                        Icons.location_on_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _placeName!,
                                        style: AppTypography.caption.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              if (_latitude != null && _longitude != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    "${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}",
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              if (_photoTakenAt != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    _formatStampTime(_photoTakenAt!),
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),

                  // tombol retake, pojok kanan atas
                  if (_photo != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  //const Positioned(bottom: 16, right: 16, child: MockScenarioFab()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return "$label wajib diisi";
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodySmall.copyWith(
          color: Colors.grey.shade500,
        ),
        prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  String _formatStampTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m";
  }
}
