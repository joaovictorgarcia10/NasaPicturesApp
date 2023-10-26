import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/dtos/picture_dto.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';

class PicturesRepositoryImpl implements PicturesRepository {
  final PicturesDatasource remoteDatasource;
  final PicturesDatasource localDatasource;

  PicturesRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<Picture>> getPictures({required bool isOnline}) async {
    try {
      late List<Map<String, dynamic>> response;

      if (isOnline) {
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
