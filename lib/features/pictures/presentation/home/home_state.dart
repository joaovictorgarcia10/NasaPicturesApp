import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';

abstract class HomeState {}

class HomeStateLoading extends HomeState {
  HomeStateLoading();
}

class HomeStateSuccess extends HomeState {
  final List<Picture>? pictures;
  HomeStateSuccess({
    this.pictures = const <Picture>[],
  });
}

class HomeStateError extends HomeState {
  final String message;
  HomeStateError({required this.message});
}
