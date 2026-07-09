import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/features/webview/presentation/pages/lupa_password_webview.dart';

class LoginFormSheetWidget extends StatefulWidget {
  final VoidCallback onClose;
  final void Function(bool isRememberMe) onLogin;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginFormSheetWidget({
    super.key,
    required this.onClose,
    required this.onLogin,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  State<LoginFormSheetWidget> createState() => _LoginFormSheetWidgetState();
}

class _LoginFormSheetWidgetState extends State<LoginFormSheetWidget> {
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          widget.onClose();
        }
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Silakan Masuk",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: widget.usernameController,
                label: "Username",
                icon: Icons.person_outline,
                isPassword: false, // Bukan password
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: widget.passwordController,
                label: "Kata Sandi",
                icon: Icons.lock_outline,
                isPassword: true, // Tandai ini password
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Ingat Saya",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WebViewPage(
                            url:
                                'https://bapenda.surabaya.go.id:7077/Login/ForgotPassword',
                            title: 'Lupa Kata Sandi',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Lupa Kata Sandi?",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => widget.onLogin(_rememberMe),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "MASUK",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,

        textInputAction: isPassword
            ? TextInputAction.done
            : TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons
                              .visibility // Mata Terbuka
                        : Icons.visibility_off, // Mata Dicoret
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null, // Jika bukan password, tidak ada icon mata

          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
