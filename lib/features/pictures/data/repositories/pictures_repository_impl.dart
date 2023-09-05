import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/dtos/picture_dto.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';

class PicturesRepositoryImpl implements PicturesRepository {
  final PicturesDatasource datasource;
  PicturesRepositoryImpl({required this.datasource});

  @override
  Future<List<Picture>> getAllPictures() async {
    final response = await datasource.getAllPictures();
    return response.map((e) => PictureDto.fromMap(e).toEntity()).toList();
  }
}
