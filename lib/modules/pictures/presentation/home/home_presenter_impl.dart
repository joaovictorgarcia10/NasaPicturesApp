import 'package:flutter/foundation.dart';

import 'package:nasa_pictures_app/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/core/infrastructure/network_connection/network_connection_client.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/usecases/get_pictures_usecase.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/home_state.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_presenter.dart';

class HomePresenterImpl implements HomePresenter {
  final GetPicturesUsecase getPicturesUsecase;
  final NetworkConnectionClient networkConnectionClient;

  HomePresenterImpl({
    required this.getPicturesUsecase,
    required this.networkConnectionClient,
  });

// _____________________________________________________________________________

  List<Picture> _allPictures = [];

  List<Picture> _filteredPictures = [];

// _____________________________________________________________________________

  @override
  ValueNotifier<HomeState> state = ValueNotifier(HomeStateLoading());

  @override
  ValueNotifier<bool> shouldPaginate = ValueNotifier(true);

// _____________________________________________________________________________

  @override
  Future<void> getPictures() async {
    state.value = HomeStateLoading();

    try {
      final response = await getPicturesUsecase();
      _allPictures.addAll(response);
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
      final response = await getPicturesUsecase();
      _allPictures = response;
      state.value = HomeStateSuccess(pictures: _allPictures);
    } catch (e) {
      state.value = HomeStateError(message: "Something went wrong.");
    }
  }

  @override
  Future<void> paginatePictures() async {
    final hasConnection = await networkConnectionClient.hasConnection();

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

      _filteredPictures = _allPictures.where((picture) {
        var titleMatch =
            picture.title.toLowerCase().contains(value.toLowerCase());
        var dateMatch = picture.date.contains(value);
        return (titleMatch || dateMatch);
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
}
