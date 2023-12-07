import 'dart:io';
import 'package:nasa_pictures_app/core/constants/app_constants.dart';

class NetworkConnectionController {
  // Singleton
  NetworkConnectionController._internal();

  static final NetworkConnectionController _singleton =
      NetworkConnectionController._internal();

  factory NetworkConnectionController() => _singleton;

  Future<bool> hasConnection() async {
    try {
      final response = await InternetAddress.lookup(AppConstants.flutterUrl);

      if (response.isNotEmpty && response.first.rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
