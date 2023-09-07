import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_local_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/dtos/picture_dto.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';

class PicturesRepositoryImpl implements PicturesRepository {
  final PicturesRemoteDatasource remoteDatasource;
  final PicturesLocalDatasource localDatasource;

  PicturesRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<Picture>> getPictures({required bool isOnline}) async {
    late List<Map<String, dynamic>> response;

    if (isOnline) {
      response = await remoteDatasource.getPictures();
    } else {
      response = await localDatasource.getPictures();
    }

    return response.map((e) => PictureDto.fromMap(e).toEntity()).toList();
  }
}
