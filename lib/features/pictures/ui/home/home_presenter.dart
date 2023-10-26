import 'package:flutter/foundation.dart';
import 'package:nasa_pictures_app/features/pictures/presentation/home/home_state.dart';

abstract class HomePresenter {
  ValueNotifier<HomeState> get state;
  ValueNotifier<bool> get shouldPaginate;

  Future<void> getPictures();
  Future<void> refreshPictures();
  Future<void> paginatePictures();
  Future<void> search(String value);
}
