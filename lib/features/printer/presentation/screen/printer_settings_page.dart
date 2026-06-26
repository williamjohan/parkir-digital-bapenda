import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../shared/loading/loading_overlay.dart';
import '../cubit/printer_cubit.dart';
import '../widgets/list_device_widget.dart'; // 🚀 Import Widget Anak

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
            }
          },
          builder: (context, state) {
            final isLoading =
                state is PrinterLoading ||
                (state is PrinterLoaded && state.isLoading);
            final devices = state is PrinterLoaded
                ? state.devices
                : <BluetoothDevice>[];
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
                              ? 'Terhubung dengan:\n${connectedDevice.name}'
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
                        if (connectedDevice != null) ...[
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () =>
                                      context.read<PrinterCubit>().disconnect(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.link_off),
                            label: const Text('Putuskan Koneksi'),
                          ),
                        ],
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Perangkat Tersimpan (Paired Devices):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListDeviceWidget(
                      devices: devices,
                      connectedDevice: connectedDevice,
                      isLoading: isLoading,
                      onConnect: (device) {
                        context.read<PrinterCubit>().connectDevice(device);
                      },
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
