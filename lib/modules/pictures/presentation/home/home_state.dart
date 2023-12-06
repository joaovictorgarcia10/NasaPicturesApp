import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';

abstract class HomeState {}

class HomeStateLoading extends HomeState {
  HomeStateLoading();
}

class HomeStateSuccess extends HomeState {
  final List<Picture> pictures;
  HomeStateSuccess({required this.pictures});
}

class HomeStateError extends HomeState {
  final String message;
  HomeStateError({required this.message});
}
