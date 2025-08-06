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
/*import 'dart:convert';
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

    if (fromSupportingTokens) {
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
    } else {
      final collections = data['collections'] as List<dynamic>;
      final collection = collections.firstWhere((c) => c['name'] == path[0], orElse: () => null);
      if (collection == null) return null;

      final modes = collection['modes'] as List<dynamic>;
      final mode = modes.firstWhere((m) => m['name'] == path[1], orElse: () => null);
      if (mode == null) return null;

      final variables = mode['variables'] as List<dynamic>;
      if (path.length == 3) {
        final variable = variables.firstWhere((v) => v['name'] == path[2], orElse: () => null);
        if (variable != null) {
          if (variable['value'] is T) {
            return variable['value'];
          } else if (variable['value'] is Map && variable['value']['collection'] != null) {
            return getValue([
              variable['value']['collection'],
              'CSC - Light theme',
              variable['value']['name'],
            ]);
          }
        }
      } else if (path.length == 4) {
        final variable = variables.firstWhere((v) => v['name'] == path[2], orElse: () => null);
        if (variable != null && variable['value'] is Map<String, dynamic>) {
          dynamic value = variable['value'][path[3]];
          if (value is T) {
            return value;
          }
        }
      }
    }

    return null;
  }
}*/
