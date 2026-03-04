import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/adapter/shared_preferences_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/local_storage_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../../modules/pictures/mock/picture_list_mock.dart';

void main() {
  late LocalStorageClient sut;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // SharedPreferencesWithCache uses the async platform (no 'flutter.' prefix).
    SharedPreferencesAsyncPlatform
        .instance = InMemorySharedPreferencesAsync.withData({
      'ALL_PICTURES': jsonEncode(pictureLisMock),
    });

    sut = SharedPreferencesAdapter(
      sharedPreferences: await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      ),
    );
  });

  group("SharedPreferencesAdapter Tests", () {
    test("Should set a list of pictures on Local Storage", () async {
      await expectLater(
        sut.saveList("ALL_PICTURES", pictureLisMock),
        completes,
      );
    });

    test("Should get a list of pictures from Local Storage", () {
      final get = sut.getList("ALL_PICTURES");
      expect(get, isA<List>());
      expect(get.length, 2);
      expect(get[0]["date"], "2007-05-18");
      expect(get[1]["date"], "2018-02-05");
    });

    test("Should get an empty list when call a unregistered key", () {
      final get = sut.getList("ALL_MOVIES");
      expect(get.length, 0);
    });

    test("Should clear the local storage cache", () async {
      final firstGet = sut.getList("ALL_PICTURES");
      expect(firstGet.length, 2);

      await sut.clear("ALL_PICTURES");

      final secondGet = sut.getList("ALL_PICTURES");
      expect(secondGet.length, 0);
    });
  });
}
