// lib/presentation/features/bayar/component/objek_pajak_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bayar_cubit.dart';
import '../data/objek_pajak_model.dart';

class ObjekPajakSection extends StatelessWidget {
  final ObjekPajakModel? selectedItem;
  final ValueChanged<ObjekPajakModel?> onChanged;

  const ObjekPajakSection({
    super.key,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pilih Nomor Object Pajak",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        BlocBuilder<BayarCubit, BayarState>(
          builder: (context, state) {
            // 1. Loading
            if (state is BayarLoading) {
              return _buildStatusBox("Sedang memuat data...", isLoading: true);
            }
            // 2. Error
            if (state is BayarError) {
              return GestureDetector(
                onTap: () => context.read<BayarCubit>().fetchObjekPajak(),
                child: _buildStatusBox(
                  "Gagal memuat. Ketuk ulangi.",
                  isError: true,
                ),
              );
            }
            // 3. Loaded / Payment Process
            if (state is BayarLoaded ||
                state is BayarPaymentLoading ||
                state is BayarPaymentSuccess) {
              List<ObjekPajakModel> items = [];
              if (state is BayarLoaded) items = state.listObjekPajak;

              if (items.isNotEmpty) {
                return _buildDropdown(items);
              } else if (selectedItem != null) {
                return _buildSelectedOnlyBox(selectedItem!);
              }
            }
            return const SizedBox(height: 50);
          },
        ),
      ],
    );
  }

  Widget _buildDropdown(List<ObjekPajakModel> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ObjekPajakModel>(
          value: selectedItem,
          hint: const Text("Pilih Objek Pajak"),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF5566FF),
            size: 26,
          ),
          borderRadius: BorderRadius.circular(16),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.formattedNop,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    item.nama,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStatusBox(
    String text, {
    bool isLoading = false,
    bool isError = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isError ? Colors.red[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isError ? Colors.red.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          if (isLoading) ...[
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
          ],
          if (isError) const Icon(Icons.error, color: Colors.red, size: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: isError ? Colors.red : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedOnlyBox(ObjekPajakModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        item.formattedNop,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
