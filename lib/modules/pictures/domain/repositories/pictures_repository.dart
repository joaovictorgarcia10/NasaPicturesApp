import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';

/// Abstract contract for the pictures repository.
abstract class PicturesRepository {
  /// Returns a list of [Picture] entities.
  ///
  /// Pass [date] for a single-day query (`YYYY-MM-DD`).
  /// Pass [startDate] + [endDate] for a date-range query.
  /// Omit all params to retrieve a random batch.
  Future<List<Picture>> getPictures({
    String? date,
    String? startDate,
    String? endDate,
  });
}
