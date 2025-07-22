import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class UIConfigResolver {
  static final UIConfigResolver _instance = UIConfigResolver._internal();
  factory UIConfigResolver() => _instance;
  UIConfigResolver._internal();

  // This class is now simplified as it's not resolving variables from a master theme anymore for the button.
  // If other components still use it, we leave the variable resolution logic.
  // For the button, we are moving to a direct token-based approach.

  Future<Map<String, dynamic>> loadJson(String path) async {
    final rawJson = await rootBundle.loadString(path);
    return json.decode(rawJson) as Map<String, dynamic>;
  }
}
