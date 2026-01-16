class ObjekPajakModel {
  final String nop;
  final String nama;
  final String formattedNop;
  final String alamat;

  ObjekPajakModel({
    required this.nop,
    required this.nama,
    required this.formattedNop,
    required this.alamat,
  });

  // Factory untuk parsing dari JSON
  factory ObjekPajakModel.fromJson(Map<String, dynamic> json) {
    return ObjekPajakModel(
      nop: json['nop'] ?? '',
      nama: json['nama'] ?? '',
      formattedNop: json['formattedNop'] ?? '',
      alamat: json['alamat'] ?? '',
    );
  }
}
