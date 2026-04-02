// lib/features/auth/presentation/pages/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart'; // Navigasi akan diurus GoRouter listener nanti
import '../../../../core/di/injection.dart'; // Sesuaikan path getIt Anda
import '../../../../shared/loading/loading_overlay.dart';
import '../cubit/app_auth/app_auth_cubit.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';
import '../widgets/login_background_widget.dart';
import '../widgets/login_form_sheet_widget.dart';

// 1. WRAPPER UTAMA: Bertugas Inject LoginCubit (Lokal) ke dalam Widget Tree
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // [PERUBAHAN 1]: Kita hanya menyediakan LoginCubit (Sang Prajurit) di halaman ini
      create: (context) => locator<LoginCubit>(),
      child: const _LoginScreenContent(),
    );
  }
}

// 2. KONTEN UI: Logic Animasi & Form
class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  bool _isFormVisible = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _toggleForm(bool visible) {
    setState(() {
      _isFormVisible = visible;
      if (!visible) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double formHeight = screenHeight * 0.45;

    // [PERUBAHAN 2]: Listener sekarang mendengarkan LoginCubit
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // [THE HANDSHAKE - SANGAT PENTING]
          // Lapor ke Sang Jenderal (AppAuthCubit) bahwa proses di loket sudah selesai dan sukses!
          // AppAuthCubit akan mengecek brankas, lalu mengubah statusnya menjadi AppAuthenticated.
          // Nanti, GoRouter yang mendengar perubahan AppAuthCubit akan otomatis memindahkan halaman.
          context.read<AppAuthCubit>().checkStatus();
        } else if (state is LoginFailure) {
          // Tampilkan Error Snackbar dari backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade800,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },

      // [PERUBAHAN 3]: Builder hanya mendengarkan status Loading dari LoginCubit
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final bool isLoading = state is LoginLoading;

          return LoadingOverlay(
            isLoading: isLoading,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: Stack(
                children: [
                  LoginBackgroundWidget(
                    isHidden: _isFormVisible,
                    onLoginPressed: () => _toggleForm(true),
                    onRegisterPressed: () {},
                  ),

                  if (_isFormVisible)
                    GestureDetector(
                      onTap: () => _toggleForm(false),
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    bottom: _isFormVisible ? 0 : -formHeight,
                    left: 0,
                    right: 0,
                    height: formHeight,

                    child: LoginFormSheetWidget(
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                      onClose: () => _toggleForm(false),
                      onLogin: () {
                        // [PERUBAHAN 4]: Panggil fungsi loginSubmited milik LoginCubit
                        context.read<LoginCubit>().loginSubmited(
                          _usernameController.text,
                          _passwordController.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
