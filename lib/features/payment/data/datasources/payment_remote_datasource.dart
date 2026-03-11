import 'package:injectable/injectable.dart';

abstract class IPaymentRemoteDataSource {
  /// Menerima kategori (Mobil/Motor) dan mengembalikan respons mentah (JSON/Map)
  Future<Map<String, dynamic>> requestQrisData(String kategoriKendaraan);
}

@LazySingleton(as: IPaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements IPaymentRemoteDataSource {
  @override
  Future<Map<String, dynamic>> requestQrisData(String kategoriKendaraan) async {
    // 1. SIMULASI LATENCY JARINGAN (Seolah-olah nunggu server Bapenda)
    await Future.delayed(const Duration(seconds: 2));

    // 2. LOGIK BISNIS (DUMMY SERVER)
    // Nanti saat BE siap, blok ini tinggal diganti dengan:
    // final response = await dio.post('/api/qris', data: {'kategori': kategoriKendaraan});
    // return response.data;

    final isMobil = kategoriKendaraan.toLowerCase() == 'mobil';
    final int nominalTarif = isMobil ? 5000 : 2000;

    // Kembalikan dalam bentuk "Raw JSON" layaknya respons API asli
    return {
      'status': 'success',
      'data': {
        'nominal': nominalTarif,
        'qr_string':
            '00020101021226590011ID.CO.BPDJATIM.WWW0118936001220000028247020F00000000000000005204581453033605802ID5919BAPENDA KOTA SURABAYA6013KOTA SURABAYA610560275624701140224021204090507202741910712202402122404073347526304EDCB',
      },
    };
  }
}
