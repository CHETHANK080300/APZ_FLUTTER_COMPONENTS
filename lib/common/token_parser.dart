import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TokenParser {
  static final TokenParser _instance = TokenParser._internal();
  factory TokenParser() => _instance;
  TokenParser._internal();

  Map<String, dynamic>? _tokenData;
  Map<String, dynamic>? _supportingTokenData;

  Future<void> loadTokens() async {
    final tokenString = await rootBundle.loadString('assets/json/token_variables.json');
    _tokenData = json.decode(tokenString);

    final supportingTokenString = await rootBundle.loadString('assets/json/supporting_tokens.json');
    _supportingTokenData = json.decode(supportingTokenString);
  }

  T? getValue<T>(List<dynamic> path, {bool fromSupportingTokens = false}) {
    final data = fromSupportingTokens ? _supportingTokenData : _tokenData;
    if (data == null) {
      throw Exception("Tokens not loaded. Call loadTokens() first.");
    }

    dynamic currentValue = data;
    for (var key in path) {
      if (key is String && currentValue is Map<String, dynamic> && currentValue.containsKey(key)) {
        currentValue = currentValue[key];
      } else if (key is int && currentValue is List && key < currentValue.length) {
        currentValue = currentValue[key];
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
