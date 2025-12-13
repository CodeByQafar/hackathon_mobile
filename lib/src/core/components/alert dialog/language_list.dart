import 'package:flutter/widgets.dart';

class AppLanguage {
  final String name; 
  final Locale locale; 
  final String countryCode; 

  AppLanguage({
    required this.name,
    required this.locale,
    required this.countryCode,
  });
}


class Languages {
  static final List<AppLanguage> languages = [
    AppLanguage(
      name: "English",
      locale: const Locale('en'),
      countryCode: 'US', 
    ),
    AppLanguage(
      name: "Azərbaycan",
      locale: const Locale('az'),
      countryCode: 'AZ', 
    ),
    AppLanguage(
      name: "Türkçe",
      locale: const Locale('tr'),
      countryCode: 'TR', 
    ),
  ];
}
