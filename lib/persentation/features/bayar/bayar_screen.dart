import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simulasiparkirdigital/persentation/features/bayar/cubit/bayar_cubit.dart';
import 'package:simulasiparkirdigital/persentation/features/bayar/data/bayar_repository.dart';
import 'package:simulasiparkirdigital/persentation/features/bayar/data/objek_pajak_model.dart';

// Imports Komponen yang sudah dipecah
import 'component/bayar_header.dart';
import 'component/objek_pajak_section.dart';
import 'component/tarif_input_section.dart';
import 'component/pay_button.dart';
import 'component/payment_success_dialog.dart';
import 'component/vehicle_selector_widget.dart'; // Asumsi sudah ada
import 'component/payment_method_widget.dart'; // Asumsi sudah ada

class BayarScreen extends StatelessWidget {
  const BayarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BayarCubit(BayarRepository())..fetchObjekPajak(),
      child: const _BayarScreenContent(),
    );
  }
}

class _BayarScreenContent extends StatefulWidget {
  const _BayarScreenContent();

  @override
  State<_BayarScreenContent> createState() => _BayarScreenContentState();
}

class _BayarScreenContentState extends State<_BayarScreenContent> {
  // State Halaman
  ObjekPajakModel? selectedObjekPajak;
  String selectedVehicle = 'Car';
  String selectedPayment = 'QRIS';
  final TextEditingController tarifController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      // HEADER (AppBar)
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(child: BayarHeader()),
      ),

      body: BlocListener<BayarCubit, BayarState>(
        listener: (context, state) {
          if (state is BayarPaymentSuccess) {
            PaymentSuccessDialog.show(context, state, () {
              tarifController.clear();
              context.read<BayarCubit>().resetToLoaded();
            });
          } else if (state is BayarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.black87, thickness: 1),
                  const SizedBox(height: 20),

                  // 1. Pilih Objek Pajak
                  ObjekPajakSection(
                    selectedItem: selectedObjekPajak,
                    onChanged: (val) =>
                        setState(() => selectedObjekPajak = val),
                  ),
                  const SizedBox(height: 20),

                  // 2. Pilih Kendaraan
                  const Text(
                    "Select Vehicle Type",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  VehicleSelectorWidget(
                    selectedType: selectedVehicle,
                    onChanged: (val) => setState(() => selectedVehicle = val),
                  ),
                  const SizedBox(height: 20),

                  // 3. Input Tarif
                  TarifInputSection(controller: tarifController),
                  const SizedBox(height: 20),

                  // 4. Pilih Pembayaran
                  const Text(
                    "Payment Methods",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  PaymentMethodWidget(
                    selectedPayment: selectedPayment,
                    onChanged: (val) => setState(() => selectedPayment = val),
                  ),
                  const SizedBox(height: 30),

                  // 5. Tombol Bayar
                  PayButton(onPressed: _handlePayNow),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePayNow() {
    FocusScope.of(context).unfocus(); // Tutup keyboard

    if (selectedObjekPajak == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih Objek Pajak dulu!")));
      return;
    }
    if (tarifController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Isi tarif dulu!")));
      return;
    }

    String cleanTarif = tarifController.text.replaceAll(RegExp(r'[^0-9]'), '');
    int amount = int.tryParse(cleanTarif) ?? 0;

    context.read<BayarCubit>().payNow(
      nop: selectedObjekPajak!.nop,
      vehicleType: selectedVehicle,
      paymentMethod: selectedPayment,
      amount: amount,
    );
  }
}
