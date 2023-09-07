import 'dart:convert';
import 'package:nasa_pictures_app/features/core/error/app_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';

class SharedPreferencesAdapter implements LocalStorageClient {
  final SharedPreferences sharedPreferences;
  SharedPreferencesAdapter({required this.sharedPreferences});

  @override
  Future<bool> save(String key, List<Map<String, dynamic>> value) {
    try {
      return sharedPreferences.setString(key, json.encode(value));
    } catch (e) {
      throw AppError(type: AppErrorType.localStorage, exception: e);
    }
  }

  @override
  List<dynamic> get(String key) {
    try {
      final String value = sharedPreferences.getString(key) ?? "";

      if (value.isEmpty) {
        return [];
      }

      return json.decode(value);
    } catch (e) {
      throw AppError(type: AppErrorType.localStorage, exception: e);
    }
  }

  @override
  Future<bool> clear(String key) async {
    try {
      return await sharedPreferences.remove(key);
    } catch (e) {
      throw AppError(type: AppErrorType.localStorage, exception: e);
    }
  }
}
