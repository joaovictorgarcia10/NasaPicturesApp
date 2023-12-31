import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/modules/pictures/data/dtos/picture_dto.dart';

import '../../mock/picture_list_mock.dart';

void main() {
  late PictureDto sut;

  setUp(() {
    sut = PictureDto.fromMap(pictureLisMock.first);
  });

  group("PictureDto Tests", () {
    test("Should return a PictureDto with the expected values", () {
      expect(sut.date, "2007-05-18");
      expect(sut.copyright, "Thomas V. Davis");
      expect(sut.explanation,
          "In 1714, Edmond Halley noted that M13 \"shows itself to the naked eye when the sky is serene and the Moon absent.\" Of course, M13 is now modestly recognized as the Great Globular Cluster in Hercules, one of the brightest globular star clusters in the northern sky. Telescopic views reveal the spectacular cluster's hundreds of thousands of stars. At a distance of 25,000 light-years, the cluster stars crowd into a region 150 light-years in diameter, but approaching the cluster core upwards of 100 stars could be contained in a cube just 3 light-years on a side. For comparison, the closest star to the Sun is over 4 light-years away. Along with the cluster's dense core, the outer reaches of M13 are highlighted in this deep color image. A distant background galaxy, NGC 6207 is also visible above and to the right of the Great Globular Cluster M13.");
      expect(
          sut.hdurl, "https://apod.nasa.gov/apod/image/0705/m13_tvdavis.jpg");
      expect(sut.mediaType, "image");
      expect(sut.serviceVersion, "v1");
      expect(sut.title, "M13: The Great Globular Cluster in Hercules");
      expect(sut.url,
          "https://apod.nasa.gov/apod/image/0705/m13_tvdavis_c720.jpg");
    });

    test("Should return a PictureEntity with the expected values", () {
      final entity = sut.toEntity();

      expect(entity.date, "18/05/2007");
      expect(entity.copyright, "Thomas V. Davis");
      expect(entity.explanation,
          "In 1714, Edmond Halley noted that M13 \"shows itself to the naked eye when the sky is serene and the Moon absent.\" Of course, M13 is now modestly recognized as the Great Globular Cluster in Hercules, one of the brightest globular star clusters in the northern sky. Telescopic views reveal the spectacular cluster's hundreds of thousands of stars. At a distance of 25,000 light-years, the cluster stars crowd into a region 150 light-years in diameter, but approaching the cluster core upwards of 100 stars could be contained in a cube just 3 light-years on a side. For comparison, the closest star to the Sun is over 4 light-years away. Along with the cluster's dense core, the outer reaches of M13 are highlighted in this deep color image. A distant background galaxy, NGC 6207 is also visible above and to the right of the Great Globular Cluster M13.");
      expect(entity.hdurl,
          "https://apod.nasa.gov/apod/image/0705/m13_tvdavis.jpg");
      expect(entity.mediaType, "image");
      expect(entity.serviceVersion, "v1");
      expect(entity.title, "M13: The Great Globular Cluster in Hercules");
      expect(entity.url,
          "https://apod.nasa.gov/apod/image/0705/m13_tvdavis_c720.jpg");
    });
  });
}
