import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/history_item_model.dart';

extension HistoryItemUiX on HistoryItemModel {
  // 1. Pembersih Nama Petugas dari anomali Bapenda
  String get namaPetugasBersih {
    if (namaPetugas.contains(';')) {
      return namaPetugas.split(';').last.trim();
    }
    return namaPetugas;
  }

  // 2. Format Tanggal
  String get formattedDate {
    try {
      final DateTime date = DateTime.parse(tglTrx);
      return DateFormat('dd MMM yyyy • HH:mm').format(date);
    } catch (_) {
      return tglTrx;
    }
  }

  // 3. Logika Uang
  String get formattedNominal {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return isFreeTransaction ? 'Rp 0' : formatCurrency.format(kredit);
  }

  // 4. Logika Status (Gratis / Bayar)
  bool get isFreeTransaction =>
      jenisTarif.toUpperCase() == 'FREE' || sof.toUpperCase() == 'FREE';

  Color get badgeColor => isFreeTransaction ? Colors.green : Colors.blue;
  String get badgeText => isFreeTransaction ? 'GRATIS' : 'LUNAS';

  // 5. Logika Kendaraan
  IconData get vehicleIcon {
    return jenisTarif.toUpperCase() == 'MOTOR'
        ? Icons.two_wheeler
        : Icons.directions_car;
  }

  String get jenisKendaraan {
    return jenisTarif.toUpperCase() == 'MOTOR' ? 'Motor' : 'Mobil';
  }

  // 6. Logika Plat Nomor (Title & Subtitle)
  bool get isNoPlate {
    // 🚀 FIX: Langsung trim() karena platNumber dijamin BUKAN null
    final cleanPlat = platNumber.trim().toLowerCase();

    return cleanPlat.isEmpty ||
        cleanPlat == '-' ||
        cleanPlat == 'null' ||
        cleanPlat == 'tanpa plat';
  }

  // 🚀 FIX: Buang tanda seru (!)
  String get subtitleText => isNoPlate ? '-' : platNumber.toUpperCase();

  String get titleText {
    // 🚀 FIX: Buang tanda seru (!)
    final String displayPlat = isNoPlate
        ? 'Tanpa Plat'
        : platNumber.toUpperCase();

    return isNoPlate ? jenisKendaraan : '$jenisKendaraan ( $displayPlat )';
  }
}
