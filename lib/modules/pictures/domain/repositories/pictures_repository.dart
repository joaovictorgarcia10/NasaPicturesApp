import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';

abstract class PicturesRepository {
  Future<List<Picture>> getPictures();
}
