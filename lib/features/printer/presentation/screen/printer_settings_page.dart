import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../../../../core/design_system/components/pb_permission_dialogv2.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../shared/loading/loading_overlay.dart';
import '../cubit/printer_cubit.dart';
import '../cubit/printer_state.dart';
import '../widgets/list_device_widget.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage>
    with WidgetsBindingObserver {
  late final PrinterCubit _printerCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _printerCubit = context.read<PrinterCubit>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printerCubit.scanDevices();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _printerCubit.stopScanning();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _printerCubit.refreshPairedDevices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: const Color(
          0xFFF8F9FA,
        ), // Latar belakang formal netral (Government grey)
        appBar: AppBar(
          title: Text(
            'Pengaturan Printer',
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
        body: BlocConsumer<PrinterCubit, PrinterState>(
          listener: (context, state) {
            state.maybeWhen(
              error: (message, _) {
                PbStatusSnackbar.show(context, message: message, isError: true);
              },
              permissionRequiresAction: (_) {
                PbPermissionDialog.show(
                  context,
                  type: AppPermissionType.bluetooth,
                  status: AppPermissionStatus.permanentlyDenied,
                  onActionPressed: () {
                    _printerCubit.checkAndRequestPermissions();
                  },
                );
              },
              bluetoothOffRequiresAction: (_) {
                PbPermissionDialog.show(
                  context,
                  type: AppPermissionType.bluetooth,
                  status: AppPermissionStatus.permanentlyDenied,
                  onActionPressed: () {
                    AppSettings.openAppSettings(
                      type: AppSettingsType.bluetooth,
                    );
                  },
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeMap(
              loading: (_) => true,
              loaded: (s) => s.isLoading,
              orElse: () => false,
            );

            final isScanning = state.maybeMap(
              loaded: (s) => s.isScanning,
              orElse: () => false,
            );

            final devices = state.maybeMap(
              loaded: (s) => s.devices,
              orElse: () => <BtcDevice>[],
            );

            final discoveredDevices = state.maybeMap(
              loaded: (s) => s.discoveredDevices,
              orElse: () => <BtcDevice>[],
            );

            final connectedDevice = state.maybeMap(
              loaded: (s) => s.connectedDevice,
              orElse: () => null,
            );

            // 🚀 EKSTRAKSI KUNCI JAWABAN: Ambil savedMacAddress dari Freezed State
            final savedMacAddress = state.maybeMap(
              loaded: (s) => s.savedMacAddress,
              orElse: () => null,
            );

            return LoadingOverlay(
              isLoading: isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- BANNER STATUS KONEKSI ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: connectedDevice != null
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                      border: Border(
                        bottom: BorderSide(
                          color: connectedDevice != null
                              ? AppColors.success.withValues(alpha: 0.3)
                              : AppColors.error.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          connectedDevice != null
                              ? Icons.print_rounded
                              : Icons.print_disabled_rounded,
                          size: 44,
                          color: connectedDevice != null
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          connectedDevice != null
                              ? 'STATUS: TERHUBUNG'
                              : 'STATUS: TIDAK TERHUBUNG',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: connectedDevice != null
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          connectedDevice != null
                              ? connectedDevice.displayName
                              : 'Belum ada printer thermal yang dipilih',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            if (connectedDevice != null)
                              ElevatedButton.icon(
                                onPressed: isLoading
                                    ? null
                                    : () => _printerCubit.disconnect(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.link_off_rounded,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Putuskan Koneksi',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => isScanning
                                        ? _printerCubit.stopScanning()
                                        : _printerCubit.startScanning(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isScanning
                                    ? Colors.blueGrey
                                    : AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(
                                isScanning
                                    ? Icons.stop_rounded
                                    : Icons.bluetooth_searching_rounded,
                                size: 18,
                              ),
                              label: Text(
                                isScanning
                                    ? 'Berhenti Mencari'
                                    : 'Cari Perangkat Baru',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- DAFTAR 2 SEGMEN ---
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        await _printerCubit.refreshPairedDevices();
                        await Future.delayed(const Duration(milliseconds: 450));
                      },
                      child: ListDeviceWidget(
                        devices: devices,
                        savedMacAddress: savedMacAddress,
                        discoveredDevices: discoveredDevices,
                        connectedDevice: connectedDevice,
                        isLoading: isLoading,
                        isScanning: isScanning,
                        onConnect: (device) =>
                            _printerCubit.connectDevice(device),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
