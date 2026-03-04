import 'dart:convert';

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
    await sharedPreferences.setString(key, json.encode(value));
  }

  @override
  List<dynamic> getList(String key) {
    final String value = sharedPreferences.getString(key) ?? '';

    if (value.isEmpty) {
      return [];
    }

    return json.decode(value);
  }

  @override
  Future<void> clear(String key) async {
    await sharedPreferences.remove(key);
  }
}
