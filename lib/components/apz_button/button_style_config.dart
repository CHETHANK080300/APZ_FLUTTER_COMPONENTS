import 'package:flutter/material.dart';

class ButtonStyleConfig {
  static final ButtonStyleConfig instance = ButtonStyleConfig._internal();
  late Map<String, dynamic> _config;

  ButtonStyleConfig._internal();

  Future<void> loadFromResolved(Map<String, dynamic> resolvedConfig) async {
    _config = resolvedConfig;
  }

  dynamic get(String key, {String? category, String? state}) {
    if (category != null && state != null) {
      return _config['buttons']?[category]?[state]?[key] ??
             _config['buttons']?[category]?[key] ??
             _config['common']?[key];
    }
    if (category != null) {
      return _config['buttons']?[category]?[key] ??
             _config['common']?[key];
    }
    return _config['common']?[key];
  }

  Color getColor(String key, {String? category, String? state}) {
    final val = get(key, category: category, state: state);
    if (val is String) return _parseColor(val);
    return Colors.transparent;
  }

  double getDouble(String key) {
    final val = _config['common']?[key];
    if (val is num) return val.toDouble();
    return 0.0;
  }

  List<double> getPadding(String sizeKey) {
    final padding = _config['common']?['${sizeKey}_padding'];
    if (padding is List && padding.length == 2) {
      return [padding[0].toDouble(), padding[1].toDouble()];
    }
    return [0.0, 0.0];
  }

  String getFontFamily() => _config['common']?['fontFamily'] ?? 'Outfit';
  double getFontSize(String sizeKey) => (_config['common']?['${sizeKey}_fontSize'] ?? 14).toDouble();
  double getHeight(String sizeKey) => (_config['common']?['${sizeKey}_height'] ?? 40).toDouble();
  double getWidth(String sizeKey) => (_config['common']?['${sizeKey}_width'] ?? 100).toDouble();
  double getBorderRadius() => (_config['common']?['borderRadius'] ?? 25).toDouble();
  double getBorderWidth() => (_config['common']?['borderWidth'] ?? 1).toDouble();

  Color _parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
