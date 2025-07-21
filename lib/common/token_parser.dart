import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TokenParser {
  static final TokenParser _instance = TokenParser._internal();
  factory TokenParser() => _instance;
  TokenParser._internal();

  Map<String, dynamic>? _tokenData;

  Future<void> loadTokens() async {
    final String jsonString = await rootBundle.loadString('assets/json/token_variables.json');
    _tokenData = json.decode(jsonString);
  }

  T? getValue<T>(List<String> path) {
    if (_tokenData == null) {
      throw Exception("Tokens not loaded. Call loadTokens() first.");
    }

    dynamic currentValue = _tokenData;
    for (String key in path) {
      if (currentValue is Map<String, dynamic> && currentValue.containsKey(key)) {
        currentValue = currentValue[key];
      } else if (currentValue is List) {
        // Handle list indexing if necessary, for now we assume path navigation through maps
        return null;
      } else {
        return null;
      }
    }

    if (currentValue is T) {
      return currentValue;
    }

    return null;
  }
}
