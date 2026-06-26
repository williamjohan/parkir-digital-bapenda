import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/i_ocr_repository.dart';
import '../datasources/ocr_local_data_source.dart';

@LazySingleton(as: IOcrRepository)
class OcrRepositoryImpl implements IOcrRepository {
  final IOcrLocalDataSource localDataSource;

  OcrRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, String>> recognizeTextFromImagePath(
    String imagePath,
  ) async {
    try {
      final rawText = await localDataSource.recognizeText(imagePath);

      if (rawText.trim().isEmpty) {
        return const Left(
          OcrFailure('Tidak ada teks yang terdeteksi pada gambar.'),
        );
      }

      return Right(rawText);
    } on OcrException catch (e) {
      return Left(OcrFailure(e.message));
    } catch (e) {
      return const Left(
        OcrFailure('Terjadi kesalahan sistem saat membaca gambar.'),
      );
    }
  }
}
