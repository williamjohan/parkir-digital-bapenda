import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/utils/debug_mock_scenario.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../shared/loading/loading_overlay.dart';
import '../cubit/app_auth/app_auth_cubit.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';
import '../widgets/login_background_widget.dart';
import '../widgets/login_form_sheet_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<LoginCubit>(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  bool _isFormVisible = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // 🚀 [ENHANCEMENT]: Tarik data saat layar dirender
  }

  Future<void> _loadInitialData() async {
    final storage = locator<ISecureStorageManager>();
    final logoutReason = await storage.getAndClearLogoutReason();
    if (logoutReason == 'DEVICE_MISMATCH') {
      _showInfoDialog(
        'Sesi Berakhir',
        'Akun Anda telah masuk di perangkat lain. Demi keamanan, Anda telah dikeluarkan dari perangkat ini.\n\nJika ini bukan Anda, segera hubungi admin.',
      );
    } else if (logoutReason == 'SESSION_EXPIRED') {
      _showInfoDialog(
        'Sesi Habis',
        'Sesi bulanan Anda telah berakhir demi menjaga keamanan. Silakan masuk kembali untuk mulai bekerja.',
      );
    }
    final creds = await storage.getCredentials();
    if (creds != null) {
      setState(() {
        _usernameController.text = creds['username'] ?? '';
        _passwordController.text = creds['password'] ?? '';
      });
    }
  }

  void _showInfoDialog(String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PbShowDialog.show(
        context,
        title: title,
        description: message,
        showBtnKeluar: false, // Hanya butuh satu tombol konfirmasi
        buttonText: 'MENGERTI',
        icon: Icons.security_rounded, // Icon yang pas untuk alert keamanan
        iconColor: Colors.red, // Warna merah agar Jukir waspada
      );
    });
  }

  void _toggleForm(bool visible) {
    setState(() {
      _isFormVisible = visible;
      if (!visible) FocusScope.of(context).unfocus();
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
    final double formHeight = screenHeight * 0.65;
    final isSmallDevice = screenHeight < 700;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.read<AppAuthCubit>().checkStatus();
        } else if (state is LoginFailure) {
          PbStatusSnackbar.show(context, message: state.message, isError: true);
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state is LoginLoading,
            child: SafeArea(
              bottom: true,
              top: false,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      transform: Matrix4.translationValues(
                        0,
                        (_isFormVisible && isSmallDevice)
                            ? -screenHeight * 0.09
                            : 0,
                        0,
                      ),
                      child: LoginBackgroundWidget(
                        isHidden: _isFormVisible,
                        onLoginPressed: () => _toggleForm(true),
                        onRegisterPressed: () {},
                      ),
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
                      child: LoginFormSheetWidget(
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        onClose: () => _toggleForm(false),
                        onLogin: (bool isRememberMe) {
                          context.read<LoginCubit>().loginSubmited(
                            _usernameController.text,
                            _passwordController.text,
                            isRememberMe,
                          );
                        },
                      ),
                    ),
                    // const Positioned(
                    //   bottom: 16,
                    //   right: 16,
                    //   child: MockScenarioFab(),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
