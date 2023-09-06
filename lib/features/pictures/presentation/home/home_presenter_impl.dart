import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/get_all_pictures_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/presentation/home/home_state.dart';
import 'package:nasa_pictures_app/features/pictures/ui/home/home_presenter.dart';

class HomePresenterImpl implements HomePresenter {
  final GetAllPicturesUsecase getAllPicturesUsecase;
  HomePresenterImpl({required this.getAllPicturesUsecase});

// _____________________________________________________________________________

  List<Picture> _allPictures = [];

  List<Picture> _filteredPictures = [];

// _____________________________________________________________________________

  @override
  // TODO: implement state
  ValueNotifier<HomeState> state = ValueNotifier(HomeStateLoading());

  @override
  ValueNotifier<bool> shouldPaginate = ValueNotifier(true);

// _____________________________________________________________________________

  @override
  Future<void> getAllPictures() async {
    state.value = HomeStateLoading();

    try {
      final response = await getAllPicturesUsecase();
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
      final response = await getAllPicturesUsecase();
      _allPictures = response;
      state.value = HomeStateSuccess(pictures: _allPictures);
    } catch (e) {
      state.value = HomeStateError(message: "Something went wrong.");
    }
  }

  @override
  Future<void> paginatePictures() async {
    if (_allPictures.length <= 120) {
      try {
        final response = await getAllPicturesUsecase();
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
