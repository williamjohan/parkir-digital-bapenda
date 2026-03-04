import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class IOcrRepository {
  /// Membaca teks dari file gambar di local storage (hasil jepretan kamera)
  Future<Either<Failure, String>> recognizeTextFromImagePath(String imagePath);
}
