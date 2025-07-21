import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class UIConfigResolver {
  static final UIConfigResolver _instance = UIConfigResolver._internal();
  factory UIConfigResolver() => _instance;
  UIConfigResolver._internal();

  static Map<String, dynamic> _masterTheme = {};

  static Future<UIConfigResolver> loadMaster(String path) async {
    final jsonStr = await rootBundle.loadString(path);
    _masterTheme = json.decode(jsonStr);
    return _instance;
  }

  Future<Map<String, dynamic>> loadAndResolve(String path) async {
    final rawJson = await rootBundle.loadString(path);
    final parsed = json.decode(rawJson) as Map<String, dynamic>;
    return _resolveVariables(parsed);
  }

  Map<String, dynamic> _resolveVariables(Map<String, dynamic> json) {
    final resolved = <String, dynamic>{};

    json.forEach((key, value) {
      resolved[key] = _resolveValue(value);
    });

    return resolved;
  }

  dynamic _resolveValue(dynamic value) {
    if (value is String && _isVariable(value)) {
      final variablePath = _extractVariablePath(value);
      return _getValueFromMasterTheme(variablePath) ?? value;
    } else if (value is Map<String, dynamic>) {
      return _resolveVariables(value);
    } else if (value is List) {
      return value.map(_resolveValue).toList();
    }
    return value;
  }

  bool _isVariable(String value) =>
      value.startsWith('{') && value.endsWith('}');

  String _extractVariablePath(String value) =>
      value.substring(1, value.length - 1);

  dynamic _getValueFromMasterTheme(String path) {
    final keys = path.split('.');
    dynamic result = _masterTheme;
    for (final key in keys) {
      if (result is Map<String, dynamic> && result.containsKey(key)) {
        result = result[key];
      } else {
        return null;
      }
    }
    return result;
  }
}
