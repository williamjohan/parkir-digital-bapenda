import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';

import '../entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';

const dummyJenisPelanggaran = [
  JenisPelanggaranEntity(
    id: 1,
    namaPelanggaran: 'Tidak Menggunakan QRIS Rompi',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 2,
    namaPelanggaran: 'Tidak Memiliki EDC Resmi Bapenda',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 3,
    namaPelanggaran: 'Identitas Petugas Tidak Sesuai',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 4,
    namaPelanggaran: 'QRIS Bukan QRIS Rompi',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 5,
    namaPelanggaran: 'EDC Tidak Aktif',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 6,
    namaPelanggaran: 'QRIS Tidak Dapat Digunakan',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 7,
    namaPelanggaran: 'Menolak Transaksi Non Tunai',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 9,
    namaPelanggaran: 'Tidak Bertugas di Lokasi yang Ditentukan',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 10,
    namaPelanggaran: 'Memungut Tarif Tidak Sesuai',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
  JenisPelanggaranEntity(
    id: 999,
    namaPelanggaran: 'Lainnya',
    jenisPelanggaran: JenisPengawasan.bapenda,
  ),
];
