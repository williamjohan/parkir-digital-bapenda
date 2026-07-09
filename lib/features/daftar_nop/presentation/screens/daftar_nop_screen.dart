import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/daftar_nop_cubit.dart';
import '../cubit/daftar_nop_state.dart';
import '../widgets/daftar_nop_list.dart';
import '../widgets/progress_card.dart';

class DaftarNopScreen extends StatelessWidget {
  const DaftarNopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DaftarNopCubit, DaftarNopState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          PbStatusSnackbar.show(context, message: state.errorMessage);
        }

        if (state.isSuccess) {
          PbStatusSnackbar.show(context, message: 'Sinkronisasi berhasil');

          context.go(AppRoutes.home);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Daftar NOP")),
          body: Column(
            children: [
              ProgressCard(
                progress: state.progress,
                isSaving: state.isSaving,
                isSuccess: state.isSuccess,
              ),

              Expanded(
                child: DaftarNopList(
                  data: state.daftarNop,
                  isLoading: state.isLoading,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
