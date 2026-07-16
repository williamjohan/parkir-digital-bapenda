import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/range_filter_widget.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../widgets/tax_surveillance_item_card.dart';

class DetailTaxSurveillanceScreen extends StatefulWidget {
  final String? nop;

  const DetailTaxSurveillanceScreen({super.key, this.nop});

  @override
  State<DetailTaxSurveillanceScreen> createState() =>
      _DetailTaxSurveillanceScreenState();
}

class _DetailTaxSurveillanceScreenState
    extends State<DetailTaxSurveillanceScreen> {
  late DateTime _startDate;
  late DateTime _endDate;

  // 🆕 filter kategori aktif: 'SEMUA' | 'MOBIL' | 'MOTOR'
  String _selectedKategori = 'SEMUA';

  // 🚧 DUMMY — nanti diganti fetch dari usecase asli
  final List<TaxSurveillanceItemData> _dummyItems = [
    TaxSurveillanceItemData(
      kategori: 'Motor',
      nominal: 10000,
      tanggal: DateTime(2026, 7, 14),
    ),
    TaxSurveillanceItemData(
      kategori: 'Mobil',
      nominal: 25000,
      tanggal: DateTime(2026, 7, 14),
    ),
    TaxSurveillanceItemData(
      kategori: 'Motor',
      nominal: 15000,
      tanggal: DateTime(2026, 7, 13),
    ),
    TaxSurveillanceItemData(
      kategori: 'Mobil',
      nominal: 30000,
      tanggal: DateTime(2026, 7, 12),
    ),
    TaxSurveillanceItemData(
      kategori: 'Motor',
      nominal: 12000,
      tanggal: DateTime(2026, 7, 10),
    ),
  ];

  // 🆕 hasil filter berdasarkan _selectedKategori
  List<TaxSurveillanceItemData> get _filteredItems {
    if (_selectedKategori == 'SEMUA') return _dummyItems;
    final target = _selectedKategori == 'MOBIL' ? 'mobil' : 'motor';
    return _dummyItems
        .where((item) => item.kategori.toLowerCase() == target)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Detail Tax Surveillance',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Column(
        children: [
          RangeFilterWidget(
            onApply:
                ({
                  required String startDate,
                  required String endDate,
                  required String startTime,
                  required String endTime,
                }) {
                  setState(() {
                    _startDate = DateTime.parse("$startDate $startTime");
                    _endDate = DateTime.parse("$endDate $endTime");
                  });
                  // TODO: panggil fetch data asli pakai _startDate & _endDate
                },
          ),
          _buildFilterSection(), // 🆕
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_filteredItems.isEmpty)
                  _buildEmptyState() // 🆕
                else
                  ..._filteredItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TaxSurveillanceItemCard(item: item),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🆕 filter chip SEMUA/MOBIL/MOTOR
  Widget _buildFilterSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('SEMUA', 'Semua'),
                const SizedBox(width: 8),
                _buildFilterChip('MOBIL', 'Mobil'),
                const SizedBox(width: 8),
                _buildFilterChip('MOTOR', 'Motor'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final bool isSelected = value == _selectedKategori;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.blue.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue.shade800 : Colors.black54,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300),
      onSelected: (bool selected) {
        if (selected) {
          setState(() => _selectedKategori = value);
          // TODO: kalau udah backend asli, panggil fetch/filter remote di sini
          // pakai jenisKendaraan sesuai value (SEMUA=0, MOBIL=1, MOTOR=2)
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: AppColors.textHint),
            SizedBox(height: 16),
            Text(
              'Tidak ada data untuk filter ini.',
              style: TextStyle(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
