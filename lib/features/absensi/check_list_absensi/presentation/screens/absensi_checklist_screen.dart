import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../data/models/absensi_model.dart';
import '../widgets/instrument_toggle_widget.dart';

enum ShiftFormType { checkIn, checkOut }

class ShiftFormResult {
  final AbsensiCheckListModel checklist;

  const ShiftFormResult({required this.checklist});
}

class ShiftFormScreen extends StatefulWidget {
  final ShiftFormType type;
  final void Function(ShiftFormResult result) onSubmit;

  const ShiftFormScreen({
    super.key,
    required this.type,
    required this.onSubmit,
  });

  @override
  State<ShiftFormScreen> createState() => _ShiftFormScreenState();
}

class _ShiftFormScreenState extends State<ShiftFormScreen> {
  final _motorController = TextEditingController();
  final _mobilController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _edc = false;
  bool _qris = false;
  bool _cctv = false;
  bool _tsPark = false;

  bool get _isCheckIn => widget.type == ShiftFormType.checkIn;
  Color get _accentColor => _isCheckIn ? AppColors.success : AppColors.error;
  String get _title => _isCheckIn ? "Form Check In" : "Form Check Out";
  String get _submitLabel =>
      _isCheckIn ? "Simpan Check In" : "Simpan Check Out";
  IconData get _headerIcon =>
      _isCheckIn ? Icons.login_rounded : Icons.logout_rounded;

  @override
  void dispose() {
    _motorController.dispose();
    _mobilController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      ShiftFormResult(
        checklist: AbsensiCheckListModel(
          edc: _edc,
          qrisRompi: _qris,
          cctv: _cctv,
          tsPark: _tsPark,
          totalMotor: int.tryParse(_motorController.text) ?? 0,
          totalMobil: int.tryParse(_mobilController.text) ?? 0,
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    label: "CCTV",
                    icon: Icons.videocam_rounded,
                    isActive: _cctv,
                    onChanged: (v) => setState(() => _cctv = v),
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
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
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
            ),
            const SizedBox(height: 16),
          ],
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
}
