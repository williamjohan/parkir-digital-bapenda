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

## 👥 Maintainer

- William J. Pakpahan