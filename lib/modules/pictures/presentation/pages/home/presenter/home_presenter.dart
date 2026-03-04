import 'package:flutter/foundation.dart';

import 'package:nasa_pictures_app/modules/pictures/presentation/pages/home/presenter/home_state.dart';

/// Abstract interface for the Home screen presenter.
abstract class HomePresenter {
  /// The current page state.
  ValueNotifier<HomeState> get state;

  /// Whether the infinite-scroll pagination is active.
  ValueNotifier<bool> get shouldPaginate;

  /// Whether a date or date-range filter is currently active.
  ValueNotifier<bool> get isDateFiltered;

  /// Fetches a random batch of pictures on first load.
  Future<void> getPictures();

  /// Clears any active filter and fetches a fresh random batch.
  Future<void> refreshPictures();

  /// Loads the next page of random pictures (infinite scroll).
  Future<void> paginatePictures();

  /// Filters the in-memory picture list by [value] (title only).
  Future<void> search(String value);

  /// Fetches pictures for a specific [date] from the API.
  Future<void> filterByDate(DateTime date);

  /// Fetches pictures within [start]–[end] date range from the API.
  Future<void> filterByDateRange(DateTime start, DateTime end);

  /// Disposes all [ValueNotifier]s owned by this presenter.
  void dispose();
}
