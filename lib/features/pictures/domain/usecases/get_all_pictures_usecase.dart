import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';

class GetAllPicturesUsecase {
  final PicturesRepository repository;
  GetAllPicturesUsecase({required this.repository});

  Future<List<Picture>> call() async {
    final response = await repository.getAllPictures();
    return response;
  }
}
