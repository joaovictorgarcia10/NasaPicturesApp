import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nasa_pictures_app/core/infrastructure/network_connection/network_connection_client.dart';

class ConnectivityPlusAdapter implements NetworkConnectionClient {
  final Connectivity connectivity;

  ConnectivityPlusAdapter({
    required this.connectivity,
  });

  @override
  Future<bool> hasConnection() async {
    final result = await connectivity.checkConnectivity();

    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return true;
      default:
        return false;
    }
  }
}
