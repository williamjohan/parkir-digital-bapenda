import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/history_item_model.dart';

extension HistoryItemUiX on HistoryItemModel {
  String get namaPetugasBersih {
    if (namaPetugas.contains(';')) {
      return namaPetugas.split(';').last.trim();
    }
    return namaPetugas;
  }

  String get formattedDate {
    try {
      final DateTime date = DateTime.parse(tglTrx);
      return DateFormat('dd MMM yyyy • HH:mm').format(date);
    } catch (_) {
      return tglTrx;
    }
  }

  String get formattedNominal {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return isFreeTransaction ? 'Rp 0' : formatCurrency.format(kredit);
  }

  bool get isFreeTransaction =>
      jenisTarif.toUpperCase() == 'FREE' || sof.toUpperCase() == 'FREE';

  Color get badgeColor => isFreeTransaction ? Colors.green : Colors.blue;
  String get badgeText => isFreeTransaction ? 'GRATIS' : 'LUNAS';
  IconData get vehicleIcon {
    return jenisTarif.toUpperCase() == 'MOTOR'
        ? Icons.two_wheeler
        : Icons.directions_car;
  }

  String get jenisKendaraan {
    return jenisTarif.toUpperCase() == 'MOTOR' ? 'Motor' : 'Mobil';
  }

  bool get isNoPlate {
    final cleanPlat = platNumber.trim().toLowerCase();

    return cleanPlat.isEmpty ||
        cleanPlat == '-' ||
        cleanPlat == 'null' ||
        cleanPlat == 'tanpa plat';
  }

  String get subtitleText => isNoPlate ? '-' : platNumber.toUpperCase();

  String get titleText {
    final String displayPlat = isNoPlate
        ? 'Tanpa Plat'
        : platNumber.toUpperCase();

    return isNoPlate ? jenisKendaraan : '$jenisKendaraan ( $displayPlat )';
  }
}
