import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';

class SharedPreferencesAdapter implements LocalStorageClient {
  final SharedPreferences sharedPreferences;
  SharedPreferencesAdapter({required this.sharedPreferences});

  @override
  Future<bool> setPictures(String key, List<Map<String, dynamic>> value) {
    return sharedPreferences.setString(key, json.encode(value));
  }

  @override
  List<dynamic> getPictures(String key) {
    final String value = sharedPreferences.getString(key) ?? "";

    if (value.isEmpty) {
      return [];
    }

    return json.decode(value);
  }

  @override
  Future<bool> clear(String key) async {
    return await sharedPreferences.remove(key);
  }
}
