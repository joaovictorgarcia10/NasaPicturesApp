import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/utils/network_connection/network_connection_controller.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/dtos/picture_dto.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';

class PicturesRepositoryImpl implements PicturesRepository {
  final PicturesDatasource remoteDatasource;
  final PicturesDatasource localDatasource;
  final NetworkConnectionController networkConnectionController;

  PicturesRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkConnectionController,
  });

  @override
  Future<List<Picture>> getPictures() async {
    try {
      late List<Map<String, dynamic>> response;
      final hasConnection = await networkConnectionController.hasConnection();

      if (hasConnection) {
        response = await remoteDatasource.getPictures();
      } else {
        response = await localDatasource.getPictures();
      }

      return response.map((e) => PictureDto.fromMap(e).toEntity()).toList();
    } catch (e) {
      throw AppError(type: AppErrorType.repository, exception: e);
    }
  }
}
