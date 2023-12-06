import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';

class GetPicturesUsecase {
  final PicturesRepository repository;

  GetPicturesUsecase({required this.repository});

  Future<List<Picture>> call() async {
    return await repository.getPictures();
  }
}
