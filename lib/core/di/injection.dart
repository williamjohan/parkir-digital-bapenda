// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart'; // Baris ini akan error (merah) sebelum build_runner dijalankan. Biarkan saja.

final GetIt locator = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // nama fungsi generate default
  preferRelativeImports:
      true, // agar hasil generate menggunakan relative path, lebih rapi
  asExtension: false,
)
void configureDependencies() => init(locator);
