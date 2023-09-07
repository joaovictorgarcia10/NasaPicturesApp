import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/check_internet_connection_usecase.dart';

class GetPicturesUsecase {
  final PicturesRepository repository;
  final CheckInternetConnectionUsecase checkInternetConnection;

  GetPicturesUsecase({
    required this.repository,
    required this.checkInternetConnection,
  });

  Future<List<Picture>> call() async {
    final isOnline = await checkInternetConnection();
    return await repository.getPictures(isOnline: isOnline);
  }
}
