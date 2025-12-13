import 'package:flutter/material.dart';
import 'cache_service.dart';

class GlobalUserCache {
  GlobalUserCache._(); 
  static final GlobalUserCache instance = GlobalUserCache._();

  
  static String? token;
  static String? email;
  static String? password;

  
  static ThemeMode themeMode = ThemeMode.light;

  
  static Future< void> loadFromCache() {
    token = CacheService.instance.read<String>("token");
    email = CacheService.instance.read<String>("email");
    password = CacheService.instance.read<String>("password");

    String? cachedTheme = CacheService.instance.read<String>("theme_mode");
    if (cachedTheme != null) {
      themeMode = cachedTheme == "dark" ? ThemeMode.dark : ThemeMode.light;
    }

    
    print("Global Cache loaded:");
    print("Token: $token");
    print("Email: $email");
    print("Password: $password");
    print("Theme: $themeMode");
    return Future.value();
  }

  
  static Future<void> saveUser({
    required String tokenValue,
    required String emailValue,
    required String passwordValue,
  }) async {
    token = tokenValue;
    email = emailValue;
    password = passwordValue;

    await CacheService.instance.write("token", tokenValue);
    await CacheService.instance.write("email", emailValue);
    await CacheService.instance.write("password", passwordValue);

    
    print("User saved to cache:");
    print("Token: $token");
    print("Email: $email");
    print("Password: $password");
  }

  
 

  
  static Future<void> clear() async {
    await CacheService.instance.clear();
    token = null;
    email = null;
    password = null;
    themeMode = ThemeMode.light;

    print("Global cache cleared");
  }
}
