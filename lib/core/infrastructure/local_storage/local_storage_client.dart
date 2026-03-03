/// Abstract interface for key-value local storage operations.
abstract class LocalStorageClient {
  Future<void> saveList(String key, List<Map<String, dynamic>> value);
  List<dynamic> getList(String key);
  Future<void> clear(String key);
}
