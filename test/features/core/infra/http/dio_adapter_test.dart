import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/adapter/dio_adapter.dart';

void main() {
  late DioAdapter sut;

  setUp(() {
    sut = DioAdapter(
      dio: Dio(),
      apiEndpoint: "",
      apiKey: "",
    );
  });
}
