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
    final result = await repository.recognizeTextFromImagePath(imagePath);

    return result.fold(
      (failure) => Left(failure), // Jika ML Kit gagal, teruskan kegagalan ke UI
      (rawText) {
        final formattedPlate = PlateParser.extractPlateNumber(rawText);

        if (formattedPlate != null) {
          return Right(
            LicensePlate(
              rawText: rawText,
              formattedNumber: formattedPlate,
              isValid: true,
            ),
          );
        } else {
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
