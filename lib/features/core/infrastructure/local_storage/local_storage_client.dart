abstract class LocalStorageClient {
  Future<bool> setPictures(String key, List<Map<String, dynamic>> value);
  List<dynamic> getPictures(String key);
  Future<bool> clear(String key);
}
