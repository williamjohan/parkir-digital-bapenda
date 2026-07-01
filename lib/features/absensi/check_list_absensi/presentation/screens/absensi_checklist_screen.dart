import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../widgets/instrument_toggle_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Sesuaikan path import ini dengan struktur folder project kamu.
import '../../domain/entities/absensi_checkin_entity.dart';
import '../cubit/absensi_checkin_cubit.dart';
import '../cubit/absensi_checkin_state.dart';

enum ShiftFormType { checkIn, checkOut }

/// TODO: GANTI id ini sesuai master data alat/instrumen dari backend.
/// Ini cuma placeholder supaya kode bisa jalan dulu.
const Map<String, int> kInstrumentIds = {'EDC': 1, 'QRIS': 2, 'TSpark': 3};

class ShiftFormScreen extends StatefulWidget {
  final ShiftFormType type;

  const ShiftFormScreen({super.key, required this.type});

  @override
  State<ShiftFormScreen> createState() => _ShiftFormScreenState();
}

class _ShiftFormScreenState extends State<ShiftFormScreen> {
  final _motorController = TextEditingController();
  final _mobilController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _photo;

  bool _edc = false;
  bool _qris = false;
  bool _tsPark = false;
  bool _isFetchingLocation = false;

  bool get _isCheckIn => widget.type == ShiftFormType.checkIn;
  Color get _accentColor => _isCheckIn ? AppColors.success : AppColors.error;
  Position? _position;
  String? _locationError;
  String? _placeName;
  DateTime? _photoTakenAt;
  String get _title => _isCheckIn ? "Form Check In" : "Form Check Out";
  String get _submitLabel =>
      _isCheckIn ? "Simpan Check In" : "Simpan Check Out";
  IconData get _headerIcon =>
      _isCheckIn ? Icons.login_rounded : Icons.logout_rounded;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _motorController.dispose();
    _mobilController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 80,
    );
    if (image == null) return;

    setState(() {
      _photo = File(image.path);
      _photoTakenAt = DateTime.now();
    });

    await _getCurrentLocation(); // refresh biar waktu & lokasi sinkron sama momen foto
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _locationError = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'GPS tidak aktif. Aktifkan lokasi terlebih dahulu.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen. Aktifkan lewat pengaturan.';
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _position = position;
        _isFetchingLocation = false;
      });

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [
            p.subLocality,
            p.locality,
            p.subAdministrativeArea,
          ].where((e) => e != null && e.trim().isNotEmpty).toList();
          setState(
            () => _placeName = parts.isNotEmpty ? parts.join(', ') : null,
          );
        }
      } catch (_) {
        // nama tempat gagal diambil, biarkan null (lat/lng tetap valid)
      }
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _isFetchingLocation = false;
      });
    }
  }

  // ---- helper baca state cubit sesuai mode (checkIn / checkOut) ----
  bool _loadingFor(AbsensiCheckInState state) =>
      _isCheckIn ? state.isCheckInLoading : state.isCheckOutLoading;

  bool _successFor(AbsensiCheckInState state) =>
      _isCheckIn ? state.isCheckInSuccess : state.isCheckOutSuccess;

  String? _errorFor(AbsensiCheckInState state) =>
      _isCheckIn ? state.checkInErrorMessage : state.checkOutErrorMessage;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_photo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Foto wajah wajib diambil")));
      return;
    }

    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi belum terdeteksi, coba lagi")),
      );
      return;
    }

    final detailAlat = <AlatEntity>[
      if (_edc) AlatEntity(id: kInstrumentIds['EDC']!),
      if (_qris) AlatEntity(id: kInstrumentIds['QRIS']!),
      if (_tsPark) AlatEntity(id: kInstrumentIds['TSpark']!),
    ];

    final jumlahMobil = double.tryParse(_mobilController.text) ?? 0;
    final jumlahMotor = double.tryParse(_motorController.text) ?? 0;
    final lat = _position!.latitude.toString();
    final lng = _position!.longitude.toString();

    final cubit = context.read<AbsensiCheckInCubit>();

    if (_isCheckIn) {
      final entity = CheckInEntity(
        jumlahMobil: jumlahMobil,
        jumlahMotor: jumlahMotor,
        latitude: lat,
        longitude: lng,
        detailAlat: detailAlat,
      );
      cubit.checkIn(entity, _photo!);
    } else {
      final entity = CheckOutEntity(
        jumlahMobil: jumlahMobil,
        jumlahMotor: jumlahMotor,
        latitude: lat,
        longitude: lng,
        detailAlat: detailAlat,
      );
      cubit.checkOut(entity, _photo!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AbsensiCheckInCubit, AbsensiCheckInState>(
      listenWhen: (prev, curr) =>
          _successFor(prev) != _successFor(curr) ||
          _errorFor(prev) != _errorFor(curr),
      listener: (context, state) {
        final error = _errorFor(state);
        if (error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
          return;
        }

        if (_successFor(state)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isCheckIn ? 'Check in berhasil' : 'Check out berhasil',
              ),
            ),
          );
          // reset supaya kalau screen ini dipakai lagi state-nya bersih
          context.read<AbsensiCheckInCubit>().reset();
          Navigator.of(context).pop(true); // true = kasih tau caller sukses
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          ),
          title: Text(_title, style: AppTypography.bodySemiBold),
          centerTitle: true,
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
                      label: "Jumlah Motor",
                      icon: Icons.two_wheeler_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildNumberField(
                      controller: _mobilController,
                      label: "Jumlah Mobil",
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
              BlocBuilder<AbsensiCheckInCubit, AbsensiCheckInState>(
                builder: (context, state) {
                  final loading = _loadingFor(state);
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: loading
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
                                Icon(_headerIcon, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  _submitLabel,
                                  style: AppTypography.bodySemiBold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
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
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _placeName!,
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            if (_position != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  "${_position!.latitude.toStringAsFixed(5)}, ${_position!.longitude.toStringAsFixed(5)}",
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
              ],
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
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
