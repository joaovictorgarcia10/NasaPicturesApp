import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';

abstract class PicturesRepository {
  Future<List<Picture>> getAllPictures({required bool isOnline});
}
