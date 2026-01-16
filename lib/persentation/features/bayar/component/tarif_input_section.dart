// lib/presentation/features/bayar/component/tarif_input_section.dart
import 'package:flutter/material.dart';

class TarifInputSection extends StatelessWidget {
  final TextEditingController controller;

  const TarifInputSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Input Tarif",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            // LOGIC FOCUS MATI SAAT ENTER/CLICK OUTSIDE
            onSubmitted: (_) =>
                FocusScope.of(context).requestFocus(FocusNode()),
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: "Rp. 0",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
