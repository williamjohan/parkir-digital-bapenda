import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_form_section_card.dart';
import '../../../../core/design_system/components/pb_safe_file_image.dart';
import '../../../../core/utils/watermark_utils.dart';

class PhotoSectionCard extends StatelessWidget {
  final GlobalKey photoKey;
  final File? photo;
  final DateTime? photoTakenAt;
  final bool isFetchingLocation;
  final String? locationError;
  final String? placeName;
  final double? latitude;
  final double? longitude;
  final VoidCallback onPickPhoto;
  final VoidCallback onRemovePhoto;

  const PhotoSectionCard({
    super.key,
    required this.photoKey,
    required this.photo,
    required this.photoTakenAt,
    required this.isFetchingLocation,
    this.locationError,
    this.placeName,
    this.latitude,
    this.longitude,
    required this.onPickPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: "Foto Bukti Pelanggaran",
      icon: Icons.camera_alt_rounded,
      child: GestureDetector(
        onTap: onPickPhoto,
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
                  if (photo != null)
                    PbSafeFileImage(file: photo!, fit: BoxFit.cover)
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Ketuk untuk ambil foto bukti",
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                  // watermark info lokasi & waktu
                  if (photo != null)
                    Positioned(
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
                            if (isFetchingLocation)
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
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            else if (locationError != null)
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
                                      locationError!,
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
                              if (placeName != null)
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
                                        placeName!,
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
                              if (latitude != null && longitude != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    "${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}",
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              if (photoTakenAt != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    PhotoUtils.formatStampTime(photoTakenAt!),
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
                    ),

                  // tombol retake / hapus, pojok kanan atas
                  if (photo != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: onPickPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.refresh_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: onRemovePhoto,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
