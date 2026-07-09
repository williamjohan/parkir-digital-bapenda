import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/api_endpoints.dart';

enum MockScenario {
  none,
  customValidationFailed, // isSuccess:false, HTTP 200 (validasi custom generic)
  alreadyCheckedIn, // isSuccess:false, HTTP 200 (khusus check-in)
  serverError500,
  sendTimeout,
  connectionError,
  rateLimited429,
  malformedResponse, // response sukses tapi body rusak/field hilang
  wrongCredentials, // 401, isSuccess:false, message jelas
  loginNonJsonErrorBody, // 400, body plain text (test Bug 2)
  loginTokenMissing, // 200, isSuccess:true tapi accessToken kosong
  deviceUuidMismatch, // isUuidPerangkat: false
  deviceUuidCheckTimeout, // test Bug 1: network error saat cek UUID
}

class MockConfig {
  static MockScenario active = MockScenario.none;

  // Exact match — hanya endpoint yang sedang di-QC yang bisa di-mock
  static const targetEndpoints = {
    ApiEndpoints.pengawasCheckIn,
    ApiEndpoints.pengawasCheckOut,
    ApiEndpoints.addPengawasanPelaporanDev,
    ApiEndpoints.pengawasLaporanList,
    ApiEndpoints.loginDev,
    ApiEndpoints.cekUuidDev,
  };

  static String scenarioLabel(MockScenario s) {
    switch (s) {
      case MockScenario.none:
        return 'Mock OFF (network asli)';
      case MockScenario.customValidationFailed:
        return 'Validasi gagal (200, isSuccess:false)';
      case MockScenario.alreadyCheckedIn:
        return 'Sudah check-in hari ini (200, isSuccess:false)';
      case MockScenario.serverError500:
        return 'Server error 500';
      case MockScenario.sendTimeout:
        return 'Timeout kirim (sendTimeout)';
      case MockScenario.connectionError:
        return 'Tidak ada koneksi (connectionError)';
      case MockScenario.rateLimited429:
        return 'Rate limited 429';
      case MockScenario.malformedResponse:
        return 'Response sukses tapi data rusak';
      case MockScenario.wrongCredentials:
        return 'Login: username/password salah (401)';
      case MockScenario.loginNonJsonErrorBody:
        return 'Login: error body non-JSON (400)';
      case MockScenario.loginTokenMissing:
        return 'Login: sukses tapi token kosong';
      case MockScenario.deviceUuidMismatch:
        return 'Device UUID: tidak cocok';
      case MockScenario.deviceUuidCheckTimeout:
        return 'Device UUID: timeout saat cek (Bug 1)';
    }
  }
}

class DebugMockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isTarget = MockConfig.targetEndpoints.contains(options.path);
    final scenario = MockConfig.active;

    if (scenario == MockScenario.none || !isTarget) {
      return handler.next(options);
    }

    if (kDebugMode) {
      debugPrint(
        '>>> [MOCK] ${options.path} -> ${MockConfig.scenarioLabel(scenario)}',
      );
    }

    switch (scenario) {
      case MockScenario.customValidationFailed:
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'isSuccess': false,
              'statusCode': 400,
              'message': 'Validasi gagal. Periksa kembali data yang dikirim.',
            },
          ),
        );
        return;

      case MockScenario.alreadyCheckedIn:
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'isSuccess': false,
              'statusCode': 409,
              'message': 'Anda sudah melakukan check-in hari ini.',
            },
          ),
        );
        return;

      case MockScenario.serverError500:
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 500,
              data: {'message': 'Internal server error'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        return;

      case MockScenario.sendTimeout:
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.sendTimeout,
          ),
        );
        return;

      case MockScenario.connectionError:
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: const SocketExceptionStub(),
          ),
        );
        return;

      case MockScenario.rateLimited429:
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 429,
              data: {'message': 'Terlalu banyak permintaan.'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        return;

      case MockScenario.malformedResponse:
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {'isSuccess': true}, // sengaja: field 'data' hilang total
          ),
        );
        return;

      case MockScenario.wrongCredentials:
        if (options.path != ApiEndpoints.loginDev) break;
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {
                'isSuccess': false,
                'message': 'Username atau password salah.',
              },
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        return;

      case MockScenario.loginNonJsonErrorBody:
        if (options.path != ApiEndpoints.loginDev) break;
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data:
                  '<html><body>Bad Request</body></html>', // sengaja String, bukan Map
            ),
            type: DioExceptionType.badResponse,
          ),
        );
        return;

      case MockScenario.loginTokenMissing:
        if (options.path != ApiEndpoints.loginDev) break;
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'isSuccess': true,
              'data': {
                'accessToken': '', // sengaja kosong
                'refreshToken': '',
                'nop': '',
                'uuidStatic': '',
                'roleLoginId': 1,
                'nopList': [],
              },
            },
          ),
        );
        return;

      case MockScenario.deviceUuidMismatch:
        if (options.path != ApiEndpoints.cekUuidDev) break;
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'data': {'isUuidPerangkat': false},
            },
          ),
        );
        return;

      case MockScenario.deviceUuidCheckTimeout:
        if (options.path != ApiEndpoints.cekUuidDev) break;
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          ),
        );
        return;

      case MockScenario.none:
        return handler.next(options);
    }
  }
}

// Stub ringan biar gak perlu import dart:io SocketException secara langsung
class SocketExceptionStub {
  const SocketExceptionStub();
  @override
  String toString() => 'SocketException: Mocked - no connection';
}
