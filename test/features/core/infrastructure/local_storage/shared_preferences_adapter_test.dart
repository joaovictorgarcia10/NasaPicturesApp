import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/adapter/shared_preferences_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalStorageClient sut;
  late List<Map<String, dynamic>> mock;

  setUp(() async {
    mock = [
      {
        "copyright": "Thomas V. Davis",
        "date": "2007-05-18",
        "explanation":
            "In 1714, Edmond Halley noted that M13 \"shows itself to the naked eye when the sky is serene and the Moon absent.\" Of course, M13 is now modestly recognized as the Great Globular Cluster in Hercules, one of the brightest globular star clusters in the northern sky. Telescopic views reveal the spectacular cluster's hundreds of thousands of stars. At a distance of 25,000 light-years, the cluster stars crowd into a region 150 light-years in diameter, but approaching the cluster core upwards of 100 stars could be contained in a cube just 3 light-years on a side. For comparison, the closest star to the Sun is over 4 light-years away. Along with the cluster's dense core, the outer reaches of M13 are highlighted in this deep color image. A distant background galaxy, NGC 6207 is also visible above and to the right of the Great Globular Cluster M13.",
        "hdurl": "https://apod.nasa.gov/apod/image/0705/m13_tvdavis.jpg",
        "media_type": "image",
        "service_version": "v1",
        "title": "M13: The Great Globular Cluster in Hercules",
        "url": "https://apod.nasa.gov/apod/image/0705/m13_tvdavis_c720.jpg"
      },
      {
        "date": "2018-02-05",
        "explanation":
            "It's the bubble versus the cloud. NGC 7635, the Bubble Nebula, is being pushed out by the stellar wind of massive star BD+602522, visible in blue toward the right, inside the nebula. Next door, though, lives a giant molecular cloud, visible to the far right in red. At this place in space, an irresistible force meets an immovable object in an interesting way. The cloud is able to contain the expansion of the bubble gas, but gets blasted by the hot radiation from the bubble's central star. The radiation heats up dense regions of the molecular cloud causing it to glow. The Bubble Nebula, pictured here is about 10 light-years across and part of a much larger complex of stars and shells. The Bubble Nebula can be seen with a small telescope towards the constellation of the Queen of Aethiopia (Cassiopeia).",
        "hdurl":
            "https://apod.nasa.gov/apod/image/1802/Bubble_LiverpoolNilsson_1679.jpg",
        "media_type": "image",
        "service_version": "v1",
        "title": "NGC 7635: The Bubble Nebula Expanding",
        "url":
            "https://apod.nasa.gov/apod/image/1802/Bubble_LiverpoolNilsson_960.jpg"
      },
    ];

    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({"ALL_PICTURES": jsonEncode(mock)});

    sut = SharedPreferencesAdapter(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  });

  group("SharedPreferencesAdapter Tests", () {
    test("Should set a list of pictures on Local Storage", () async {
      final response = await sut.setPictures("ALL_PICTURES", mock);
      expect(response, true);
    });

    test("Should get a list of pictures from Local Storage", () {
      final get = sut.getPictures("ALL_PICTURES");
      expect(get, isA<List>());
      expect(get.length, 2);
      expect(get[0]["date"], "2007-05-18");
      expect(get[1]["date"], "2018-02-05");
    });

    test("Should get an empty list when call a unregistered key", () {
      final get = sut.getPictures("ALL_MOVIES");
      expect(get.length, 0);
    });

    test("Should clear the local storage cache", () async {
      final firstGet = sut.getPictures("ALL_PICTURES");
      expect(firstGet.length, 2);

      final clear = await sut.clear("ALL_PICTURES");
      expect(clear, true);

      final secondGet = sut.getPictures("ALL_PICTURES");
      expect(secondGet.length, 0);
    });
  });
}
