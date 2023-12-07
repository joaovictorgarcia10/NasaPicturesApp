import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/infrastructure/network_connection/adapter/connectivity_plus_adapter.dart';
import 'package:nasa_pictures_app/core/infrastructure/network_connection/network_connection_client.dart';

class ConnectivityMock extends Mock implements Connectivity {}

void main() {
  late NetworkConnectionClient sut;
  late Connectivity connectivity;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    connectivity = ConnectivityMock();
    sut = ConnectivityPlusAdapter(connectivity: connectivity);
  });

  group("ConnectivityPlusAdapter Tests", () {
    test("Should return true when the network connection is available",
        () async {
      when(() => connectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);

      final result = await sut.hasConnection();
      
      expect(result, true);
    });

    test("Should return false when the network connection is not available",
        () async {
      when(() => connectivity.checkConnectivity())

          .thenAnswer((_) async => ConnectivityResult.none);
      final result = await sut.hasConnection();
     
      expect(result, false);
    });
  });
}
