import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/check_internet_connection_usecase.dart';

class GetAllPicturesUsecase {
  final PicturesRepository repository;
  final CheckInternetConnectionUsecase checkInternetConnection;

  GetAllPicturesUsecase({
    required this.repository,
    required this.checkInternetConnection,
  });

  Future<List<Picture>> call() async {
    final isOnline = await checkInternetConnection();
    final response = await repository.getAllPictures(isOnline: isOnline);
    return response;
  }
}
