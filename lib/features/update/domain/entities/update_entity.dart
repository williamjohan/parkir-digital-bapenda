class UpdateEntity {
  final String versionName;
  final int buildNumber;
  final String changelog;
  final String downloadUrl;

  UpdateEntity({
    required this.versionName,
    required this.buildNumber,
    required this.changelog,
    required this.downloadUrl,
  });
}
