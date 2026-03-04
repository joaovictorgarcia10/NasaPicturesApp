/// Abstract contract for a pictures data source.
abstract class PicturesDatasource {
  /// Fetches a list of pictures.
  ///
  /// Pass [date] for a single APOD entry (`YYYY-MM-DD`).
  /// Pass [startDate] + [endDate] for a date-range query.
  /// Omit all params to retrieve a random batch of 15 pictures.
  Future<List<Map<String, dynamic>>> getPictures({
    String? date,
    String? startDate,
    String? endDate,
  });
}
