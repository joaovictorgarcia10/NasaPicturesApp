import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';

class PicturesLocalDatasource implements PicturesDatasource {
  final LocalStorageClient localStorageClient;
  PicturesLocalDatasource({required this.localStorageClient});

  @override
  Future<List<dynamic>> getAllPictures() async {
    throw UnimplementedError();
  }

  Future<List<dynamic>> setPictures() async {
    throw UnimplementedError();
  }

  Future<List<dynamic>> removePictures() async {
    throw UnimplementedError();
  }
}
