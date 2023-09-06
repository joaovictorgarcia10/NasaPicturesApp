import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';

abstract class HomePresenter {
  ValueNotifier<List<Picture>?> get picturesNotifier;

  ValueNotifier<bool> get shouldPaginate;

  Future<void> getAllPictures();
  Future<void> refreshPictures();
  Future<void> paginatePictures();
  Future<void> search(String value);
}
