import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/get_all_pictures_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/ui/pages/home/home_presenter.dart';

class HomePresenterImpl implements HomePresenter {
  final GetAllPicturesUsecase getAllPicturesUsecase;
  HomePresenterImpl({required this.getAllPicturesUsecase});

// _____________________________________________________________________________

  List<Picture> allPictures = [];

  List<Picture> filteredPictures = [];

// _____________________________________________________________________________

  @override
  ValueNotifier<List<Picture>?> picturesNotifier = ValueNotifier([]);

  @override
  bool shouldPaginate = true;

// _____________________________________________________________________________

  @override
  Future<void> getAllPictures() async {
    final response = await getAllPicturesUsecase();
    allPictures.addAll(response);
    picturesNotifier.value = allPictures;
  }

  @override
  Future<void> refreshPictures() async {
    allPictures.clear();

    final response = await getAllPicturesUsecase();
    allPictures = response;

    shouldPaginate = true;
    picturesNotifier.value = allPictures;
  }

  @override
  Future<void> paginatePictures() async {
    final response = await getAllPicturesUsecase();
    allPictures = [...allPictures, ...response];
    picturesNotifier.value = allPictures;
  }

  @override
  Future<void> search(String value) async {
    if (value.isNotEmpty) {
      shouldPaginate = false;
      picturesNotifier.value = allPictures;

      filteredPictures = picturesNotifier.value!.where((picture) {
        var titleMatch =
            picture.title.toLowerCase().contains(value.toLowerCase());

        var dateMatch = picture.date.contains(value);

        return (titleMatch || dateMatch);
      }).toList();

      if (filteredPictures.isEmpty) {
        picturesNotifier.value = null;
      }

      picturesNotifier.value = filteredPictures;
    } else {
      shouldPaginate = true;
      picturesNotifier.value = allPictures;
    }
  }
}
