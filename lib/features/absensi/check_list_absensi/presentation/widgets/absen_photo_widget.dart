import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_form_section_card.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/utils/watermark_utils.dart';
import '../cubit/absensi_state.dart';

class AbsenPhotoWidget extends StatelessWidget {
  final AbsensiState state;
  final GlobalKey photoKey;
  final VoidCallback onTap;

  const AbsenPhotoWidget({
    super.key,
    required this.state,
    required this.photoKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: "Foto & Lokasi",
      icon: Icons.camera_alt_rounded,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: RepaintBoundary(
            key: photoKey,
            child: Container(
              width: double.infinity,
              height: 240,
              color: Colors.grey.shade100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (state.rawPhoto != null)
                    Image.file(state.rawPhoto!, fit: BoxFit.cover)
                  else
                    _buildPlaceholder(),

                  if (state.rawPhoto != null) _buildWatermarkOverlay(),

                  if (state.rawPhoto != null) _buildRetakeButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_rounded, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          "Ketuk untuk ambil foto",
          style: AppTypography.bodySmall.copyWith(color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildWatermarkOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.75),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.isFetchingLocation)
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Mendeteksi lokasi...",
                    style: AppTypography.caption.copyWith(color: Colors.white),
                  ),
                ],
              )
            else if (state.locationError != null)
              Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 12,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      state.locationError!,
                      style: AppTypography.caption.copyWith(
                        color: Colors.orangeAccent,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else ...[
              if (state.placeName != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        state.placeName!,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              if (state.latitude != null && state.longitude != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "${state.latitude!.toStringAsFixed(5)}, "
                    "${state.longitude!.toStringAsFixed(5)}",
                    style: AppTypography.caption.copyWith(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              if (state.photoTakenAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    PhotoUtils.formatStampTime(state.photoTakenAt!),
                    style: AppTypography.caption.copyWith(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRetakeButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
      ),
    );
  }
}
