import 'package:equatable/equatable.dart';

class UpdateEntity extends Equatable {
  final String versionName;
  final int buildNumber;
  final String changelog;
  final String downloadUrl;
  final bool isForceUpdate;

  const UpdateEntity({
    required this.versionName,
    required this.buildNumber,
    required this.changelog,
    required this.downloadUrl,
    required this.isForceUpdate,
  });

  @override
  List<Object?> get props => [
    versionName,
    buildNumber,
    changelog,
    downloadUrl,
    isForceUpdate,
  ];
}
