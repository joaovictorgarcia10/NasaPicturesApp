import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';

sealed class HomeState {}

final class HomeStateLoading extends HomeState {
  HomeStateLoading();
}

final class HomeStateSuccess extends HomeState {
  final List<Picture> pictures;
  HomeStateSuccess({required this.pictures});
}

final class HomeStateError extends HomeState {
  final String message;
  HomeStateError({required this.message});
}
