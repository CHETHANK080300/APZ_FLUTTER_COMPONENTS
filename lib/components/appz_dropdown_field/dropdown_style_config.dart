
import 'package:flutter/material.dart';

class DropdownStyleConfig {
  static final DropdownStyleConfig instance = DropdownStyleConfig._();
  DropdownStyleConfig._();

  late DropdownStateStyle defaultStyle;
  late DropdownStateStyle focused;
  late DropdownStateStyle error;
  late DropdownStateStyle disabled;
  late DropdownStateStyle filled;
  late HoverStateStyle hover;
  late HoverStateStyle selected;

  Future<void> loadFromResolved(Map<String, dynamic> json) async {
    defaultStyle = DropdownStateStyle.fromJson(json['default']);
    focused = DropdownStateStyle.fromJson(json['focused']);
    error = DropdownStateStyle.fromJson(json['error']);
    disabled = DropdownStateStyle.fromJson(json['disabled']);
    filled = DropdownStateStyle.fromJson(json['filled']);
    hover = HoverStateStyle.fromJson(json['hover']);
    selected = HoverStateStyle.fromJson(json['selected']);
  }
}

class DropdownStateStyle {
  final Color borderColor;
  final double? borderWidth;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? labelColor;
  final String? fontFamily;
  final double? fontSize;
  final double? labelFontSize;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? dropdownMaxHeight;
  final double? elevation;

  DropdownStateStyle({
    required this.borderColor,
    this.borderWidth,
    required this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.labelColor,
    this.fontFamily,
    this.fontSize,
    this.labelFontSize,
    this.paddingHorizontal,
    this.paddingVertical,
    this.dropdownMaxHeight,
    this.elevation,
  });

  factory DropdownStateStyle.fromJson(Map<String, dynamic> json) {
    return DropdownStateStyle(
      borderColor: _parseColor(json['borderColor'] ?? '#D9D9D9'),
      borderWidth: (json['borderWidth'] ?? 1.0).toDouble(),
      borderRadius: (json['borderRadius'] ?? 10).toDouble(),
      backgroundColor: _parseOptionalColor(json['backgroundColor']),
      textColor: _parseOptionalColor(json['textColor']),
      labelColor: _parseOptionalColor(json['labelColor']),
      fontFamily: json['fontFamily'] ?? 'Inter',
      fontSize: (json['fontSize'] ?? 14).toDouble(),
      labelFontSize: (json['labelFontSize'] ?? 12).toDouble(),
      paddingHorizontal: (json['paddingHorizontal'] ?? 12).toDouble(),
      paddingVertical: (json['paddingVertical'] ?? 10).toDouble(),
      dropdownMaxHeight: (json['dropdownMaxHeight'] ?? 220).toDouble(),
      elevation: (json['elevation'] ?? 4).toDouble(),
    );
  }
}

class HoverStateStyle {
  final Color? itemBackgroundColor;
  final Color? textColor;

  HoverStateStyle({
    this.itemBackgroundColor,
    this.textColor,
  });

  factory HoverStateStyle.fromJson(Map<String, dynamic> json) {
    return HoverStateStyle(
      itemBackgroundColor: _parseOptionalColor(json['itemBackgroundColor']),
      textColor: _parseOptionalColor(json['textColor']),
    );
  }
}

Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xff')));
Color? _parseOptionalColor(String? hex) => hex == null ? null : _parseColor(hex);