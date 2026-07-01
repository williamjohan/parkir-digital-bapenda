import 'package:equatable/equatable.dart';

class PengawasanEntity extends Equatable {
  final String name;
  final String description;
  final String foto;
  final KategoriLaporanEntity kategoriLaporan;

  const PengawasanEntity({
    required this.name,
    required this.description,
    required this.foto,
    required this.kategoriLaporan,
  });

  @override
  List<Object?> get props => [name, description, foto, kategoriLaporan];
}

class KategoriLaporanEntity extends Equatable {
  final String id;
  final String name;
  const KategoriLaporanEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
