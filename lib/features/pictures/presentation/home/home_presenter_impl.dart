import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/get_all_pictures_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/ui/home/home_presenter.dart';

class HomePresenterImpl implements HomePresenter {
  final GetAllPicturesUsecase getAllPicturesUsecase;
  HomePresenterImpl({required this.getAllPicturesUsecase});

// _____________________________________________________________________________

  List<Picture> _allPictures = [];

  List<Picture> _filteredPictures = [];

// _____________________________________________________________________________

  @override
  ValueNotifier<List<Picture>?> picturesNotifier = ValueNotifier([]);

  @override
  ValueNotifier<bool> shouldPaginate = ValueNotifier(true);

// _____________________________________________________________________________

  @override
  Future<void> getAllPictures() async {
    try {
      final response = await getAllPicturesUsecase();
      _allPictures.addAll(response);
      picturesNotifier.value = _allPictures;
    } catch (e) {
      picturesNotifier.value = null;
    }
  }

  @override
  Future<void> refreshPictures() async {
    try {
      shouldPaginate.value = true;
      final response = await getAllPicturesUsecase();
      _allPictures = response;
      picturesNotifier.value = _allPictures;
    } catch (e) {
      picturesNotifier.value = null;
    }
  }

  @override
  Future<void> paginatePictures() async {
    if (_allPictures.length <= 120) {
      try {
        final response = await getAllPicturesUsecase();
        _allPictures = [..._allPictures, ...response];
        picturesNotifier.value = _allPictures;
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
      picturesNotifier.value = _allPictures;

      _filteredPictures = picturesNotifier.value!.where((picture) {
        var titleMatch =
            picture.title.toLowerCase().contains(value.toLowerCase());
        var dateMatch = picture.date.contains(value);

        return (titleMatch || dateMatch);
      }).toList();

      if (_filteredPictures.isEmpty) {
        picturesNotifier.value = null;
      } else {
        picturesNotifier.value = _filteredPictures;
      }
    } else {
      shouldPaginate.value = true;
      picturesNotifier.value = _allPictures;
    }
  }
}
