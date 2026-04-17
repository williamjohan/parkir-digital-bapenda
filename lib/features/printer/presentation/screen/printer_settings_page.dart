import 'package:app_settings/app_settings.dart' as external_settings;
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/loading/loading_overlay.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../cubit/printer_cubit.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  @override
  void initState() {
    super.initState();
    // 🚀 Jalankan scan otomatis saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrinterCubit>().scanDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Printer', style: AppTypography.heading5),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
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
              // 🚀 Ganti Stack dengan Column murni (lebih aman)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- KARTU STATUS KONEKSI ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: connectedDevice != null
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  child: Column(
                    children: [
                      Icon(
                        connectedDevice != null
                            ? Icons.print
                            : Icons.print_disabled,
                        size: 48,
                        color: connectedDevice != null
                            ? Colors.green
                            : Colors.red,
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
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                      if (connectedDevice != null) ...[
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.read<PrinterCubit>().disconnect(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.link_off),
                          label: const Text('Putuskan Koneksi'),
                        ),
                      ],
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Perangkat Tersimpan (Paired Devices):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // --- DAFTAR BLUETOOTH ---
                Expanded(
                  child: devices.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Tidak ada perangkat Bluetooth yang di-pair.\nSilakan sambungkan Printer di pengaturan Android Anda terlebih dahulu.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, height: 1.5),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final device = devices[index];
                            final isThisConnected =
                                connectedDevice?.address == device.address;

                            return ListTile(
                              leading: Icon(
                                Icons.bluetooth,
                                color: isThisConnected
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              title: Text(
                                device.name ?? 'Unknown Device',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(device.address ?? ''),
                              trailing: isThisConnected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : ElevatedButton(
                                      onPressed: () => context
                                          .read<PrinterCubit>()
                                          .connectDevice(device),
                                      child: const Text('Konek'),
                                    ),
                            );
                          },
                        ),
                ),

                //-- Info untuk buka pengaturan Bluetooth --
                Padding(
                  padding: const EdgeInsets.all(16.0), // 🚀 Beri jarak aman
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Printer tidak ditemukan?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Pastikan printer sudah di-pairing (sambungkan) di menu pengaturan Bluetooth HP Anda.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await external_settings.AppSettings.openAppSettings(
                              type: external_settings.AppSettingsType.bluetooth,
                            );
                          },
                          icon: const Icon(Icons.settings_bluetooth),
                          label: const Text("Buka Pengaturan Bluetooth"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
