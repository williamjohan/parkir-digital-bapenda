import 'package:parkir_digital_bapenda/core/services/location/app_location_data.dart';

abstract class IAppLocationService {
  Future<AppLocationData> getCurrentLocation();

  Future<bool> isLocationServiceEnabled();
}
