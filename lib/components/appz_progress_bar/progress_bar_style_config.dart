import 'package:flutter/material.dart';

class ProgressBarStyleConfig {
  static final ProgressBarStyleConfig instance = ProgressBarStyleConfig._internal();
  late Map<String, dynamic> _config;

  ProgressBarStyleConfig._internal();

  Future<void> loadFromResolved(Map<String, dynamic> resolvedConfig) async {
    _config = resolvedConfig;
  }

  dynamic get(String key, {String? category}) {
    if (category != null && _config[category] != null && _config[category][key] != null) {
      return _config[category][key];
    }
    return _config['common']?[key];
  }

  double getDouble(String key, {String? category}) {
    final value = get(key, category: category);
    return value is num ? value.toDouble() : 0.0;
  }

  Color getColor(String key, {String? category}) {
    final hex = get(key, category: category);
    if (hex is String && hex.startsWith('#')) {
      return _hexToColor(hex);
    }
    return Colors.transparent;
  }

  EdgeInsets getEdgeInsets(String key, {String? category}) {
    final value = get(key, category: category);
    if (value is Map) {
      final h = (value['horizontal'] ?? 0).toDouble();
      final v = (value['vertical'] ?? 0).toDouble();
      return EdgeInsets.symmetric(horizontal: h, vertical: v);
    }
    return EdgeInsets.zero;
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
