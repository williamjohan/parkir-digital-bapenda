import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';

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
  // STATE BARU: Untuk mengatur visibility password
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 1. Logic Tap Background -> Tutup Keyboard
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },

      // 2. Logic Swipe Down
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
              // HANDLE BAR
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

              // Header Text
              const Text(
                "Silakan Masuk",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 30),

              // INPUT NPWPD
              _buildTextField(
                controller: widget.usernameController,
                label: "Username",
                icon: Icons.person_outline,
                isPassword: false, // Bukan password
              ),
              const SizedBox(height: 20),

              // INPUT PASSWORD (Logic Toggle ada di dalam fungsi ini)
              _buildTextField(
                controller: widget.passwordController,
                label: "Kata Sandi",
                icon: Icons.lock_outline,
                isPassword: true, // Tandai ini password
              ),

              // LUPA PASSWORD
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
                    onPressed: () {},
                    child: const Text(
                      "Lupa Kata Sandi?",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // TOMBOL MASUK
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
        // LOGIC VISIBILITY:
        // Jika ini field password, cek state _isPasswordVisible.
        // Jika visible = true, maka obscureText = false (terbaca).
        // Jika visible = false, maka obscureText = true (bintang-bintang).
        obscureText: isPassword ? !_isPasswordVisible : false,

        textInputAction: isPassword
            ? TextInputAction.done
            : TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),

          // SUFFIX ICON (MATA)
          suffixIcon: isPassword
              ? IconButton(
                  // Ganti icon berdasarkan state
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons
                              .visibility // Mata Terbuka
                        : Icons.visibility_off, // Mata Dicoret
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Update State saat tombol mata diklik
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
