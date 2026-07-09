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

  Color get vehicleColor {
    return jenisTarif.toUpperCase() == 'MOTOR'
        ? const Color(0xFF10B981)
        : const Color(0xFF3B82F6);
  }

  IconData get sofIcon => SofUiHelper.resolve(sof).icon;
  Color get sofColor => SofUiHelper.resolve(sof).color;
  String get sofLabel => SofUiHelper.resolve(sof).label;
}

class SofUiHelper {
  SofUiHelper._();

  static const List<_SofRule> _rules = [
    _SofRule(
      keywords: ['QRIS'],
      icon: Icons.qr_code_2_rounded,
      color: Color(0xFF7C3AED),
    ),
    _SofRule(
      keywords: ['BRIZZI'],
      icon: Icons.credit_card_rounded,
      color: Color(0xFF0EA5E9),
    ),
    _SofRule(
      keywords: ['FLASH'],
      icon: Icons.credit_card_rounded,
      color: Color(0xFFF97316),
    ),
    _SofRule(
      keywords: ['TAPCASH'],
      icon: Icons.credit_card_rounded,
      color: Color(0xFF16A34A),
    ),
    _SofRule(
      keywords: ['E-MONEY', 'EMONEY'],
      icon: Icons.credit_card_rounded,
      color: Color(0xFF2563EB),
    ),
    _SofRule(
      keywords: ['TUNAI', 'CASH'],
      icon: Icons.payments_rounded,
      color: Color(0xFF15803D),
    ),
    _SofRule(
      keywords: ['FREE'],
      icon: Icons.card_giftcard_rounded,
      color: Color(0xFFF59E0B),
    ),
  ];

  // Palet cadangan buat metode pembayaran yang belum dikenal
  static const List<Color> _fallbackPalette = [
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFF8B5CF6),
    Color(0xFF3B82F6),
    Color(0xFFEF4444),
  ];

  static ({IconData icon, Color color, String label}) resolve(String raw) {
    final normalized = raw.toUpperCase();

    for (final rule in _rules) {
      if (rule.keywords.any((k) => normalized.contains(k))) {
        return (icon: rule.icon, color: rule.color, label: _titleCase(raw));
      }
    }

    final color =
        _fallbackPalette[raw.hashCode.abs() % _fallbackPalette.length];
    return (
      icon: Icons.account_balance_wallet_rounded,
      color: color,
      label: _titleCase(raw),
    );
  }

  static String _titleCase(String s) {
    if (s.trim().isEmpty) return '-';
    return s
        .split(' ')
        .map((w) {
          if (w.isEmpty) return w;
          return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}

class _SofRule {
  final List<String> keywords;
  final IconData icon;
  final Color color;

  const _SofRule({
    required this.keywords,
    required this.icon,
    required this.color,
  });
}
