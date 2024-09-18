import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _loginToken = "logintoken";

extension StorageUtil on IStorage {
  Future<bool> isLoggedIn() async {
    return await getLoginToken() != null;
  }

  Future setLoginToken(String token) async {
    await write(
      key: _loginToken,
      value: token,
    );
  }

  Future<String?> getLoginToken() async {
    return await read(
      key: _loginToken,
    );
  }
}

class SecureStorage implements IStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<bool> containKey({required String key}) {
    return _storage.containsKey(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<bool?> readBoolean({required String key}) {
    return _storage.read(key: key).then((value) {
      if (value == null) return null;
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
      return null; // Or handle invalid values as needed
    });
  }

  @override
  Future<double?> readDouble({required String key}) {
    return _storage.read(key: key).then((value) => double.parse(value ?? ""));
  }

  @override
  Future<int?> readInt({required String key}) {
    return _storage.read(key: key).then((value) => int.tryParse(value ?? ""));
  }

  @override
  Future<void> write({required String key, required String? value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<bool> has(String key) async {
    return await _storage.read(key: key) != null;
  }
}

abstract class IStorage {
  Future<String?> read({required String key});
  Future<int?> readInt({required String key});
  Future<double?> readDouble({required String key});
  Future<bool?> readBoolean({required String key});

  Future<void> write({
    required String key,
    required String? value,
  });

  Future<bool> containKey({
    required String key,
  });

  Future<void> delete({
    required String key,
  });

  Future<void> deleteAll();

  Future<bool> has(String key);
}
