import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nasa_pictures_app/features/core/infra/local_storage/local_storage_client.dart';

class SharedPreferencesAdapter implements LocalStorageClient {
  final SharedPreferences sharedPreferences;
  SharedPreferencesAdapter({required this.sharedPreferences});

  @override
  Future<bool> setMap(String key, Map<String, dynamic> value) {
    return sharedPreferences.setString(key, json.encode(value));
  }

  @override
  Future<Map<String, dynamic>?> getMap(String key) {
    final String value = sharedPreferences.getString(key)!;
    return json.decode(value);
  }

  @override
  Future<void> clear(String key) async {
    await sharedPreferences.remove(key);
    return;
  }
}
