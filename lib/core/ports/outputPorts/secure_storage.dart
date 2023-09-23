abstract class SecureStorage {
  Future<String?> read(String key);
  Future<Map<String, String>> readAll();
  delete(String key);
  deleteAll();
  write(String key, String value);
}