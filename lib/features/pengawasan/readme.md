# Fitur Pengawasan

Deskripsi singkat mengenai fitur Pengawasan

---

##  Info

- Main_Pengawasan isinya hanya widgets yang dipakai nanti di dashboard (tidak ada screen) hanya widget
- History pengawasan nanti ada di main pengawasan
- Pastikan di UI hanya pakai usecase yang sudah disediakan. ( layer domain )
- Usahakan Logic pengambilan data harus di repository.
- Data Dummy kalau bisa dibuat di level datasource dengan nama : /pengawasan_dummy_datasource.dart

---

## ✅ Todo List

### Data Layer
- Datasources : /pengawasan_remote_datasource.dart
- Repositories : /pengawasan_repository_impl.dart
- Models : /pengawasan_model.dart

### Domain Layer

- Entities : /pengawasan_entity.dart
- Repositories : /pengawasan_repository.dart ( abstract )
- Usecase : /pengawasan_usecase.dart 

### Presentation Layer
- Cubit : /pengawasan_cubit.dart & /pengawasan_state.dart
- Widget : /card_......_pengawasan.dart
- Screen : /pengawasan_checklist_screen.dart
---

### 1. 🗄️ REPOSITORY (Tukang Ambil Data)
**Tugas:** Mencarikan data dan merapikannya.
- ✅ **BOLEH:** Akses API (Internet), baca/tulis database (SQLite/SecureStorage), tangkap error server, dan ubah JSON ke Model/Entity.
- ❌ **TIDAK BOLEH:** Menyimpan rumus aturan bisnis atau mengatur format tampilan untuk UI.

---

### 2. 🧠 USECASE (Otak Aturan Bisnis)
**Tugas:** Menjalankan syarat dan ketentuan (aturan) aplikasi.
- ✅ **BOLEH:** Cek validasi bisnis (misal: "Jarak absen tidak boleh > 50 meter"), hitung rumus wajib (misal: potongan pajak), dan gabungkan beberapa Repository.
- ❌ **TIDAK BOLEH:** Menyentuh API/Database secara langsung (wajib lewat Repository) atau mengurus status *loading* layar.

---

### 3. 📱 CUBIT / BLOC (Pelayan Layar UI)
**Tugas:** Mengatur interaksi layar dan memoles data agar cantik dilihat user.
- ✅ **BOLEH:** Mengatur status UI (*Loading, Success, Error*), format data untuk tampilan (misal: potong nama, ubah angka jadi Rupiah), dan cek kolom kosong (*form validation*).
- ❌ **TIDAK BOLEH:** Nembak API/SecureStorage langsung atau menghitung logika bisnis inti.

## 👥 Maintainer

- William J. Pakpahan