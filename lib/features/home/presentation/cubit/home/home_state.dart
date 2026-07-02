import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/utils/permission_utils.dart';
import '../../../../transaction_history/data/models/history_item_model.dart';
import '../../../data/models/weekly_chart_item_model.dart';
import '../../../domain/entities/dashboard_summary_non_jukir_entity.dart';
import '../../../domain/entities/dashboard_summary_pengawas.entity.dart';

part 'home_state.freezed.dart';

enum HomeStatus { initial, loading, success, failure }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    CameraPermissionStatus? permissionActionStatus,
    String? selectedVehicleForCapture,
    int? actionTimestamp,
    @Default(0) int motorCount,
    @Default(0) int mobilCount,
    @Default(0.0) double totalPendapatan,
    @Default(0.0) double totalPajak,
    @Default(0.0) double totalBersih,
    int? selectedModePlat,
    @Default([]) List<HistoryItemModel> recentTransactions,
    @Default([]) List<WeeklyChartItemModel> weeklyChartData,
    @Default(false) bool isFree,
    @Default("") String nop,
    @Default("") String namaLokasi,
    @Default("") String namaJukir,
    @Default("") String namaOp,
    @Default("") String namaJukirFormatted,
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
        detailAlat: [],
      ),
    )
    CheckInOutEntity checkInOutData,
  }) = _HomeState;
}
