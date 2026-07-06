import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ota_update/ota_update.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool _downloadCompleted = false;
  bool _lastErrorWasPermission = false;

  static const _tickInterval = Duration(seconds: 10);
  static const _softWarnTicks = 2;
  static const _hardFailTicks = 5;
  static const _initialConnectTimeout = Duration(seconds: 20);

  Future<void> start() async {
    if (Platform.isIOS) return;
    if (_otaSub != null) return;

    final hasPermission = await _ensureInstallPermission();
    if (!hasPermission) return;

    _resetTrackingState();
    _startMonitoring();
    _startDownload();
  }

  Future<bool> _ensureInstallPermission() async {
    final status = await Permission.requestInstallPackages.status;
    if (status.isGranted) return true;

    // 🚀 Berikan UX yang halus saat OS meminta izin (tidak freeze mendadak)
    emit(
      const UpdateDownloading(
        progress: 0.0,
        message: "Memeriksa izin sistem...",
      ),
    );

    final result = await Permission.requestInstallPackages.request();
    if (result.isGranted) return true;

    _lastErrorWasPermission = true;
    emit(
      const UpdateError(
        message:
            'Instalasi tidak dapat dilanjutkan: izin "Instal aplikasi '
            'tidak dikenal" belum diaktifkan untuk aplikasi ini. '
            'Tekan "Coba Lagi" untuk membuka Pengaturan.',
      ),
    );
    return false;
  }

  void _resetTrackingState() {
    _hasReceivedFirstEvent = false;
    _lastProgress = -1;
    _stuckTicks = 0;
    _downloadCompleted = false;
    _lastErrorWasPermission = false;
  }

  void _startMonitoring() {
    _disposeMonitoring(); // 🚀 Pastikan timer lama benar-benar mati sebelum bikin baru

    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        _emitError(
          _downloadCompleted
              ? "Pemasangan terhenti: koneksi internet terputus."
              : "Unduhan terhenti: koneksi internet terputus.",
        );
      }
    });

    _initialConnectTimer = Timer(_initialConnectTimeout, () {
      if (!_hasReceivedFirstEvent) {
        _emitError(
          "Gagal memulai unduhan: tidak dapat terhubung ke server. "
          "Periksa koneksi internet Anda.",
        );
      }
    });

    _stuckTimer = Timer.periodic(_tickInterval, (_) {
      final state = this.state;
      if (state is! UpdateDownloading) return;

      if (state.progress == _lastProgress && state.progress < 0.99) {
        _stuckTicks++;

        if (_stuckTicks >= _hardFailTicks) {
          _emitError("Unduhan terhenti: koneksi terlalu lambat. Coba lagi.");
          return;
        }

        if (_stuckTicks >= _softWarnTicks) {
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
            usePackageInstaller: true,
          )
          .listen(
            _onOtaEvent,
            onError: (_) {
              _emitError(
                _downloadCompleted
                    ? "Pemasangan gagal: terjadi kesalahan tak terduga."
                    : "Unduhan gagal: terjadi kesalahan koneksi.",
              );
            },
            onDone: () {
              final current = state;
              final alreadyTerminal =
                  current is UpdateInstalling ||
                  current is UpdateCompleted ||
                  current is UpdateError;

              if (!alreadyTerminal) {
                _emitError(
                  _downloadCompleted
                      ? 'Pemasangan terhenti tak terduga. Pastikan izin '
                            '"Instal aplikasi tidak dikenal" sudah aktif, lalu coba lagi.'
                      : 'Unduhan terhenti tak terduga. Coba lagi.',
                );
              }
            },
            cancelOnError: true,
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
        _downloadCompleted = true;
        _disposeMonitoring();
        emit(const UpdateInstalling());

        Future.delayed(const Duration(seconds: 2), () {
          emit(const UpdateCompleted());
        });
        break;

      case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
        _lastErrorWasPermission = true;
        _emitError(
          'Pemasangan dibatalkan: izin "Instal aplikasi tidak dikenal" '
          'belum diaktifkan. Tekan "Coba Lagi" untuk membuka Pengaturan.',
        );
        break;

      case OtaStatus.INTERNAL_ERROR:
        _emitError(
          _downloadCompleted
              ? "Pemasangan gagal (kesalahan internal)."
              : "Unduhan gagal (kesalahan internal).",
        );
        break;

      case OtaStatus.DOWNLOAD_ERROR:
        _emitError(
          "Gagal mengunduh berkas pembaruan dari server. Coba lagi beberapa saat.",
        );
        break;

      case OtaStatus.ALREADY_RUNNING_ERROR:
        break;

      default:
        break;
    }
  }

  void _emitError(String message) {
    if (_isRetrying) return;

    _disposeMonitoring();
    emit(UpdateError(message: message));
  }

  Future<void> retry() async {
    if (_lastErrorWasPermission) {
      // 🚀 FIX ANTI-JEBAKAN: Reset flag setelah melempar ke Settings!
      // Agar saat user kembali ke app dan klik "Coba Lagi", proses download ulang benar-benar berjalan.
      _lastErrorWasPermission = false;
      await openAppSettings();

      // Ubah UI agar terlihat sedang menunggu user bertindak, bukan error mati
      emit(
        const UpdateDownloading(
          progress: 0.0,
          message: "Menunggu izin dari sistem operasi...",
        ),
      );
      return;
    }

    _isRetrying = true;
    _disposeMonitoring(); // Bersihkan yang lama sebelum retry

    emit(
      const UpdateDownloading(
        progress: 0.0,
        message: "Menghubungkan kembali...",
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      _isRetrying = false;
      emit(const UpdateError(message: "Koneksi masih terputus."));
      return;
    }

    final hasPermission = await _ensureInstallPermission();
    if (!hasPermission) {
      _isRetrying = false;
      return;
    }

    _isRetrying = false;
    _resetTrackingState();
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
    // 🚀 Bantu Garbage Collector bersihkan memori seutuhnya
    _isRetrying = false;
    _lastErrorWasPermission = false;
    _downloadCompleted = false;
    _hasReceivedFirstEvent = false;
    return super.close();
  }
}
