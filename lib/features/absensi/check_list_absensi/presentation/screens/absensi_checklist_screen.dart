import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_form_dialog.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_form_section_card.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_permission_service.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/services/location/i_app_location_service.dart';
import 'package:parkir_digital_bapenda/core/utils/photo_utils.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/presentation/widgets/absen_header_widget.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/presentation/widgets/absen_number_field.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/presentation/widgets/absen_photo_widget.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import '../cubit/absensi_cubit.dart';
import '../cubit/absensi_state.dart';
import '../widgets/instrument_toggle_widget.dart';

enum ShiftFormType { checkIn, checkOut }

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
  final _photoKey = GlobalKey();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AbsensiCubit>().fetchLocation(widget.locationService);
    });
  }

  @override
  void dispose() {
    _motorController.dispose();
    _mobilController.dispose();
    super.dispose();
  }

  Future<void> _submitAbsensi() async {
    final cubit = context.read<AbsensiCubit>();
    final state = cubit.state;

    // Pre-validation di sisi UI
    if (state.rawPhoto == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Foto wajah wajib diambil")));
      return;
    }
    if (state.latitude == null || state.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi belum terdeteksi, coba lagi")),
      );
      return;
    }
    if (state.isFetchingLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tunggu lokasi selesai terdeteksi")),
      );
      return;
    }

    // 1. Proses watermark
    cubit.setCapturing(true);
    await Future.delayed(const Duration(milliseconds: 300));
    final capturedFile = await PhotoUtils.captureWatermarkedImage(_photoKey);
    cubit.setCapturing(false);

    if (capturedFile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal memproses foto, coba ambil ulang"),
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // 2. Set foto watermark ke cubit
    cubit.setWatermarkedPhoto(capturedFile);

    // 3. Submit
    cubit.submitAbsensi(isCheckIn: _isCheckIn);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AbsensiCubit, AbsensiState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == AbsensiStatus.failure) {
          FormResultDialog.showError(
            context,
            title: "Gagal",
            description: state.errorMessage.isNotEmpty
                ? state.errorMessage
                : "Terjadi kesalahan, silakan coba lagi",
            onConfirm: () {},
          );
        } else if (state.status == AbsensiStatus.success) {
          FormResultDialog.showSuccess(
            context,
            title: _isCheckIn ? "Check In Berhasil" : "Check Out Berhasil",
            description: _isCheckIn
                ? "Absensi check in kamu sudah tersimpan"
                : "Absensi check out kamu sudah tersimpan",
            onConfirm: () => Navigator.of(context).pop(true),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading || state.isCapturing,
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
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AbsenHeaderWidget(
                  title: _title,
                  icon: _headerIcon,
                  accentColor: _accentColor,
                ),
                const SizedBox(height: 16),
                AbsenPhotoWidget(
                  state: state,
                  photoKey: _photoKey,
                  onTap: () async {
                    final granted =
                        await PermissionService.ensureCameraAndLocationPermission(
                          context,
                        );

                    if (!granted || !mounted) return;

                    context.read<AbsensiCubit>().takePhoto(
                      widget.locationService,
                    );
                  },
                ),
                const SizedBox(height: 16),
                FormSectionCard(
                  title: "Data Kendaraan",
                  icon: Icons.directions_car_rounded,
                  child: Column(
                    children: [
                      AbsenNumberField(
                        controller: _motorController,
                        label: "Jumlah Motor di Lapangan",
                        icon: Icons.two_wheeler_rounded,
                        onChanged: context.read<AbsensiCubit>().setMotorText,
                      ),
                      const SizedBox(height: 12),
                      AbsenNumberField(
                        controller: _mobilController,
                        label: "Jumlah Mobil di Lapangan",
                        icon: Icons.directions_car_rounded,
                        onChanged: context.read<AbsensiCubit>().setMobilText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FormSectionCard(
                  title: "Status Instrumen",
                  icon: Icons.devices_rounded,
                  child: Column(
                    children: [
                      InstrumentToggleWidget(
                        label: "EDC",
                        icon: Icons.credit_card_rounded,
                        isActive: state.edc,
                        onChanged: context.read<AbsensiCubit>().toggleEdc,
                      ),
                      const SizedBox(height: 8),
                      InstrumentToggleWidget(
                        label: "QRIS",
                        icon: Icons.qr_code_2_rounded,
                        isActive: state.qris,
                        onChanged: context.read<AbsensiCubit>().toggleQris,
                      ),
                      const SizedBox(height: 8),
                      InstrumentToggleWidget(
                        label: "TSpark",
                        icon: Icons.touch_app_rounded,
                        isActive: state.tsPark,
                        onChanged: context.read<AbsensiCubit>().toggleTsPark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
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
                  onPressed:
                      (state.isLoading || state.isCapturing || !state.canSubmit)
                      ? null
                      : _submitAbsensi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.canSubmit
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: (state.isLoading || state.isCapturing)
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
    );
  }
}
