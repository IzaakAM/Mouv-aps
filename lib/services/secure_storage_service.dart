import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();

  SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save
  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Delete all
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // Check if a key exists
  Future<bool> exists(String key) async {
    String? value = await _storage.read(key: key);
    return value != null; // Return true if the value exists, false otherwise
  }

  // Check auth
  Future<bool> checkAuth() async {
    return await exists('jwt_access') && await exists('jwt_refresh');
  }
}
