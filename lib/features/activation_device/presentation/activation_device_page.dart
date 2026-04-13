import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_text_field.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import 'package:parkir_digital_bapenda/features/activation_device/presentation/widgets/header_widget.dart';
import 'package:parkir_digital_bapenda/features/activation_device/presentation/widgets/ket_activasi_widget.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/formatters.dart';
import 'cubit/activate_device_cubit.dart';

class ActivationDevicePage extends StatefulWidget {
  const ActivationDevicePage({super.key});

  @override
  State<ActivationDevicePage> createState() => _ActivationDevicePageState();
}

class _ActivationDevicePageState extends State<ActivationDevicePage> {
  final TextEditingController nopController = TextEditingController();
  bool showErrorText = false;
  String errorText = '';

  @override
  void dispose() {
    nopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => locator<ActivationDeviceCubit>(),
        child: BlocConsumer<ActivationDeviceCubit, ActivationDeviceState>(
          listener: (context, state) {
            /// ✅ SUCCESS → ke halaman login
            if (state is ActivationDeviceSuccess) {
              /// kasih delay biar snackbar kelihatan
              Future.delayed(const Duration(seconds: 1), () {
                context.go('/login'); // pastikan route ini ada
              });
            }

            /// ❌ ERROR
            if (state is ActivationDeviceError) {
              setState(() {
                showErrorText = true;
                errorText = state.message;
              });
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is ActivationDeviceLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeaderWidget(),
                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Nomor Operator Parkir (NOP)",
                                style: AppTypography.bodySemiBold,
                              ),
                              const SizedBox(height: 8),

                              PbTextField(
                                inputType: TextInputType.number,
                                controller: nopController,
                                hintText: "Contoh: 35.xx.xxxx.xxx.xxx.xxxxx",
                                inputFormatters: [NopInputFormatter()],
                              ),

                              const SizedBox(height: 8),
                              if (showErrorText)
                                Text(
                                  errorText,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),

                              const SizedBox(height: 16),

                              /// 🔥 BUTTON AKTIVASI
                              PbPrimaryButton(
                                text: isLoading
                                    ? "Loading..."
                                    : "Aktivasi Device",
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        final nop = nopController.text.trim();

                                        /// validasi sederhana
                                        if (nop.isEmpty) {
                                          setState(() {
                                            errorText =
                                                "NOP tidak boleh kosong";
                                            showErrorText = true;
                                          });
                                          return;
                                        }

                                        // dismiss keyboard
                                        FocusScope.of(context).unfocus();

                                        context
                                            .read<ActivationDeviceCubit>()
                                            .activate(nop: nop);
                                      },
                              ),

                              const SizedBox(height: 48),
                              KetAktivasiWidget(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
