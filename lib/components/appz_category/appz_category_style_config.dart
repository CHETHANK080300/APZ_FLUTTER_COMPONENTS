import 'package:flutter/material.dart';

class AppzCategoryStyleConfig {
  static final AppzCategoryStyleConfig instance = AppzCategoryStyleConfig._();
  AppzCategoryStyleConfig._();

  late CategoryStateStyle defaultStyle;
  late CategoryStateStyle selectedStyle;

  Future<void> loadFromResolved(Map<String, dynamic> json) async {
    defaultStyle = CategoryStateStyle.fromJson(json['default']);
    selectedStyle = CategoryStateStyle.fromJson(json['selected']);
  }
}

class CategoryStateStyle {
  Color backgroundColor;
  final Color originalBackgroundColor;
  final Color? hoverBackgroundColor;

  final Color labelColor;
  final Color? borderColor;
  final double borderRadius;
  final double elevation;
  final double iconSize;
  final double fontSize;
  final double? itemWidth;
  final double itemSpacing;
  final TextStyle textStyle;

  CategoryStateStyle({
    required this.backgroundColor,
    required this.originalBackgroundColor,
    this.hoverBackgroundColor,
    required this.labelColor,
    this.borderColor,
    required this.borderRadius,
    required this.elevation,
    required this.iconSize,
    required this.fontSize,
    required this.itemWidth,
    required this.itemSpacing,
    required this.textStyle,
  });

  void onHover(bool isHovering) {
    if (isHovering && hoverBackgroundColor != null) {
      backgroundColor = hoverBackgroundColor!;
    } else {
      backgroundColor = originalBackgroundColor;
    }
  }

  factory CategoryStateStyle.fromJson(Map<String, dynamic> json) {
    final bg = _parseColor(json['backgroundColor'] ?? '#FFFFFF');
    final hoverBg = json['hoverBackgroundColor'] != null
        ? _parseColor(json['hoverBackgroundColor'])
        : null;
    final labelColor = _parseColor(json['labelColor'] ?? '#000000');
    final fontSize = (json['fontSize'] ?? 12.0).toDouble();

    return CategoryStateStyle(
      backgroundColor: bg,
      originalBackgroundColor: bg,
      hoverBackgroundColor: hoverBg,
      labelColor: labelColor,
      borderColor: json['borderColor'] != null
          ? _parseColor(json['borderColor'])
          : null,
      borderRadius: (json['borderRadius'] ?? 12).toDouble(),
      elevation: (json['elevation'] ?? 1.0).toDouble(),
      iconSize: (json['iconSize'] ?? 24.0).toDouble(),
      fontSize: fontSize,
      itemWidth: json['itemWidth'] != null
          ? (json['itemWidth'] as num).toDouble()
          : null,
      itemSpacing: (json['itemSpacing'] ?? 12.0).toDouble(),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        fontFamily: json['fontFamily'] ?? 'Outfit',
        color: labelColor,
      ),
    );
  }
}

Color _parseColor(String hex) =>
    Color(int.parse(hex.replaceFirst('#', '0xff')));

/*import 'package:flutter/material.dart';

class AppzCategoryStyleConfig {
  static final AppzCategoryStyleConfig instance = AppzCategoryStyleConfig._();
  AppzCategoryStyleConfig._();

  late CategoryStateStyle defaultStyle;
  late CategoryStateStyle selectedStyle;

  Future<void> loadFromResolved(Map<String, dynamic> json) async {
    defaultStyle = CategoryStateStyle.fromJson(json['default']);
    selectedStyle = CategoryStateStyle.fromJson(json['selected']);
  }
  
}

class CategoryStateStyle {
  final Color backgroundColor;
  final Color labelColor;
  final double borderRadius;
  final double elevation;
  final double iconSize;
  final TextStyle textStyle;

  CategoryStateStyle({
    required this.backgroundColor,
    required this.labelColor,
    required this.borderRadius,
    required this.elevation,
    required this.iconSize,
    required this.textStyle,
  });

  factory CategoryStateStyle.fromJson(Map<String, dynamic> json) {
    return CategoryStateStyle(
      backgroundColor: _parseColor(json['backgroundColor'] ?? '#FFFFFF'),
      labelColor: _parseColor(json['labelColor'] ?? '#000000'),
      borderRadius: (json['borderRadius'] ?? 12).toDouble(),
      elevation: (json['elevation'] ?? 1.0).toDouble(),
      iconSize: (json['iconSize'] ?? 24.0).toDouble(),
      textStyle: TextStyle(
        fontSize: (json['fontSize'] ?? 12.0).toDouble(),
        fontWeight: FontWeight.w500,
        fontFamily: json['fontFamily'] ?? 'Outfit',
        color: _parseColor(json['labelColor'] ?? '#000000'),
      ),
    );
  }
}

Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xff')));*/