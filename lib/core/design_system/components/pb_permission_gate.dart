import 'package:flutter/material.dart';
import '../../enums/app_enums.dart';

class PbPermissionGate extends StatelessWidget {
  /// Daftar role yang diizinkan melihat widget ini
  final List<RoleLoginDigitalParkir> allowedRoles;

  /// Role user saat ini (didapat dari state Cubit)
  final RoleLoginDigitalParkir currentRole;

  /// Widget yang akan dirender jika role diizinkan
  final Widget child;

  /// (Opsional) Widget yang dirender jika ditolak. Default: Hilang tanpa jejak.
  final Widget replacement;

  const PbPermissionGate({
    super.key,
    required this.allowedRoles,
    required this.currentRole,
    required this.child,
    this.replacement = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    // Jika role saat ini ada di dalam daftar yang diizinkan, tampilkan!
    if (allowedRoles.contains(currentRole)) {
      return child;
    }

    // Jika tidak diizinkan, render widget pengganti (default-nya hilang/SizedBox.shrink)
    return replacement;
  }
}
