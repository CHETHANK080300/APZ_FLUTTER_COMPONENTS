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
    final data = fromSupportingTokens ? _supportingTokenData : _getResolvedVariables();
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

  Map<String, dynamic> _getResolvedVariables() {
    if (_tokenData == null) {
      return {};
    }

    final resolved = <String, dynamic>{};
    final collections = _tokenData!['collections'] as List;

    for (var collection in collections) {
      final modes = collection['modes'] as List;
      for (var mode in modes) {
        final variables = mode['variables'] as List;
        for (var variable in variables) {
          final name = variable['name'] as String;
          final value = _resolveValue(variable);
          _assignValue(resolved, name.split('/'), value);
        }
      }
    }
    return resolved;
  }

  dynamic _resolveValue(Map<String, dynamic> variable) {
    if (variable.containsKey('value')) {
      if (variable['isAlias'] == true) {
        final alias = variable['value'] as Map<String, dynamic>;
        final collectionName = alias['collection'] as String;
        final variableName = alias['name'] as String;
        return _findVariableValue(collectionName, variableName);
      } else {
        return variable['value'];
      }
    }
    return null;
  }

  dynamic _findVariableValue(String collectionName, String variableName) {
    final collections = _tokenData!['collections'] as List;
    for (var collection in collections) {
      if (collection['name'] == collectionName) {
        final modes = collection['modes'] as List;
        for (var mode in modes) {
          final variables = mode['variables'] as List;
          for (var variable in variables) {
            if (variable['name'] == variableName) {
              return _resolveValue(variable);
            }
          }
        }
      }
    }
    return null;
  }

  void _assignValue(Map<String, dynamic> map, List<String> path, dynamic value) {
    for (int i = 0; i < path.length - 1; i++) {
      map = map.putIfAbsent(path[i], () => <String, dynamic>{});
    }
    map[path.last] = value;
  }
}
