import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reminder_frontend/core/ports/outputPorts/secure_storage.dart';

class FlutterStorage implements SecureStorage {
  late final FlutterSecureStorage storage;

  FlutterStorage(){
    // Create storage
    storage = const FlutterSecureStorage();
  }

  @override
  delete(String key) async {
    await storage.delete(key: key);
  }

  @override
  deleteAll() async {
    await storage.deleteAll();
  }

  @override
  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  @override
  Future<Map<String, String>> readAll() async {
    return await storage.readAll();
  }

  @override
  write(String key, String value) async {
    await storage.write(key: key, value: value);
  }
}

