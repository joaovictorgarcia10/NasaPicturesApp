abstract class LocalStorageClient {
  Future<bool> save(String key, List<Map<String, dynamic>> value);
  List<dynamic> get(String key);
  Future<bool> clear(String key);
}
