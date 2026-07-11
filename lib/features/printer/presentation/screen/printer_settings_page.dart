import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../../../../core/design_system/components/pb_permission_dialog.dart';
import '../../../../core/design_system/components/pb_permission_required_dialog.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../shared/loading/loading_overlay.dart';
import '../cubit/printer_cubit.dart';
import '../widgets/list_device_widget.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrinterCubit>().scanDevices();
    });
  }

  @override
  void dispose() {
    context.read<PrinterCubit>().stopScanning();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Pengaturan Printer',
            style: AppTypography.heading5,
          ),
          backgroundColor: AppColors.surface,
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<PrinterCubit>().scanDevices(),
            ),
          ],
        ),
        body: BlocConsumer<PrinterCubit, PrinterState>(
          listener: (context, state) {
            if (state is PrinterError) {
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
            } else if (state is PrinterPermissionRequiresAction) {
              PbPermissionDialog.show(
                context,
                title: 'Akses Izin Diperlukan',
                description:
                    'Anda telah menolak izin Perangkat Sekitar (Bluetooth) atau Lokasi aplikasi ini.\n\nMohon aktifkan izin tersebut secara manual melalui pengaturan aplikasi agar fitur printer dapat digunakan kembali.',
              );
            }
            // 🚀 MODAL BARU: Bluetooth HP belum aktif
            else if (state is PrinterBluetoothOffRequiresAction) {
              PermissionRequiredDialog.show(
                context,
                icon: Icons.bluetooth_disabled_rounded,
                title: 'Bluetooth Belum Aktif',
                description:
                    'Aktifkan Bluetooth pada perangkat Anda terlebih dahulu agar bisa mencari dan terhubung ke printer.',
                onConfirm: () {
                  AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                },
              );
            }
          },
          builder: (context, state) {
            final isLoading =
                state is PrinterLoading ||
                (state is PrinterLoaded && state.isLoading);
            final isScanning = state is PrinterLoaded && state.isScanning;
            final devices = state is PrinterLoaded
                ? state.devices
                : <BtcDevice>[];
            final discoveredDevices = state is PrinterLoaded
                ? state.discoveredDevices
                : <BtcDevice>[];
            final connectedDevice = state is PrinterLoaded
                ? state.connectedDevice
                : null;

            return LoadingOverlay(
              isLoading: isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: connectedDevice != null
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    child: Column(
                      children: [
                        Icon(
                          connectedDevice != null
                              ? Icons.print
                              : Icons.print_disabled,
                          size: 48,
                          color: connectedDevice != null
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          connectedDevice != null
                              ? 'Terhubung dengan:\n${connectedDevice.displayName}'
                              : 'Printer Tidak Terhubung',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: connectedDevice != null
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            if (connectedDevice != null)
                              ElevatedButton.icon(
                                onPressed: isLoading
                                    ? null
                                    : () => context
                                          .read<PrinterCubit>()
                                          .disconnect(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.link_off),
                                label: const Text('Putuskan Koneksi'),
                              ),
                            ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => isScanning
                                        ? context
                                              .read<PrinterCubit>()
                                              .stopScanning()
                                        : context
                                              .read<PrinterCubit>()
                                              .startScanning(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isScanning
                                    ? Colors.grey
                                    : AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(
                                isScanning
                                    ? Icons.stop
                                    : Icons.bluetooth_searching,
                              ),
                              label: Text(
                                isScanning
                                    ? 'Berhenti Mencari'
                                    : 'Cari Perangkat Baru',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Colors.blue.shade50,
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pencarian printer membutuhkan akses Lokasi dan Bluetooth aktif pada perangkat Anda.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    // 🚀 BARU: tarik ke bawah buat refresh daftar perangkat
                    child: RefreshIndicator(
                      onRefresh: () =>
                          context.read<PrinterCubit>().scanDevices(),
                      color: AppColors.primary,
                      child: ListDeviceWidget(
                        devices: devices,
                        discoveredDevices: discoveredDevices,
                        connectedDevice: connectedDevice,
                        isLoading: isLoading,
                        isScanning: isScanning,
                        onConnect: (device) =>
                            context.read<PrinterCubit>().connectDevice(device),
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
