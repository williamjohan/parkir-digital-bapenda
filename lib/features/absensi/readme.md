# Fitur Absensi

Deskripsi singkat mengenai fitur Absensi

---

##  Info

- main_absensi isinya hanya widgets yang dipakai nanti di dashboard (tidak ada screen)
- check_list absensi nanti baru ada screen atau pages.
- Pastikan di UI hanya pakai usecase yang sudah disediakan. ( layer domain )
- Usahakan Logic pengambilan data harus di repository.
- Data Dummy kalau bisa dibuat di level datasource dengan nama : /absensi_dummy_datasource.dart

---

## ✅ Todo List

### Data Layer
- Datasources : /absensi_remote_datasource.dart
- Repositories : /absensi_repository_impl.dart
- Models : /absensi_model.dart

### Domain Layer

- Entities : /absensi_entity.dart
- Repositories : /absensi_repository.dart ( abstract )
- Usecase : /absensi_usecase.dart 

### Presentation Layer
- Cubit : /absensi_cubit.dart & /absensi_state.dart
- Widget : /card_......_absensi.dart
- Screen : /absensi_checklist_screen.dart
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