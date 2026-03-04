import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/plate_parser.dart';
import '../entities/license_plate.dart';
import '../repositories/i_ocr_repository.dart';

@lazySingleton
class ExtractLicensePlateUseCase {
  final IOcrRepository repository;

  ExtractLicensePlateUseCase(this.repository);

  /// Menjalankan alur OCR dan pembersihan teks
  Future<Either<Failure, LicensePlate>> execute(String imagePath) async {
    // 1. Dapatkan teks kotor dari gambar via Repository (ML Kit)
    final result = await repository.recognizeTextFromImagePath(imagePath);

    return result.fold(
      (failure) => Left(failure), // Jika ML Kit gagal, teruskan kegagalan ke UI
      (rawText) {
        // 2. Ekstrak plat nomor bersih menggunakan Regex
        final formattedPlate = PlateParser.extractPlateNumber(rawText);

        if (formattedPlate != null) {
          // Jika Regex berhasil menemukan pola plat nomor
          return Right(
            LicensePlate(
              rawText: rawText,
              formattedNumber: formattedPlate,
              isValid: true,
            ),
          );
        } else {
          // Jika OCR berhasil membaca teks, tapi tidak ada yang bentuknya seperti plat nomor
          return const Left(
            OcrFailure(
              'Tidak ditemukan plat nomor yang valid pada gambar. Pastikan gambar jelas dan tidak terpotong.',
            ),
          );
        }
      },
    );
  }
}
