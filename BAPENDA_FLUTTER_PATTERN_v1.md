# Bapenda Mobile — Architecture & Development Standard

**Status:** Dokumen Acuan Resmi (Single Source of Truth)

**Target Aplikasi:** Parkir Digital Bapenda, Surabaya Tax, dan Proyek Turunan Lainnya.

**Wajib dipatuhi oleh seluruh kontributor — Tim Internal Bapenda maupun Tim Mitra Eksternal (Energeek).**

---

## 1. Filosofi & Latar Belakang

Standar arsitektur ini disusun sebagai landasan teknis utama dalam membangun dan mengembangkan seluruh ekosistem aplikasi di bawah payung Bapenda Mobile. Lahir dari tanggung jawab besar untuk mengelola sistem transaksi publik dan perpajakan daerah yang aman, andal, dan berkinerja tinggi, standar ini dirumuskan dengan mengadopsi pola yang best practice (*production-proven*) pada aplikasi **Parkir Digital Bapenda** dan **Surabaya Tax**.

Kami memilih pendekatan **Clean Architecture berbasis fitur** (CA — *Clean Architecture*: pendekatan arsitektur yang memisahkan kode menjadi 3 lapisan independen — data, domain/bisnis, dan tampilan — agar masing-masing bisa berubah tanpa saling merusak) karena beberapa alasan krusial:

- **Kedaulatan & Keamanan Sistem:** Mengisolasi aturan bisnis perpajakan yang sakral agar mandiri dan tidak terikat oleh perubahan teknologi luar, dependensi pihak ketiga, maupun dinamika di tingkat infrastruktur backend.
- **Skalabilitas Kolaborasi:** Menjamin banyak developer (baik internal maupun mitra eksternal) dapat bekerja secara paralel pada fitur yang berbeda tanpa saling bertabrakan atau menciptakan penumpukan konflik kode (*merge conflict* — kondisi ketika dua orang mengubah baris kode yang sama dan Git tidak bisa menggabungkannya otomatis).
- **Predictability over Individual Style:** Menghilangkan kebiasaan menulis kode berdasarkan preferensi subjektif individu, dan menggantinya dengan standar yang dapat diprediksi demi menekan utang teknis (*technical debt* — pekerjaan perbaikan yang tertunda karena dulu memilih jalan pintas) dalam jangka panjang.
- **Zero Trust on Bad Data:** Validasi dan proteksi data dilakukan sedini mungkin, sebelum data kotor sempat menyentuh logika bisnis inti.

### Prinsip Utama

- **Predictable over Flexible** — Setiap fitur wajib punya bentuk struktur yang sama. Siapa pun harus bisa membuka feature manapun dan langsung tahu di mana mencari sesuatu, tanpa menebak-nebak.
- **Separation of Concerns (SoC — Pemisahan Tanggung Jawab)** — Pemisahan kode didasarkan pada domain fungsional dan tanggung jawab arsitektural, bukan kerapian visual folder semata.
- **Shared Only If Shared** — Sesuatu (enum, util, value object, widget) baru naik level ke folder yang lebih umum (`core`/`shared`) **kalau benar-benar dipakai oleh 2 fitur atau lebih**. Selama hanya dipakai 1 fitur, dia tinggal di dalam fitur itu sendiri. Aturan lengkap di Bagian 5.6.

---

## 2. Environment & Workflow Discipline

### 2.1 FVM (Flutter Version Management)

FVM adalah alat untuk mengunci versi Flutter SDK yang sama persis di semua komputer developer, supaya tidak ada masalah "kode jalan di laptop saya, tapi error di laptop kamu" akibat beda versi Flutter.

> **Catatan status:** FVM saat ini belum digunakan di project existing. Untuk fase awal kolaborasi dengan tim Energeek, FVM dicatat sebagai **roadmap perbaikan**, bukan kewajiban langsung — supaya proses onboarding tidak terhambat. Target: diadopsi setelah struktur dasar pattern ini berjalan stabil.

Ketika nanti diaktifkan, polanya seperti ini:

```bash
# Menyelaraskan SDK lokal dengan proyek
fvm install

# Menjalankan aplikasi
fvm flutter run

# Menjalankan code generator
fvm dart run build_runner build --delete-conflicting-outputs
```

### 2.2 Flavor & Environment (Demo / Production)

Aplikasi Bapenda Mobile mendukung 2 mode environment: **Demo** dan **Production**. Mekanismenya ada di dua lapisan:

1. **Native layer** — pengaturan flavor dilakukan di `build.gradle.kts` (Android) untuk membedakan build demo dan prod di level sistem build Android.
2. **Local development** — file `.vscode/launch.json` sudah disiapkan agar developer bisa langsung tekan F5 di VS Code untuk memilih mode mana yang ingin dijalankan, tanpa harus mengetik command manual tiap kali.
3. **Konfigurasi runtime** — dibedakan lewat 2 file environment: `.env.demo` dan `.env.prod`, dibaca lewat `flutter_dotenv`.

**Pembacaan environment saat ini** (`lib/core/network/env_config.dart`):

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Pastikan inisialisasi ini dipanggil di main.dart: await dotenv.load();
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}
```

**Rekomendasi pengembangan `EnvConfig` ke depan** (placeholder, isi sesuai kebutuhan saat dipakai — bukan kewajiban langsung hari ini):

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  // Contoh perluasan: endpoint layanan realtime (SignalR hub), kalau alamatnya beda dari baseUrl
  static String get signalRHubUrl => dotenv.env['SIGNALR_HUB_URL'] ?? '';

  // Contoh perluasan: identifikasi mode environment saat ini, untuk logika kondisional (misal: nonaktifkan fitur tertentu di demo)
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'demo';
  static bool get isProduction => appEnv == 'prod';

  // Contoh perluasan: validasi wajib saat startup, supaya app gagal cepat dan jelas
  // kalau file .env lupa di-load atau salah nama, daripada diam-diam jalan dengan baseUrl kosong
  // dan errornya baru ketahuan nanti saat request API gagal tanpa pesan yang jelas.
  static void validateOrThrow() {
    if (baseUrl.isEmpty) {
      throw Exception('BASE_URL tidak ditemukan. Pastikan file .env sudah benar dan ter-load di main.dart.');
    }
  }
}
```

### 2.3 Git & Commit Convention

**Penamaan Branch:**
- Fitur baru: `feature/<nomor_tiket>-deskripsi_singkat`
- Perbaikan bug: `bugfix/<nomor_tiket>-deskripsi_singkat`
- Pembersihan kode: `chore/<nomor_tiket>-deskripsi_singkat`

**Pola Commit (Conventional Commits — format pesan commit standar industri agar riwayat Git mudah dibaca):**
- `feat(<fitur>):` Menambahkan fungsionalitas baru.
- `fix(<fitur>):` Memperbaiki bug/crash.
- `refactor(<fitur>):` Mengubah struktur kode tanpa mengubah perilaku aplikasi.
- `docs(<fitur>):` Mengubah dokumentasi/README.

**Checklist Sebelum Push:**
- [ ] `flutter analyze` — 0 Errors / 0 Warnings.
- [ ] `dart format lib/ test/`
- [ ] Tidak ada kode mati (*commented-out code* — baris kode yang dinonaktifkan dengan tanda komentar tapi dibiarkan menumpuk) yang tertinggal tanpa keterangan jelas.
- [ ] Tidak ada `print()` atau `debugPrint()` untuk debugging — gunakan `AppLogger` resmi.
- [ ] Comment penjelasan panjang dipindahkan ke `readme.md` fitur terkait (lihat Bagian 6), bukan menumpuk sebagai comment block di kode.

---

## 3. Struktur Top-Level

```
lib/
├── core/
├── features/
├── shared/
└── main.dart
```

| Folder | Definisi | Uji Cepat |
|---|---|---|
| `core/` | Infrastruktur teknis & hal generic yang **tidak tahu apa-apa soal bisnis**. | *"Kalau folder ini dipindah ke project Flutter lain yang bisnisnya sama sekali berbeda, apakah masih bisa jalan tanpa error?"* — kalau ya, masuk `core`. |
| `shared/` | Widget atau screen **gabungan (composite)** yang punya state/perilaku sendiri terkait alur aplikasi (loading, error, empty state), dipakai oleh 2+ fitur, tapi bukan primitif UI murni. | *"Apakah dia sudah punya 'opini' soal kapan dipakai (loading saat apa, error untuk apa), bukan sekadar tampilan kosong?"* — kalau ya dan dipakai bersama, masuk `shared`. |
| `features/` | Logika bisnis spesifik per domain (pembayaran, dashboard, dll). Wajib Clean Architecture penuh. | *"Apakah ini hanya make sense dalam konteks 1 proses bisnis tertentu?"* — kalau ya, masuk `features`. |

---

## 4. `core/` — Detail Isi

```
lib/core/
├── constants/
│   ├── app_asset_constant.dart
│   ├── app_constant.dart
│   ├── app_string_constant.dart
│   └── app_validator_string_constant.dart
├── design_system/
│   ├── components/        # Primitif UI murni, prefix pb_ (Parkir Bapenda) atau st_ (Surabaya Tax)
│   └── tokens/             # app_colors, app_typography, app_spacing, app_radius, app_shadows, app_theme
├── di/                     # injectable + get_it
│   ├── injection.config.dart   # Generated file — JANGAN diedit manual
│   ├── injection.dart
│   └── register_module.dart
├── enums/                  # Enum yang benar-benar generic, dipakai 2+ fitur (lihat aturan Bagian 5.6)
├── errors/
│   ├── exception.dart      # ServerException, CacheException
│   └── failure.dart        # ServerFailure, CacheFailure — dipakai bersama Either<Failure, T>
├── network/
│   ├── api_endpoints.dart
│   ├── dio_auth_interceptor.dart
│   ├── dio_error_handler.dart
│   ├── env_config.dart
│   ├── network_cubit.dart
│   └── safe_api_call.dart
├── services/                # WAJIB pola interface + implementasi (lihat Bagian 4.1)
│   ├── permission/
│   ├── location/
│   ├── image/
│   └── printer/
├── storage/                  # Static method, TIDAK wajib interface (lihat Bagian 4.2)
│   ├── secure_preference.dart
│   ├── app_preference.dart
│   └── database_helper.dart  # atau hive_storage.dart, sesuai kebutuhan — lihat Bagian 4.2
└── utils/                    # Hanya util generic, bukan domain-specific (lihat Bagian 5.6)
```

### 4.1 `services/` — Wajib Pola Interface + Implementasi

`services/` adalah pintu masuk ke kemampuan perangkat (hardware) atau sistem operasi yang dipakai lintas fitur: **permission** (izin akses), **location/GPS**, **kamera/image**, **printer Bluetooth**, dan sejenisnya.

Setiap service **wajib** punya 2 bagian:
1. **Interface** (`i_xxx_service.dart`) — kontrak abstrak, tidak peduli bagaimana cara kerjanya, hanya "apa yang bisa dilakukan".
2. **Implementasi** (`xxx_service_impl.dart`) — kode konkret yang benar-benar memanggil package/plugin.

**Alasan wajib interface di sini (beda dengan storage di 4.2):** service jenis ini lebih mungkin perlu di-*mock* (ditiru perilakunya secara palsu) saat unit testing — misal testing alur pembayaran tanpa harus benar-benar mengakses GPS asli HP. Tanpa interface, ini sulit dilakukan.

```dart
// lib/core/services/location/i_app_location_service.dart
abstract class IAppLocationService {
  Future<Either<Failure, Position>> getCurrentLocation();
}

// lib/core/services/location/app_location_service_impl.dart
class AppLocationServiceImpl implements IAppLocationService {
  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    // implementasi nyata pakai package geolocator
  }
}
```

### 4.2 `storage/` — Static Method, Tidak Wajib Interface

Berbeda dari `services/`, lapisan storage **tidak wajib** punya interface. Cukup expose sebagai static method langsung. Alasannya: storage biasanya tidak butuh ditukar/di-mock implementasinya seperti service eksternal — fokusnya pada kemudahan akses, bukan fleksibilitas swap.

**Kriteria pemilihan storage engine** — boleh dipakai berdampingan, sesuai kebutuhan data:

| Kebutuhan | Engine yang dipakai |
|---|---|
| Data sensitif (token, kredensial) | `flutter_secure_storage` |
| Preference ringan, non-sensitif (setting, flag) | `shared_preferences` |
| Data relasional / list besar yang butuh query (riwayat transaksi, cache panjang) | `sqflite` |
| Cache object sederhana, tanpa kebutuhan query kompleks | `Hive` |
| *(Opsional, dipertimbangkan ke depan — belum dipakai sekarang)* | `Isar` — boleh dievaluasi kalau kebutuhan performa/skema data ke depan membutuhkannya, bukan kewajiban saat ini. |

```dart
// lib/core/storage/secure_preference.dart
class SecurePreference {
  static Future<void> saveToken(String token) async { ... }
  static Future<String?> getToken() async { ... }
}
```

---

## 5. `features/` — Detail Isi & Pattern Clean Architecture

```
lib/features/<nama_fitur>/
├── data/
│   ├── datasources/
│   │   ├── i_xxx_remote_datasource.dart
│   │   └── xxx_remote_datasource_impl.dart
│   ├── models/
│   │   ├── xxx_dto.dart           # DTO (Data Transfer Object) — Freezed + JSON Serializable + Extension Mapper
│   │   └── xxx_dto.freezed.dart
│   └── repositories/
│       └── xxx_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── xxx_entity.dart        # Pure Dart Class + Equatable
│   ├── enums/                     # OPSIONAL — hanya jika fitur ini punya enum yang khusus untuk dirinya sendiri
│   ├── repositories/
│   │   └── i_xxx_repository.dart
│   ├── usecases/
│   │   └── xxx_usecase.dart
│   ├── utils/                     # OPSIONAL — hanya jika fitur ini punya helper khusus yang tidak relevan di fitur lain
│   └── value_objects/             # OPSIONAL — hanya jika fitur ini berurusan dengan input yang perlu divalidasi
│       └── xxx_amount.dart
└── presentation/
    ├── cubit/
    │   ├── xxx_cubit.dart
    │   ├── xxx_state.dart
    │   └── xxx_state.freezed.dart
    ├── screen/
    │   └── xxx_screen.dart
    └── widgets/
        └── xxx_widget.dart
```

> **Catatan penting soal folder opsional di `domain/`:** tidak semua fitur butuh `enums`, `utils`, atau `value_objects`. Sebagai contoh, fitur yang hanya menampilkan data (seperti dashboard statistik tanpa form input) biasanya tidak butuh `value_objects`, karena `value_objects` baru relevan kalau fitur tersebut menerima input dari pengguna yang harus divalidasi (contoh: nominal pembayaran). Buat folder ini **hanya kalau memang dibutuhkan**, jangan dibuat kosong sebagai formalitas.

### 5.1 Data Layer — DTO & Extension Mapper

DTO (*Data Transfer Object* — objek yang bentuknya mengikuti struktur respons API mentah, sebelum diubah jadi bentuk yang dipahami bisnis) wajib pakai `@freezed`. Transformasi dari DTO ke Entity diletakkan **di file yang sama** menggunakan Dart Extension, supaya tidak ada folder mapper terpisah yang mengotori struktur:

```dart
// lib/features/dashboard/data/models/tax_dto.dart
@freezed
class TaxDto with _$TaxDto {
  const factory TaxDto({
    @JsonKey(name: 'id_pajak') required String id,
    @JsonKey(name: 'nominal_bayar') required double total,
    @JsonKey(name: 'status_pembayaran') required int statusCode,
    @JsonKey(name: 'tanggal_jatuh_tempo') required String dueDateString,
  }) = _TaxDto;

  factory TaxDto.fromJson(Map<String, dynamic> json) => _$TaxDtoFromJson(json);
}

extension TaxDtoMapper on TaxDto {
  TaxEntity toEntity() {
    return TaxEntity(
      id: id,
      total: total,
      isPaid: statusCode == 1, // Pembersihan data kotor (sanitization) terjadi di sini
      dueDate: DateTime.parse(dueDateString),
    );
  }
}
```

### 5.2 Domain Layer — Entity (Pure Dart Class)

Entity wajib `Equatable` (package untuk membandingkan dua object berdasarkan isinya, bukan referensi memorinya) agar Cubit bisa mendeteksi perubahan data dengan benar.

> ⚠️ **Peringatan ("Missing Prop Trap"):** Daftar properti di `get props` harus identik dengan semua variabel di constructor. Kalau ada yang lupa didaftarkan, Cubit akan mengira data tidak berubah meski sebenarnya berubah — UI jadi tidak update tanpa error yang kelihatan.

```dart
class TaxEntity extends Equatable {
  final String id;
  final double total;
  final bool isPaid;
  final DateTime dueDate;

  const TaxEntity({required this.id, required this.total, required this.isPaid, required this.dueDate});

  bool get isOverdue => DateTime.now().isAfter(dueDate) && !isPaid;

  @override
  List<Object?> get props => [id, total, isPaid, dueDate]; // Wajib semua terdaftar!
}
```

### 5.3 Domain Layer — UseCase (Pola Facade)

**Facade UseCase** (1 kelas UseCase menangani beberapa fungsi bisnis yang berkaitan erat) dipakai untuk menghindari ledakan jumlah file kecil-kecil dalam 1 folder fitur.

- UseCase bertugas mengorkestrasi alur kerja: memanggil repository, memvalidasi Value Object, dan berkomunikasi dengan service eksternal (GPS, printer).
- **Batas wajar:** jika 1 file UseCase sudah melebihi 10 method atau 300 baris kode, **wajib** dipecah jadi kelas UseCase atomik terpisah.

### 5.4 Domain Layer — Value Object (Opsional, Sesuai Kebutuhan)

Value Object bertugas membersihkan dan memvalidasi data **sebelum** masuk ke UseCase — hanya dibuat kalau fitur tersebut memang menerima input yang perlu divalidasi.

- Validasi dijalankan di level **Presentation (Cubit)**. Kalau validasi gagal, Cubit langsung mengubah state jadi error tanpa perlu menjalankan UseCase.
- UseCase menerima data yang sudah pasti bersih, sehingga tidak perlu lagi mengecek format data mentah.

```dart
class TaxAmount {
  final double value;
  const TaxAmount._(this.value);

  static Either<Failure, TaxAmount> create(double input) {
    if (input <= 0) {
      return const Left(ServerFailure('Nominal pembayaran tidak boleh kurang dari atau sama dengan nol.'));
    }
    if (input > 500000000) {
      return const Left(ServerFailure('Nominal melebihi batas pembayaran maksimal transaksi digital harian.'));
    }
    return Right(TaxAmount._(input));
  }
}
```

### 5.5 Presentation Layer

**Cubit & State:**
- State wajib `sealed class` (Dart 3.x — class tertutup yang anggotanya sudah pasti dan lengkap diketahui compiler) agar pattern matching di widget bersifat *exhaustive* (compiler memaksa semua kemungkinan state ditangani, tidak ada yang terlewat).
- Khusus file `xxx_state.dart`, gunakan **Local Override** terhadap konfigurasi global `build.yaml` (lihat Bagian 7) agar tetap menghasilkan `copyWith` yang dibutuhkan untuk manipulasi state.

```dart
@Freezed(copyWith: true, equal: true)
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.success({required List<TaxEntity> taxes}) = _Success;
  const factory HomeState.failure({required String message}) = _Failure;
}
```

**Aturan Screen vs Widget:**
- **Screen** (*Smart Container*) — representasi 1 halaman penuh. Bertugas inisialisasi Cubit, mendengarkan state lewat `BlocListener`/`BlocBuilder`, menangani navigasi, menyusun layout utama.
- **Widget** (*Dumb Component*) — komponen visual kecil di folder `widgets/`. **Wajib Stateless**, tidak boleh akses Cubit/UseCase langsung. Data masuk lewat constructor, aksi keluar lewat callback.

### 5.6 Aturan "Shared Only If Shared" — Kapan Sesuatu Naik Level

Berlaku untuk **semua jenis artifact**: enum, util, value object, widget kecil.

> **Aturan:** Kalau sesuatu hanya dipakai oleh **1 fitur**, dia tinggal di dalam fitur itu sendiri (`domain/enums`, `domain/utils`, dst). Begitu dibutuhkan oleh **2 fitur atau lebih**, dia "naik kelas":
> - Kalau sifatnya murni teknis/generic (tidak tahu soal bisnis) → pindah ke `core`.
> - Kalau sifatnya composite/UI dan tetap dipakai bersama → pindah ke `shared`.

**Siapa yang memutuskan kenaikan level ini?** Untuk menjaga konsistensi dan menghindari pemindahan lokasi yang asal-asalan, **Team Lead (William)** adalah approval utama untuk setiap perpindahan dari `domain/` fitur menuju `core/` atau `shared/`. Developer boleh mengusulkan, tapi keputusan final tetap di Team Lead.

**Contoh penerapan:** util seperti `plate_parser.dart` (parsing plat nomor), `receipt_formatter.dart` (format struk), `ticket_crypto_utils.dart` (enkripsi tiket QR) — selama ini hanya dipakai 1 fitur, sebaiknya pindah dari `core/utils` ke `features/<fitur_terkait>/domain/utils/`. Begitu ada fitur lain yang juga butuh logika yang sama, baru diusulkan naik ke `core/utils`.

---

## 6. Penamaan Fitur Terkait (Pengganti `sub_features`)

Setelah didiskusikan, struktur `sub_features` (folder fitur bersarang di dalam fitur lain) **tidak dipakai**. Semua fitur — termasuk halaman detail yang secara navigasi "anak" dari fitur lain — tetap diletakkan **flat** (sejajar) di `lib/features/`, dengan **prefix nama fitur induk** di nama foldernya agar relasinya tetap jelas tanpa nesting fisik folder.

**Format:** `features/<nama_fitur_induk>_<nama_detail>`

**Contoh:**
```
lib/features/
├── dashboard_op/                          # Fitur induk
├── dashboard_op_detail_realisasi/          # "Anak" dari dashboard_op, tapi tetap flat
└── dashboard_op_detail_rekap_pembayaran/   # "Anak" lain dari dashboard_op
```

**Alasan:**
- Menghindari kedalaman folder (*nesting*) yang berpotensi membengkak tanpa batas jelas.
- Tetap predictable — semua fitur dicari di lokasi yang sama (`lib/features/`), tidak perlu menebak apakah sesuatu ada di induk atau di dalam sub-folder.
- Relasi "siapa anak siapa" tetap kelihatan lewat nama folder, dan secara teknis hubungan navigasinya hidup di `app_router.dart` lewat nested route.

**Soal routing (GoRouter):** Kalau halaman detail tersebut murni 1 screen tanpa navigasi turunan lagi di dalamnya, cukup didaftarkan sebagai nested `GoRoute` biasa di bawah route induknya (`/dashboard-op/detail-realisasi`) — **tidak perlu `ShellRoute`**. `ShellRoute` (pola GoRouter untuk halaman yang berbagi UI tetap seperti bottom navigation bar) baru relevan dipertimbangkan nanti **kalau** desain produk membutuhkan ada elemen UI yang tetap tampil di sekitar/belakang halaman saat berpindah (misalnya bottom navigation yang tidak boleh hilang). Karena desain wireframe belum final, keputusan ini ditunda dan akan ditinjau ulang begitu desain produk sudah ada.

---

## 7. Global Configuration — `build.yaml`

Untuk mempercepat waktu kompilasi code generator dan menekan penggunaan RAM saat development, diterapkan konfigurasi restriktif secara global di `build.yaml` (root project, sejajar `pubspec.yaml`). Konfigurasi ini menonaktifkan method yang tidak dibutuhkan (`copyWith`, `equal`, `toString`) untuk semua model DTO secara otomatis.

```yaml
# build.yaml
targets:
  $default:
    builders:
      freezed:
        options:
          copy_with: false
          equal: false
          to_string: false
```

> Ingat: file state Cubit (`xxx_state.dart`) melakukan **Local Override** terhadap konfigurasi ini (lihat Bagian 5.5), karena state tetap butuh `copyWith` untuk manipulasi data di UI.

---

## 8. Dependency Injection & Networking

### 8.1 `injection.dart` (Orchestrator)

```dart
final GetIt locator = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: true, asExtension: false)
void configureDependencies() => init(locator);
```

### 8.2 `register_module.dart` — Konfigurasi Dio Production-Grade

```dart
@module
abstract class RegisterModule {
  @lazySingleton
  Dio provideDio(DioAuthInterceptor authInterceptor) {
    final dio = Dio(BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 45),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    ));

    // Proteksi SSL & whitelist host pemerintah
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => EnvConfig.baseUrl.contains(host);
        return client;
      },
    );

    // Retry otomatis untuk sinyal tidak stabil di lapangan
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 3,
      retryDelays: const [Duration(seconds: 2), Duration(seconds: 5), Duration(seconds: 10)],
      retryableExtraStatuses: {status408RequestTimeout},
    ));

    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(LogInterceptor(requestHeader: true, requestBody: true, responseBody: true, error: true));

    if (kDebugMode) dio.interceptors.add(ChuckerDioInterceptor());

    return dio;
  }
}
```

**Urutan interceptor di atas penting dan harus tetap konsisten:** Retry → Auth → Logging → Chucker (khusus debug). Mengubah urutan ini bisa menyebabkan bug yang sulit dilacak (misalnya token auth yang belum sempat ditempel saat retry jalan duluan).

---

## 9. Testing

Saat ini belum ada automated testing di codebase, sehingga ditetapkan sebagai **baseline standar minimum** untuk memulai, bukan target besar yang langsung dipatok tinggi:

**Lokasi:** `root/test/`, strukturnya mencerminkan (*mirroring*) struktur `lib/`:
```
test/
└── features/
    └── dashboard_op/
        ├── domain/
        │   └── usecases/
        │       └── dashboard_op_usecase_test.dart
        └── presentation/
            └── cubit/
                └── dashboard_op_cubit_test.dart
```

**Package yang umum dipakai tim Flutter berbasis BLoC/Cubit:**
- [`bloc_test`](https://pub.dev/packages/bloc_test) — khusus untuk testing Cubit/Bloc, memudahkan assert urutan state yang di-emit.
- [`mocktail`](https://pub.dev/packages/mocktail) — untuk membuat objek tiruan (*mock*) dari repository/service tanpa perlu kode generator (lebih ringan dibanding `mockito`).

**Prioritas yang ditest lebih dulu (baseline, bukan keseluruhan):**
1. **UseCase** — terutama alur kritis: pembayaran, QRIS, transaksi.
2. **Cubit** — memastikan urutan state (`loading` → `success`/`failure`) sesuai harapan.
3. Widget test menyusul belakangan, tidak jadi prioritas awal.

Target coverage akan ditentukan setelah baseline pertama berjalan, bukan dipatok di awal.

---

## 10. README per Fitur (Living Documentation)

Setiap fitur di `lib/features/<nama_fitur>/` wajib punya **1 file `readme.md`** di root folder fitur tersebut (bukan per-layer) — cukup 1 untuk seluruh fitur, mencakup `data`, `domain`, dan `presentation` sekaligus secara umum.

### Template `readme.md`

```markdown
# Fitur: <Nama Fitur>

## Ringkasan
Jelaskan secara singkat fitur ini untuk apa dan proses bisnis apa yang dicakup.

## Hal yang Perlu Diperhatikan
- Catatan khusus, keputusan desain, atau batasan teknis yang tidak terlihat jelas dari kode.
- Dependency atau service eksternal yang dipakai (misal: printer Bluetooth, GPS).

## Struktur Folder Opsional yang Dipakai
- [ ] domain/enums — (isi alasan kalau dipakai, atau hapus baris ini kalau tidak dipakai)
- [ ] domain/value_objects — (isi alasan kalau dipakai, atau hapus baris ini kalau tidak dipakai)
- [ ] domain/utils — (isi alasan kalau dipakai, atau hapus baris ini kalau tidak dipakai)

## Checklist Sebelum PR / Commit
- [ ] `flutter analyze` — 0 error, 0 warning.
- [ ] Tidak ada business logic di widget/screen.
- [ ] Cubit tidak akses repository langsung (wajib lewat usecase).
- [ ] Entity sudah extends Equatable dan `props` lengkap (lihat Missing Prop Trap, Bagian 5.2).
- [ ] Tidak ada `print()`/`debugPrint()` tertinggal.
- [ ] Tidak ada kode mati tanpa keterangan.
- [ ] Unit test untuk usecase kritis sudah ditambahkan (kalau relevan).
```

README ini berfungsi sebagai *living documentation* — pengetahuan yang langsung ada di tempatnya, bukan dokumen terpisah yang gampang basi dan terlupakan.

---

## 11. Aturan Wajib (DO's) & Larangan Keras (DON'Ts)

### DO's

- **✅ DO:** Menulis unit test minimal untuk usecase kritis (payment, QRIS, transaksi) — lihat Bagian 9.
- **✅ DO:** Membungkus parameter UseCase dalam class `Params` jika input lebih dari 2 parameter.
- **✅ DO:** Memanfaatkan `const` constructor untuk optimasi rendering.
- **✅ DO:** Dispose controller/stream/timer/cubit secara eksplisit.
- **✅ DO:** Selalu memeriksa `isClosed` pada Cubit sebelum `emit` di proses async.
- **✅ DO:** Memindahkan comment penjelasan panjang ke `readme.md` fitur (Bagian 10), bukan menumpuk di kode.
- **✅ DO:** Membersihkan dependency yang sudah tidak terpakai dari `pubspec.yaml` (bukan dibiarkan ter-*comment* sebagai "legacy/unused" — itu membingungkan kontributor baru soal status sebenarnya).
- **✅ DO:** Memperbaiki penamaan file yang ambigu/typo sebelum dijadikan rujukan tim baru (contoh: nama file dengan angka urutan seperti `_2` tanpa keterangan jelas, atau salah eja).

### DON'Ts

- **❌ DON'T:** Menulis business logic atau validasi input mentah di dalam widget/screen.
- **❌ DON'T:** Melakukan `setState` langsung pada halaman yang sudah punya Cubit.
- **❌ DON'T:** Cubit mengakses repository langsung — wajib lewat usecase.
- **❌ DON'T:** Hardcode warna/ukuran/string — wajib lewat `core/design_system/tokens` & `core/constants`.
- **❌ DON'T:** Hardcode URL endpoint — wajib lewat `api_endpoints.dart`.
- **❌ DON'T:** Memasang base64 gambar langsung di kode — simpan sebagai file asset.
- **❌ DON'T:** Menggunakan tipe `dynamic` tanpa alasan teknis yang disetujui Team Lead.
- **❌ DON'T:** Menggunakan `shared_preferences` untuk data sensitif (token) — wajib `secure_storage`.
- **❌ DON'T:** Membuat instance `Dio` baru di luar `core/network` / `register_module.dart`.
- **❌ DON'T:** Membuat class `Failure` baru tanpa benar-benar berbeda dari yang sudah ada di `core/errors/failure.dart`.
- **❌ DON'T:** Menaikkan enum/util/value object dari `domain/` fitur ke `core`/`shared` tanpa approval Team Lead (lihat Bagian 5.6).

---

*Dokumen ini hidup — wajib direvisi setiap ada keputusan arsitektur baru yang disepakati Team Lead & tim. Disusun dari kolaborasi pattern existing Bapenda Mobile Project.
