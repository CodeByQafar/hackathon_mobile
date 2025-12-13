
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class CacheService {
  CacheService._();
  static final CacheService instance = CacheService._();

  Box? _box;

  
  Future<void> init() async {
    _box = await Hive.openBox('app_cache');
  }

  
  Future<void> write(String key, dynamic value) async {
    await _box?.put(key, value);
  }

  
  T? read<T>(String key) {
    return _box?.get(key) as T?;
  }

  
  Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  
  Future<void> clear() async {
    await _box?.clear();
  }

  
  bool contains(String key) {
    return _box?.containsKey(key) ?? false;
  }
}