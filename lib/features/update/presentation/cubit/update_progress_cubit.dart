import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ota_update/ota_update.dart';
import 'update_progress_state.dart';

class UpdateProgressCubit extends Cubit<UpdateProgressState> {
  final String downloadUrl;
  final String version;

  UpdateProgressCubit({required this.downloadUrl, required this.version})
    : super(UpdateInitial());

  StreamSubscription<OtaEvent>? _otaSub;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _stuckTimer;
  Timer? _initialConnectTimer;

  double _lastProgress = -1;
  int _stuckTicks = 0;
  bool _isRetrying = false;
  bool _hasReceivedFirstEvent = false;

  // 🚀 Tuning stuck-detector: cek tiap 10 detik.
  // - 2 tick (~20s) tanpa perubahan -> SOFT WARNING (ubah pesan, TIDAK gagal).
  //   Sinyal lapangan lemah wajar diam beberapa saat tapi sebenarnya masih jalan.
  // - 5 tick (~50s) tanpa perubahan -> HARD FAIL (baru dianggap benar-benar macet).
  static const _tickInterval = Duration(seconds: 10);
  static const _softWarnTicks = 2;
  static const _hardFailTicks = 5;

  // 🚀 Kalau dalam 20 detik pertama belum ada OtaEvent SAMA SEKALI
  // (native belum sempat mulai download / DNS gagal / hang di awal),
  // jangan biarkan user terjebak selamanya di "Menghubungkan...".
  static const _initialConnectTimeout = Duration(seconds: 20);

  /// Entry point
  void start() {
    if (Platform.isIOS) return;

    // 🚀 FIX: guard double-start (misal user tap "Coba Lagi" dua kali cepat,
    // atau widget rebuild sebelum sub lama sempat di-cancel). Tanpa guard ini
    // ota_update plugin bisa balas ALREADY_RUNNING_ERROR yang sebelumnya
    // tidak ditangani sama sekali (jatuh ke default: break, diam saja).
    if (_otaSub != null) return;

    _hasReceivedFirstEvent = false;
    _lastProgress = -1;
    _stuckTicks = 0;

    _startMonitoring();
    _startDownload();
  }

  void _startMonitoring() {
    _connectivitySub?.cancel();
    _stuckTimer?.cancel();
    _initialConnectTimer?.cancel();

    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        _emitError("Koneksi internet terputus.");
      }
    });

    // Fase "Menghubungkan..." sebelum event pertama datang
    _initialConnectTimer = Timer(_initialConnectTimeout, () {
      if (!_hasReceivedFirstEvent) {
        _emitError(
          "Gagal terhubung ke server unduhan. Periksa koneksi internet Anda.",
        );
      }
    });

    _stuckTimer = Timer.periodic(_tickInterval, (_) {
      final state = this.state;
      if (state is! UpdateDownloading) return;

      if (state.progress == _lastProgress && state.progress < 0.99) {
        _stuckTicks++;

        if (_stuckTicks >= _hardFailTicks) {
          _emitError("Koneksi terlalu lambat / terputus. Coba lagi.");
          return;
        }

        if (_stuckTicks >= _softWarnTicks) {
          // Soft warning: kasih tahu user, TAPI JANGAN gagalkan proses.
          // Sinyal lapangan yang lemah masih wajar diam beberapa saat.
          emit(
            UpdateDownloading(
              progress: state.progress,
              message:
                  "Koneksi lambat, mohon tunggu... (${(state.progress * 100).toStringAsFixed(0)}%)",
            ),
          );
        }
      } else {
        _stuckTicks = 0;
      }
      _lastProgress = state.progress;
    });
  }

  void _startDownload() {
    _otaSub?.cancel();

    try {
      _otaSub = OtaUpdate()
          .execute(
            downloadUrl,
            destinationFilename:
                'cek_reklame_v${version.replaceAll(" ", "_")}.apk',
          )
          .listen(
            _onOtaEvent,
            onError: (_) {
              _emitError("Terjadi kesalahan koneksi.");
            },
          );
    } catch (_) {
      _emitError("Gagal memulai unduhan.");
    }
  }

  void _onOtaEvent(OtaEvent event) {
    _hasReceivedFirstEvent = true;
    _initialConnectTimer?.cancel();

    final raw = event.value ?? '0';
    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final percent = (double.tryParse(clean) ?? 0) / 100;

    switch (event.status) {
      case OtaStatus.DOWNLOADING:
        _stuckTicks = 0;
        emit(
          UpdateDownloading(progress: percent, message: "Mengunduh: $clean%"),
        );
        break;

      case OtaStatus.INSTALLING:
        _disposeMonitoring();
        emit(const UpdateInstalling());

        Future.delayed(const Duration(seconds: 2), () {
          emit(const UpdateCompleted());
        });
        break;

      case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
        _emitError("Izin instalasi ditolak. Aktifkan izin lalu coba lagi.");
        break;

      case OtaStatus.INTERNAL_ERROR:
        _emitError("Gagal mengunduh file (kesalahan internal).");
        break;

      // 🚀 FIX: sebelumnya jatuh ke default (diam) -> user stuck permanen.
      // DOWNLOAD_ERROR terjadi kalau HTTP response gagal (404/500/link
      // kadaluarsa/file sudah dipindah dari server) — sangat mungkin terjadi
      // untuk update yang belum ada di Play Store (link download manual).
      case OtaStatus.DOWNLOAD_ERROR:
        _emitError(
          "Gagal mengunduh berkas pembaruan dari server. Coba lagi beberapa saat.",
        );
        break;

      // 🚀 FIX: sebelumnya jatuh ke default (diam). Ini menandakan ada
      // proses download lain yang masih aktif — bukan error fatal untuk
      // user, cukup abaikan (download yang sedang berjalan tetap lanjut).
      case OtaStatus.ALREADY_RUNNING_ERROR:
        break;

      default:
        // Status baru dari versi plugin yang lebih baru & belum kita kenal.
        // Jangan biarkan diam total tanpa jejak — minimal tercatat di log,
        // tapi TIDAK menggagalkan proses yang mungkin masih berjalan normal.
        break;
    }
  }

  void _emitError(String message) {
    if (_isRetrying) return;

    _disposeMonitoring();
    emit(UpdateError(message: message));
  }

  Future<void> retry() async {
    _isRetrying = true;
    _otaSub?.cancel();
    _otaSub = null;

    emit(
      const UpdateDownloading(
        progress: 0.0,
        message: "Menghubungkan kembali...",
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      _isRetrying = false;
      emit(const UpdateError(message: "Koneksi masih terputus."));
      return;
    }

    _isRetrying = false;
    _hasReceivedFirstEvent = false;
    _lastProgress = -1;
    _stuckTicks = 0;

    _startMonitoring();
    _startDownload();
  }

  void _disposeMonitoring() {
    _otaSub?.cancel();
    _otaSub = null;
    _connectivitySub?.cancel();
    _stuckTimer?.cancel();
    _initialConnectTimer?.cancel();
  }

  @override
  Future<void> close() {
    _disposeMonitoring();
    return super.close();
  }
}
