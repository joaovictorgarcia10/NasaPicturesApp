import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/adapter/shared_preferences_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../mock/picture_list_mock.dart';

void main() {
  late LocalStorageClient sut;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({
      "ALL_PICTURES": jsonEncode(pictureLisMock),
    });

    sut = SharedPreferencesAdapter(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  });

  group("SharedPreferencesAdapter Tests", () {
    test("Should set a list of pictures on Local Storage", () async {
      final response = await sut.save("ALL_PICTURES", pictureLisMock);
      expect(response, true);
    });

    test("Should get a list of pictures from Local Storage", () {
      final get = sut.get("ALL_PICTURES");
      expect(get, isA<List>());
      expect(get.length, 2);
      expect(get[0]["date"], "2007-05-18");
      expect(get[1]["date"], "2018-02-05");
    });

    test("Should get an empty list when call a unregistered key", () {
      final get = sut.get("ALL_MOVIES");
      expect(get.length, 0);
    });

    test("Should clear the local storage cache", () async {
      final firstGet = sut.get("ALL_PICTURES");
      expect(firstGet.length, 2);

      final clear = await sut.clear("ALL_PICTURES");
      expect(clear, true);

      final secondGet = sut.get("ALL_PICTURES");
      expect(secondGet.length, 0);
    });
  });
}
