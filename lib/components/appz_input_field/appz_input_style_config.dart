import 'package:flutter/material.dart';
import 'appz_input_field_enums.dart';

Color _parseColor(String? hexColor, Color defaultColor) {
  if (hexColor == null || hexColor.isEmpty) return defaultColor;
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) hexColor = "FF$hexColor";
  return Color(int.parse(hexColor, radix: 16));
}

class AppzStateStyle {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color labelColor;
  final String fontFamily;
  final double fontSize;
  final double labelFontSize;
  final double paddingHorizontal;
  final double paddingVertical;

  const AppzStateStyle({
    required this.borderColor,
    this.borderWidth = 1.0,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textColor,
    required this.labelColor,
    required this.fontFamily,
    required this.fontSize,
    required this.labelFontSize,
    required this.paddingHorizontal,
    required this.paddingVertical,
  });

  factory AppzStateStyle.fromJson(Map<String, dynamic> json, AppzStateStyle base) {
    return AppzStateStyle(
      borderColor: _parseColor(json['borderColor'], base.borderColor),
      borderWidth: (json['borderWidth'] ?? base.borderWidth).toDouble(),
      borderRadius: (json['borderRadius'] ?? base.borderRadius).toDouble(),
      backgroundColor: _parseColor(json['backgroundColor'], base.backgroundColor),
      textColor: _parseColor(json['textColor'], base.textColor),
      labelColor: _parseColor(json['labelColor'], base.labelColor),
      fontFamily: json['fontFamily'] ?? base.fontFamily,
      fontSize: (json['fontSize'] ?? base.fontSize).toDouble(),
      labelFontSize: (json['labelFontSize'] ?? base.labelFontSize).toDouble(),
      paddingHorizontal: (json['paddingHorizontal'] ?? base.paddingHorizontal).toDouble(),
      paddingVertical: (json['paddingVertical'] ?? base.paddingVertical).toDouble(),
    );
  }
}

class AppzStyleConfig {
  AppzStyleConfig._privateConstructor();
  static final AppzStyleConfig _instance = AppzStyleConfig._privateConstructor();
  static AppzStyleConfig get instance => _instance;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  late AppzStateStyle _defaultStyle;
  Map<String, Map<String, dynamic>> _rawJsonStyles = {};

  static final AppzStateStyle _fallbackDefaultStyle = AppzStateStyle(
    borderColor: _parseColor("#D9D9D9", Colors.grey),
    borderWidth: 1.0,
    borderRadius: 10.0,
    backgroundColor: _parseColor("#F6F6F6", Colors.grey),
    textColor: _parseColor("#000000", Colors.black),
    labelColor: _parseColor("#333333", Colors.black87),
    fontFamily: "Inter",
    fontSize: 14.0,
    labelFontSize: 12.0,
    paddingHorizontal: 12.0,
    paddingVertical: 10.0,
  );

  Future<void> loadFromResolved(Map<String, dynamic> json) async {
    _rawJsonStyles = Map<String, Map<String, dynamic>>.from(json);
    final defaultJson = _rawJsonStyles['default'];
    _defaultStyle = defaultJson != null
        ? AppzStateStyle.fromJson(defaultJson, _fallbackDefaultStyle)
        : _fallbackDefaultStyle;
    _isInitialized = true;
  }

  AppzStateStyle _getRawStyleForStateName(String stateName) {
    final stateJson = _rawJsonStyles[stateName];
    return stateJson != null ? AppzStateStyle.fromJson(stateJson, _defaultStyle) : _defaultStyle;
  }

  AppzStateStyle getStyleForState(AppzFieldState state, {bool isFilled = false}) {
    if (!_isInitialized) return _fallbackDefaultStyle;
    AppzStateStyle currentStyle;
    switch (state) {
      case AppzFieldState.focused:
        currentStyle = _getRawStyleForStateName('focused');
        break;
      case AppzFieldState.error:
        currentStyle = _getRawStyleForStateName('error');
        break;
      case AppzFieldState.disabled:
        currentStyle = _getRawStyleForStateName('disabled');
        break;
      case AppzFieldState.filled:
        currentStyle = _getRawStyleForStateName('filled');
        break;
      case AppzFieldState.defaultState:
        currentStyle = _defaultStyle;
        break;
      }
    if (isFilled && state != AppzFieldState.filled) {
      final filledJson = _rawJsonStyles['filled'];
      if (filledJson != null) {
        return AppzStateStyle.fromJson(filledJson, currentStyle);
      }
    }
    return currentStyle;
  }
}