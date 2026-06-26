import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/sync_parking_transactions_usecase.dart';
import 'sync_state.dart';

@injectable
class SyncCubit extends Cubit<SyncState> {
  final SyncParkingTransactionsUseCase _syncUseCase;

  SyncCubit(this._syncUseCase) : super(SyncInitial());

  /// Fungsi ini bisa dipanggil kapan saja (setelah tap bayar, pull to refresh, dll)
  Future<void> syncDataBackground() async {
    if (state is SyncInProgress) return;

    emit(SyncInProgress());
    final result = await _syncUseCase.execute();

    result.fold(
      (failure) {
        if (!isClosed) emit(SyncFailure(failure.message));
      },
      (syncedCount) {
        if (!isClosed) emit(SyncSuccess(syncedCount));
        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) emit(SyncInitial());
        });
      },
    );
  }
}
