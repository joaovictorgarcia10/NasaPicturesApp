import 'dart:convert';

import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/local_storage_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [LocalStorageClient] implementation backed by [SharedPreferencesWithCache].
class SharedPreferencesAdapter implements LocalStorageClient {
  final SharedPreferencesWithCache sharedPreferences;

  /// Creates a [SharedPreferencesAdapter] with an already-initialised
  /// [SharedPreferencesWithCache] instance.
  SharedPreferencesAdapter({required this.sharedPreferences});

  @override
  Future<void> saveList(String key, List<Map<String, dynamic>> value) async {
    try {
      await sharedPreferences.setString(key, json.encode(value));
    } on AppError {
      rethrow;
    } catch (e) {
      throw AppError(type: AppErrorType.localStorage, exception: e);
    }
  }

  @override
  List<dynamic> getList(String key) {
    try {
      final String value = sharedPreferences.getString(key) ?? '';

      if (value.isEmpty) {
        return [];
      }

      return json.decode(value);
    } on AppError {
      rethrow;
    } catch (e) {
      throw AppError(type: AppErrorType.localStorage, exception: e);
    }
  }

  @override
  Future<void> clear(String key) async {
    try {
      await sharedPreferences.remove(key);
    } on AppError {
      rethrow;
    } catch (e) {
      throw AppError(type: AppErrorType.localStorage, exception: e);
    }
  }
}
