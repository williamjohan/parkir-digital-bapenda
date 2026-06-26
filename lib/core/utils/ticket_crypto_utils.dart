import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

class TicketCryptoUtils {
  /// Mengenkripsi payload untuk URL QR Code Bapenda
  static String encryptPayload({
    required String orderId,
    required String deviceId,
  }) {
    final raw = '$orderId[PISAH]$deviceId';
    final keyBytes = Uint8List.fromList(
      sha256.convert(utf8.encode('pisah-key-untuk-semua-bahasa')).bytes,
    );
    final ivBytes = Uint8List.fromList(
      md5.convert(utf8.encode('pisah-init-vector')).bytes,
    );

    final data = Uint8List.fromList(utf8.encode(raw));
    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );

    cipher.init(
      true, // true = encrypt
      PaddedBlockCipherParameters(
        ParametersWithIV(KeyParameter(keyBytes), ivBytes),
        null,
      ),
    );

    final encryptedBytes = cipher.process(data);
    return base64Encode(
      encryptedBytes,
    ).replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
  }
}
