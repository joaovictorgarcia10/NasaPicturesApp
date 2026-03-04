import 'package:flutter/foundation.dart';

import 'package:nasa_pictures_app/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/core/utils/network_connection/network_connection_controller.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/usecases/get_pictures_usecase.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/home_state.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_presenter.dart';

/// Concrete implementation of [HomePresenter].
class HomePresenterImpl implements HomePresenter {
  /// Use-case responsible for fetching pictures from the repository.
  final GetPicturesUsecase getPicturesUsecase;

  /// Controller used to verify network availability before pagination.
  final NetworkConnectionController networkConnectionController;

  /// Creates a [HomePresenterImpl] with the required dependencies.
  HomePresenterImpl({
    required this.getPicturesUsecase,
    required this.networkConnectionController,
  });

  // _____________________________________________________________________________

  List<Picture> _allPictures = [];
  List<Picture> _filteredPictures = [];

  // _____________________________________________________________________________

  @override
  ValueNotifier<HomeState> state = ValueNotifier(HomeStateLoading());

  @override
  ValueNotifier<bool> shouldPaginate = ValueNotifier(true);

  @override
  ValueNotifier<bool> isDateFiltered = ValueNotifier(false);

  // _____________________________________________________________________________

  @override
  Future<void> getPictures() async {
    state.value = HomeStateLoading();

    try {
      final response = await getPicturesUsecase();
      _allPictures = response;
      state.value = HomeStateSuccess(pictures: _allPictures);
    } catch (e) {
      state.value = HomeStateError(message: "Something went wrong.");
    }
  }

  @override
  Future<void> refreshPictures() async {
    state.value = HomeStateLoading();

    try {
      shouldPaginate.value = true;
      isDateFiltered.value = false;
      final response = await getPicturesUsecase();
      _allPictures = response;
      state.value = HomeStateSuccess(pictures: _allPictures);
    } catch (e) {
      state.value = HomeStateError(message: "Something went wrong.");
    }
  }

  @override
  Future<void> paginatePictures() async {
    final hasConnection = await networkConnectionController.hasConnection();

    if (hasConnection &&
        _allPictures.length < AppConstants.pictureListMaxLenght) {
      try {
        final response = await getPicturesUsecase();
        _allPictures = [..._allPictures, ...response];
        state.value = HomeStateSuccess(pictures: _allPictures);
      } catch (e) {
        shouldPaginate.value = false;
      }
    } else {
      shouldPaginate.value = false;
    }
  }

  @override
  Future<void> search(String value) async {
    if (value.isNotEmpty) {
      shouldPaginate.value = false;
      state.value = HomeStateSuccess(pictures: _allPictures);

      _filteredPictures =
          _allPictures.where((picture) {
            return picture.title.toLowerCase().contains(value.toLowerCase());
          }).toList();

      if (_filteredPictures.isEmpty) {
        state.value = HomeStateError(message: "No items found.");
      } else {
        state.value = HomeStateSuccess(pictures: _filteredPictures);
      }
    } else {
      shouldPaginate.value = true;
      state.value = HomeStateSuccess(pictures: _allPictures);
    }
  }

  @override
  Future<void> filterByDate(DateTime date) async {
    state.value = HomeStateLoading();

    try {
      final formatted =
          "${date.year.toString().padLeft(4, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.day.toString().padLeft(2, '0')}";

      final response = await getPicturesUsecase(date: formatted);
      _allPictures = response;
      shouldPaginate.value = false;
      isDateFiltered.value = true;
      state.value = HomeStateSuccess(pictures: _allPictures);
    } catch (e) {
      state.value = HomeStateError(message: "Something went wrong.");
    }
  }

  @override
  Future<void> filterByDateRange(DateTime start, DateTime end) async {
    state.value = HomeStateLoading();

    try {
      String fmt(DateTime d) =>
          "${d.year.toString().padLeft(4, '0')}-"
          "${d.month.toString().padLeft(2, '0')}-"
          "${d.day.toString().padLeft(2, '0')}";

      final response = await getPicturesUsecase(
        startDate: fmt(start),
        endDate: fmt(end),
      );
      _allPictures = response;
      shouldPaginate.value = false;
      isDateFiltered.value = true;
      state.value = HomeStateSuccess(pictures: _allPictures);
    } catch (e) {
      state.value = HomeStateError(message: "Something went wrong.");
    }
  }

  @override
  void dispose() {
    state.dispose();
    shouldPaginate.dispose();
    isDateFiltered.dispose();
  }
}
