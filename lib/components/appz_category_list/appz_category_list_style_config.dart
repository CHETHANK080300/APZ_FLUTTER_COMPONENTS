import 'package:flutter/material.dart';
import 'package:apz_flutter_components/common/token_parser.dart';

class AppzCategoryListStyleConfig {
  static final AppzCategoryListStyleConfig instance = AppzCategoryListStyleConfig._();
  AppzCategoryListStyleConfig._();

  late CategoryListStateStyle defaultStyle;
  final TokenParser _tokenParser = TokenParser();

  Future<void> load() async {
    await _tokenParser.loadTokens();
    // Try to get config from supporting tokens, fallback to hardcoded if not found
    final config = _tokenParser.getValue<Map<String, dynamic>>(
      ['categoryList'],
      fromSupportingTokens: true,
    );
    defaultStyle = await _resolveStateStyle(config ?? {});
  }

  Future<CategoryListStateStyle> _resolveStateStyle(Map<String, dynamic> json) async {
    // Token names
    const backgroundColorToken = "Surface/Colour 1";
    const selectedBackgroundColorToken = "Surface/Colour 2";
    const dividerColorToken = "Outline/Default";
    const titleColorToken = "Text colour/Title Text/Default";
    const subtitleColorToken = "Text colour/Subtitle/Default";
    const iconColorToken = "Icon/Default";
    const iconSelectedColorToken = "Icon/Highlight";
    const bookmarkColorToken = "Icon/Highlight";
    const fontSizeToken = "Input/Medium";
    const fontFamilyToken = "Input/Medium";
    const fontWeightToken = "Medium";
    const paddingToken = "Spacings/medium";
    const iconSizeToken = "Spacings/large";

    // Master token helpers
    Color? _resolveColorFromTokens(String token) {
      final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return null;
      final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
      if (tokenCollection != null) {
        final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
        final t = variables.firstWhere((v) => v['name'] == token, orElse: () => null);
        if (t != null) {
          if (t['isAlias'] == true) {
            final alias = t['value']['name'];
            final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
            if (primitiveCollection != null) {
              final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
              final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);
              if (primitiveToken != null) {
                return _parseColor(primitiveToken['value']);
              }
            }
          } else {
            return _parseColor(t['value']);
          }
        }
      }
      // Try Primitive collection directly
      final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection != null) {
        final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
        final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == token, orElse: () => null);
        if (primitiveToken != null) {
          return _parseColor(primitiveToken['value']);
        }
      }
      // If not found, try parsing as hex
      if (token.startsWith('#')) {
        return _parseColor(token);
      }
      return null;
    }

    double? _resolveDoubleFromTokens(String token) {
      final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return null;
      final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
      if (tokenCollection != null) {
        final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
        final t = variables.firstWhere((v) => v['name'] == token, orElse: () => null);
        if (t != null && t['value'] is num) {
          return (t['value'] as num).toDouble();
        }
      }
      return null;
    }

    // Helper to fetch from master tokens, then supporting tokens if not found
    T? resolveToken<T>(String tokenName, {String? supportingKey}) {
      // Try master tokens
      final masterValue = _tokenParser.getValue<T>(['collections', 0, 'modes', 0, 'variables'], fromSupportingTokens: false);
      if (masterValue != null) return masterValue;
      // Try supporting tokens
      if (supportingKey != null) {
        final supportValue = _tokenParser.getValue<T>(['categoryList', 'default', supportingKey], fromSupportingTokens: true);
        if (supportValue != null) return supportValue;
      }
      return null;
    }

    Color? resolveColor(String token, {String? supportingKey}) {
      // Try master tokens
      final color = _resolveColorFromTokens(token);
      if (color != null) return color;
      // Try supporting tokens
      if (supportingKey != null) {
        final supportValue = _tokenParser.getValue<dynamic>(['categoryList', 'default', supportingKey], fromSupportingTokens: true);
        if (supportValue is String) return _parseColor(supportValue);
      }
      return null;
    }

    double resolveDouble(String token, {String? supportingKey}) {
      // Try master tokens
      final value = _resolveDoubleFromTokens(token);
      if (value != null) return value;
      // Try supporting tokens
      if (supportingKey != null) {
        final supportValue = _tokenParser.getValue<dynamic>(['categoryList', 'default', supportingKey], fromSupportingTokens: true);
        if (supportValue is num) return supportValue.toDouble();
      }
      return 0.0;
    }

    double resolveFontSize(String token) {
      final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return 14.0;
      final typographyCollection = collections.firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
      if (typographyCollection == null) return 14.0;
      final variables = typographyCollection['modes'][0]['variables'] as List<dynamic>;
      final matches = variables.where((v) => v['name'] == token && v['value'] != null && v['value']['fontSize'] != null);
      if (matches.isNotEmpty) {
        return (matches.first['value']['fontSize'] as num).toDouble();
      }
      return 14.0;
    }

    // Colors
    final backgroundColor = resolveColor(backgroundColorToken) ?? Colors.white;
    final selectedBackgroundColor = resolveColor(selectedBackgroundColorToken) ?? Colors.blue.shade50;
    final dividerColor = resolveColor(dividerColorToken) ?? Colors.grey.shade200;
    final titleColor = resolveColor(titleColorToken) ?? Colors.black87;
    final subtitleColor = resolveColor(subtitleColorToken) ?? Colors.black54;
    final iconColor = resolveColor(iconColorToken) ?? Colors.grey.shade700;
    final iconSelectedColor = resolveColor(iconSelectedColorToken) ?? Colors.blue;
    final bookmarkColor = resolveColor(bookmarkColorToken) ?? Colors.blue;

    // Debug print for color values
    print('DEBUG: backgroundColor= [36m$backgroundColor [0m, titleColor= [33m$titleColor [0m, subtitleColor=$subtitleColor');

    // Typography
    final fontSize = resolveFontSize(fontSizeToken);
    print('DEBUG: fontSize=$fontSize');
    final fontFamily = 'Outfit'; // fallback, can be resolved from typography if needed
    final fontWeight = FontWeight.w500; // fallback, can be resolved from typography if needed

    // Spacing & Sizing
    final padding = resolveDouble(paddingToken, supportingKey: 'padding') ?? 12.0;
    final iconSize = resolveDouble(iconSizeToken, supportingKey: 'iconSize') ?? 32.0;
    final borderRadius = resolveDouble('borderRadius', supportingKey: 'borderRadius') ?? 16.0;
    final cardHeight = resolveDouble('cardHeight', supportingKey: 'cardHeight') ?? 64.0;
    final dividerHeight = resolveDouble('dividerHeight', supportingKey: 'dividerHeight') ?? 1.0;

    // BoxShadow
    List<BoxShadow> boxShadow = [];
    final boxShadowList = _tokenParser.getValue<List<dynamic>>(['categoryList', 'default', 'boxShadow'], fromSupportingTokens: true);
    if (boxShadowList != null) {
      boxShadow = boxShadowList.map<BoxShadow>((e) {
        final color = e['color'] != null ? _parseColor(e['color']) : Colors.black12;
        final blur = (e['blurRadius'] ?? 2.0).toDouble();
        return BoxShadow(color: color, blurRadius: blur);
      }).toList();
    }

    return CategoryListStateStyle(
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      dividerColor: dividerColor,
      titleColor: titleColor,
      subtitleColor: subtitleColor,
      iconColor: iconColor,
      iconSelectedColor: iconSelectedColor,
      bookmarkColor: bookmarkColor,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      padding: padding,
      iconSize: iconSize,
      borderRadius: borderRadius,
      cardHeight: cardHeight,
      dividerHeight: dividerHeight,
      boxShadow: boxShadow,
    );
  }

  Color _parseColor(dynamic value) {
    if (value is String && value.startsWith('#')) {
      String hex = value.substring(1);
      if (hex.length == 6) {
        hex = 'FF$hex'; // Add opaque alpha if not present
      }
      return Color(int.parse(hex, radix: 16));
    }
    return Colors.black;
  }
}

class CategoryListStateStyle {
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color dividerColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color iconColor;
  final Color iconSelectedColor;
  final Color bookmarkColor;
  final double fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final double padding;
  final double iconSize;
  final double borderRadius;
  final double cardHeight;
  final double dividerHeight;
  final List<BoxShadow> boxShadow;

  CategoryListStateStyle({
    required this.backgroundColor,
    required this.selectedBackgroundColor,
    required this.dividerColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.iconColor,
    required this.iconSelectedColor,
    required this.bookmarkColor,
    required this.fontSize,
    required this.fontFamily,
    required this.fontWeight,
    required this.padding,
    required this.iconSize,
    required this.borderRadius,
    required this.cardHeight,
    required this.dividerHeight,
    required this.boxShadow,
  });
} 