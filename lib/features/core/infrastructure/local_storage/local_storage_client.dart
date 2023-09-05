abstract class LocalStorageClient {
  Future<bool> setMap(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getMap(String key);
  Future<void> clear(String key);
}
