// lib/features/update/domain/entities/update_entity.dart
class UpdateEntity {
  final String versionName;
  final int buildNumber;
  final String changelog;
  final String downloadUrl;
  final bool isForceUpdate;

  UpdateEntity({
    required this.versionName,
    required this.buildNumber,
    required this.changelog,
    required this.downloadUrl,
    required this.isForceUpdate,
  });
}
