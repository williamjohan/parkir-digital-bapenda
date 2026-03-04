import 'package:equatable/equatable.dart';

class LicensePlate extends Equatable {
  final String rawText; // Teks kotor asli dari OCR (untuk keperluan log/debug)
  final String formattedNumber; // Teks bersih hasil Regex
  final bool isValid; // Flag jika plat sesuai standar

  const LicensePlate({
    required this.rawText,
    required this.formattedNumber,
    required this.isValid,
  });

  @override
  List<Object?> get props => [rawText, formattedNumber, isValid];
}
