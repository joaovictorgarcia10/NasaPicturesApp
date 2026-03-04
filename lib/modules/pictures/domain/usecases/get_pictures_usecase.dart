import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';

class GetPicturesUsecase {
  final PicturesRepository repository;

  GetPicturesUsecase({required this.repository});

  /// Fetches pictures from the repository.
  ///
  /// Pass [date] for a single-day query (`YYYY-MM-DD`).
  /// Pass [startDate] + [endDate] for a date-range query.
  /// Omit all params to retrieve a random batch.
  Future<List<Picture>> call({
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    return await repository.getPictures(
      date: date,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
