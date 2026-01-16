class TransactionModel {
  final int id;
  final String orderId;
  final String jenisTarif;
  final String sof;
  final String acquirer;
  final String noKartuKue;
  final String noTrx;
  final String platNumber;
  final String tglTrx;
  final int kredit;
  final int saldo;
  final String kodeGate;
  final String namaGate;
  final String namaPetugas;
  final String latitude;
  final String longitude;
  final String shift;
  final String nop;
  final String jenisParkir;

  TransactionModel({
    this.id = 0,
    required this.orderId,
    required this.jenisTarif,
    required this.sof,
    required this.acquirer,
    required this.noKartuKue,
    required this.noTrx,
    required this.platNumber,
    required this.tglTrx,
    required this.kredit,
    required this.saldo,
    required this.kodeGate,
    required this.namaGate,
    required this.namaPetugas,
    required this.latitude,
    required this.longitude,
    required this.shift,
    required this.nop,
    required this.jenisParkir,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "orderId": orderId,
      "jenisTarif": jenisTarif,
      "sof": sof,
      "acquirer": acquirer,
      "noKartuKUE": noKartuKue, // Sesuai field API
      "noTRX": noTrx,
      "platNumber": platNumber,
      "tglTrx": tglTrx,
      "kredit": kredit,
      "saldo": saldo,
      "kodeGate": kodeGate,
      "namaGate": namaGate,
      "namaPetugas": namaPetugas,
      "latitude": latitude,
      "longitude": longitude,
      "shift": shift,
      "nop": nop,
      "jenisParkir": jenisParkir,
      // Field lain yang mungkin dibutuhkan dummy tapi statis
      "petugasId": 1,
      "lokasiId": 1,
      "namaLokasi": "Surabaya Pusat",
      "deviceId": "POS-001",
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      orderId: json['orderId'] ?? '',
      jenisTarif: json['jenisTarif'] ?? '',
      sof: json['sof'] ?? '',
      acquirer: json['acquirer'] ?? '',
      noKartuKue: json['noKartuKUE'] ?? '',
      noTrx: json['noTRX'] ?? '',
      platNumber: json['platNumber'] ?? '',
      tglTrx: json['tglTrx'] ?? '',
      kredit: json['kredit'] ?? 0,
      saldo: json['saldo'] ?? 0,
      kodeGate: json['kodeGate'] ?? '',
      namaGate: json['namaGate'] ?? '',
      namaPetugas: json['namaPetugas'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      shift: json['shift'] ?? '',
      nop: json['nop'] ?? '',
      jenisParkir: json['jenisParkir'] ?? '',
    );
  }
}
