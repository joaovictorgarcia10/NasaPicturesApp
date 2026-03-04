import 'package:nasa_pictures_app/core/utils/network_connection/network_connection_controller.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_local_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/dtos/picture_dto.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';

class PicturesRepositoryImpl implements PicturesRepository {
  final PicturesRemoteDatasource remoteDatasource;
  final PicturesLocalDatasource localDatasource;
  final NetworkConnectionController networkConnectionController;

  PicturesRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkConnectionController,
  });

  @override
  Future<List<Picture>> getPictures({
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    late List<Map<String, dynamic>> response;
    final hasConnection = await networkConnectionController.hasConnection();

    if (hasConnection) {
      response = await remoteDatasource.getPictures(
        date: date,
        startDate: startDate,
        endDate: endDate,
      );
      
      localDatasource.savePictures(pictures: response);
    } else {
      response = await localDatasource.getPictures();
    }

    return response.map((e) => PictureDto.fromMap(e).toEntity()).toList();
  }
}
