import 'package:geolocator/geolocator.dart'; // Dibutuhkan untuk mengecek & membuka setting GPS
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';
import 'package:permission_handler/permission_handler.dart';
import 'i_permission_service.dart';

@LazySingleton(as: IPermissionService)
class PermissionServiceImpl implements IPermissionService {
  @override
  Future<AppPermissionStatus> requestPermission(AppPermissionType type) async {
    switch (type) {
      case AppPermissionType.camera:
        return await _handleSinglePermission(Permission.camera);

      case AppPermissionType.location:
        return await _handleSinglePermission(Permission.location);

      case AppPermissionType.notification:
        return await _handleSinglePermission(Permission.notification);

      case AppPermissionType.storage:
        return await _handleSinglePermission(Permission.storage);

      case AppPermissionType.photos:
        return await _handleSinglePermission(Permission.photos);

      case AppPermissionType.microphone:
        return await _handleSinglePermission(Permission.microphone);

      case AppPermissionType.bluetooth:
        return await _handleBluetoothPermissions();

      case AppPermissionType.locationService:
        return await _handleLocationHardwareService();
    }
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }

  @override
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // ===========================================================================
  // PRIVATE HELPER METHODS
  // ===========================================================================

  Future<AppPermissionStatus> _handleSinglePermission(
    Permission permission,
  ) async {
    final status = await permission.request();

    if (status.isGranted) {
      return AppPermissionStatus.granted;
    } else if (status.isPermanentlyDenied) {
      return AppPermissionStatus.permanentlyDenied;
    } else {
      return AppPermissionStatus.denied;
    }
  }

  Future<AppPermissionStatus> _handleBluetoothPermissions() async {
    try {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();

      final scanStatus =
          statuses[Permission.bluetoothScan] ?? PermissionStatus.denied;
      final connectStatus =
          statuses[Permission.bluetoothConnect] ?? PermissionStatus.denied;
      final locationStatus =
          statuses[Permission.locationWhenInUse] ?? PermissionStatus.denied;

      if (scanStatus.isGranted &&
          connectStatus.isGranted &&
          locationStatus.isGranted) {
        return AppPermissionStatus.granted;
      }

      if (scanStatus.isPermanentlyDenied ||
          connectStatus.isPermanentlyDenied ||
          locationStatus.isPermanentlyDenied) {
        return AppPermissionStatus.permanentlyDenied;
      }

      if (await Permission.bluetoothScan.isPermanentlyDenied ||
          await Permission.bluetoothConnect.isPermanentlyDenied ||
          await Permission.locationWhenInUse.isPermanentlyDenied) {
        return AppPermissionStatus.permanentlyDenied;
      }

      return AppPermissionStatus.denied;
    } catch (_) {
      return AppPermissionStatus.denied;
    }
  }

  /// Mengecek apakah sensor GPS menyala atau mati
  Future<AppPermissionStatus> _handleLocationHardwareService() async {
    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();

    // Jika GPS mati, kita anggap ini "permanentlyDenied" agar UI memunculkan
    // tombol "Buka Pengaturan" (yang nanti akan ditrigger ke openLocationSettings)
    if (!isGpsEnabled) {
      return AppPermissionStatus.permanentlyDenied;
    }

    return AppPermissionStatus.granted;
  }
}
