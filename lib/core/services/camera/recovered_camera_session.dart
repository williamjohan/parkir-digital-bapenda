import 'dart:io';
import '../../enums/app_enums.dart';

class RecoveredCameraSession {
  final File file;
  final CameraModuleIntent intent;

  RecoveredCameraSession({required this.file, required this.intent});
}
