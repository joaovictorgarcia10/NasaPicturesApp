abstract class LocalStorageClient {
  Future<bool> saveList(String key, List<Map<String, dynamic>> value);
  List<dynamic> getList(String key);
  Future<bool> clear(String key);
}
