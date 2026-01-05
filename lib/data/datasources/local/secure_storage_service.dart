import 'dart:convert';

class SecureStorageService {
  final Map<String, String> _storage = {};
  
  Future<void> write({required String key, required String value}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _storage[key] = value;
  }
  
  Future<String?> read({required String key}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _storage[key];
  }
  
  Future<void> delete({required String key}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _storage.remove(key);
  }
  
  Future<void> deleteAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _storage.clear();
  }
  
  Future<void> saveAuthToken(String token) async {
    await write(key: 'auth_token', value: token);
  }
  
  Future<String?> getAuthToken() async {
    return await read(key: 'auth_token');
  }
  
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await write(key: 'user_data', value: jsonEncode(userData));
  }
  
  Future<Map<String, dynamic>?> getUserData() async {
    final data = await read(key: 'user_data');
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }
}