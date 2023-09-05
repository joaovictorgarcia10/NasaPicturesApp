import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/get_all_pictures_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/ui/pages/home/home_presenter.dart';

class HomePresenterImpl implements HomePresenter {
  final GetAllPicturesUsecase getAllPicturesUsecase;

  HomePresenterImpl({
    required this.getAllPicturesUsecase,
  });

  @override
  ValueNotifier<List<Picture>> picturesNotifier = ValueNotifier([]);

  @override
  Future<void> getAllPictures() async {
    final response = await getAllPicturesUsecase();
    picturesNotifier.value = response;
  }

  @override
  Future<void> refreshPictures() async {}

  @override
  Future<void> paginatePictures() async {}

  @override
  Future<void> searchByDate() async {}

  @override
  Future<void> searchByName() async {}
}
