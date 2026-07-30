import 'dart:io';
import '../../enums/app_enums.dart';

class RecoveredCameraSession {
  final File file;
  final CameraModuleIntent intent;
  final String? nop;
  final JenisPengawasan? jenis;
  final ShiftPengawasan? shift;

  RecoveredCameraSession({
    required this.file,
    required this.intent,
    this.nop,
    this.jenis,
    this.shift,
  });
}
