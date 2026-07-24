import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/services/camera/recovered_camera_session.dart';
import '../../../../transaction_history/data/models/history_item_model.dart';
import '../../../domain/entities/dashboard_summary_non_jukir_entity.dart';
import '../../../domain/entities/dashboard_summary_pengawas.entity.dart';
import '../../../domain/entities/rekap_wilayah_entity.dart';

part 'home_state.freezed.dart';

enum HomeStatus { initial, loading, needsSelection, success, failure }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    RecoveredCameraSession? recoveredSession,
    String? selectedVehicleForCapture,
    @Default(0) int motorCount,
    @Default(0) int mobilCount,
    @Default(0.0) double totalPendapatan,
    @Default(0.0) double totalPajak,
    @Default(0.0) double totalBersih,
    int? selectedModePlat,
    @Default([]) List<HistoryItemModel> recentTransactions,
    @Default(false) bool isFree,
    @Default("") String nop,
    @Default("") String? namaLokasi,
    @Default("") String namaJukir,
    @Default("") String? namaOp,
    @Default("") String? namaJukirFormatted,
    @Default("") String profilePicturePath,

    @Default(0) int totalOp,
    @Default(0) int totalOpDigital,
    @Default(0) int totalOpNonDigital,

    @Default(
      OpCategoryEntity(
        total: 0,
        totalBertarif: 0,
        totalNonTarif: 0,
        totalTidakDiketahui: 0,
        persentaseBertarif: 0,
        persentaseNonTarif: 0,
        persentaseTidakDiketahui: 0,
      ),
    )
    OpCategoryEntity digital,
    @Default(0) int totalBertarif,
    @Default(0) int totalNonTarif,
    @Default(0) int totalTarifTidakDiketahui,
    @Default(
      DetailEntity(
        totalEdc: 0,
        totalRompiQris: 0,
        totalCctvCounting: 0,
        totalTs: 0,
        totalBebasParkir: 0,
        totalNonDigital: 0,
      ),
    )
    DetailEntity detail,
    @Default(BerbayarEntity(digital: 0, nonDigital: 0, total: 0, persentase: 0))
    BerbayarEntity berbayar,

    @Default(
      OpCategoryEntity(
        total: 0,
        totalBertarif: 0,
        totalNonTarif: 0,
        totalTidakDiketahui: 0,
        persentaseBertarif: 0,
        persentaseNonTarif: 0,
        persentaseTidakDiketahui: 0,
      ),
    )
    OpCategoryEntity nonDigital,

    @Default(0) double persentaseDigital,
    @Default(0) double persentaseNonDigital,

    @Default([]) List<SofParkirResultEntity> sofParkirResults,
    @Default(RoleLoginDigitalParkir.tidakDiketahui) RoleLoginDigitalParkir role,

    //Segment Pengawas
    @Default(0) int laporanPelanggaran,
    ShiftPengawasan? shiftPengawasan,
    JenisPengawasan? jenisPengawasan,
    @Default(
      CheckInOutEntity(
        idEvent: 0,
        op: '',
        nip: '',
        tglRoster: '',
        jadwalMasuk: '',
        jadwalOut: '',
        status: 0,
        checkIn: '',
        checkInString: '',
        checkInJmlMobil: 0,
        checkInJmlMotor: 0,
        checkOut: '',
        checkOutString: '',
        checkOutJmlMobil: 0,
        checkOutJmlMotor: 0,
        latitude: '',
        longitude: '',
        detailAlatCheckIn: [], // ⬅️ ganti dari detailAlat
        detailAlatCheckOut: [],
      ),
    )
    CheckInOutEntity checkInOutData,
    @Default(true) bool isOpUpToDate,
    RekapWilayahEntity? rekapWilayah,
  }) = _HomeState;
}
