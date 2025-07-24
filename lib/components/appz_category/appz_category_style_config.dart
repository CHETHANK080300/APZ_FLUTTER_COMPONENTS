import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class AppzCategoryStyleConfig {
  static final AppzCategoryStyleConfig instance = AppzCategoryStyleConfig._();
  AppzCategoryStyleConfig._();

  late CategoryStateStyle defaultStyle;
  final TokenParser _tokenParser = TokenParser();

  Future<void> load() async {
    await _tokenParser.loadTokens();
    final categoryConfig = _tokenParser.getValue<Map<String, dynamic>>(
        ['category'],
        fromSupportingTokens: true);
    if (categoryConfig != null) {
      defaultStyle = await _resolveStateStyle(categoryConfig['default']);
    }
  }

  Future<CategoryStateStyle> _resolveStateStyle(
      Map<String, dynamic> json) async {
    const backgroundColorToken = "Surface/Colour 1";
    const hoverBackgroundColorToken = "Grey colors/grey-50";
    const labelColorToken = "Grey colors/grey-500";
    const fontSizeToken = "Input/Medium";

    Color? resolveColor(String? token) {
      if (token == null) return null;
      final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return null;
      // Try Tokens collection
      final tokenCollection = collections
          .firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
      if (tokenCollection != null) {
        final variables =
            tokenCollection['modes'][0]['variables'] as List<dynamic>;
        final t =
            variables.firstWhere((v) => v['name'] == token, orElse: () => null);
        if (t != null) {
          if (t['isAlias'] == true) {
            final alias = t['value']['name'];
            final primitiveCollection = collections.firstWhere(
                (c) => c['name'] == 'Primitive',
                orElse: () => null);
            if (primitiveCollection != null) {
              final primitiveVariables =
                  primitiveCollection['modes'][0]['variables'] as List<dynamic>;
              final primitiveToken = primitiveVariables
                  .firstWhere((v) => v['name'] == alias, orElse: () => null);
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
      final primitiveCollection = collections
          .firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection != null) {
        final primitiveVariables =
            primitiveCollection['modes'][0]['variables'] as List<dynamic>;
        final primitiveToken = primitiveVariables
            .firstWhere((v) => v['name'] == token, orElse: () => null);
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

    double resolveFontSize(dynamic value) {
      final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return 12.0;
      final typographyCollection = collections
          .firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
      if (typographyCollection == null) return 12.0;
      final variables =
          typographyCollection['modes'][0]['variables'] as List<dynamic>;
      final token = variables.firstWhere((v) => v['name'] == fontSizeToken,
          orElse: () => null);
      if (token != null && token['value'] is Map<String, dynamic>) {
        final typography = token['value'];
        return (typography['fontSize'] as num).toDouble();
      }
      return 12.0;
    }

    List<BoxShadow> resolveBoxShadowList(dynamic jsonList) {
      if (jsonList == null || jsonList is! List) return [];
      return jsonList.map<BoxShadow>((e) {
        final color = resolveColor(e['color']) ?? Colors.black12;
        double blur =
            e['blurRadius'] is String && e['blurRadius'] == 'elevation'
                ? (json['elevation'] ?? 2.0).toDouble()
                : (e['blurRadius'] ?? 0.0).toDouble();
        return BoxShadow(
          color: color,
          blurRadius: blur,
          offset: Offset(
            (e['offsetX'] ?? 0.0).toDouble(),
            (e['offsetY'] ?? 0.0).toDouble(),
          ),
          spreadRadius: (e['spreadRadius'] ?? 0.0).toDouble(),
        );
      }).toList();
    }

    final bg = resolveColor(backgroundColorToken) ?? Colors.white;
    final hoverBg = resolveColor(hoverBackgroundColorToken);
    final labelColor = resolveColor(labelColorToken) ?? Colors.black;
    final fontSize = resolveFontSize(null);
    final cardHeight = (json['cardHeight'] ?? 86.0).toDouble();
    final padding = (json['padding'] ?? 16.0).toDouble();
    final spacing = (json['spacing'] ?? 8.0).toDouble();

    // Fetch typography details from Input/Medium token
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    Map<String, dynamic>? typography;
    if (collections != null) {
      final typographyCollection = collections.firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
      if (typographyCollection != null) {
        final variables = typographyCollection['modes'][0]['variables'] as List<dynamic>;
        final token = variables.firstWhere((v) => v['name'] == fontSizeToken, orElse: () => null);
        if (token != null && token['value'] is Map<String, dynamic>) {
          typography = token['value'] as Map<String, dynamic>;
        }
      }
    }
    final resolvedFontFamily = typography != null ? typography['fontFamily'] as String? ?? 'Outfit' : 'Outfit';
    final resolvedFontWeight = typography != null ? _getFontWeight(typography['fontWeight'] as String? ?? 'Medium') : FontWeight.w500;

    return CategoryStateStyle(
      backgroundColor: bg,
      originalBackgroundColor: bg,
      hoverBackgroundColor: hoverBg,
      labelColor: labelColor,
      borderColor: null,
      borderRadius: (json['borderRadius'] ?? 16.0).toDouble(),
      elevation: (json['elevation'] ?? 1.0).toDouble(),
      iconSize: (json['iconSize'] ?? 32.0).toDouble(),
      fontSize: fontSize,
      cardHeight: cardHeight,
      padding: padding,
      spacing: spacing,
      itemSpacing: (json['itemSpacing'] ?? 12.0).toDouble(),
      fontFamily: resolvedFontFamily,
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: resolvedFontWeight,
        fontFamily: resolvedFontFamily,
        color: labelColor,
      ),
      boxShadowHorizontal: resolveBoxShadowList(json['boxShadowHorizontal']),
      boxShadowVertical: resolveBoxShadowList(json['boxShadowVertical']),
      itemWidth: (json['itemWidth'] ?? 100.0).toDouble(),
    );
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
  final double cardHeight;
  final double padding;
  final double spacing;
  final double itemSpacing; // keep for margin
  final double itemWidth;
  final String fontFamily;
  final TextStyle textStyle;
  final List<BoxShadow> boxShadowHorizontal;
  final List<BoxShadow> boxShadowVertical;

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
    required this.cardHeight,
    required this.padding,
    required this.spacing,
    required this.itemSpacing,
    required this.fontFamily,
    required this.textStyle,
    required this.boxShadowHorizontal,
    required this.boxShadowVertical,
    required this.itemWidth,
  });

  void onHover(bool isHovering) {
    if (isHovering && hoverBackgroundColor != null) {
      backgroundColor = hoverBackgroundColor!;
    } else {
      backgroundColor = originalBackgroundColor;
    }
  }
}

Color _parseColor(String hex) =>
    Color(int.parse(hex.replaceFirst('#', '0xff')));

FontWeight _getFontWeight(String fontWeight) {
  switch (fontWeight.toLowerCase()) {
    case 'regular':
      return FontWeight.w400;
    case 'medium':
      return FontWeight.w500;
    case 'semibold':
      return FontWeight.w600;
    case 'bold':
      return FontWeight.w700;
    default:
      return FontWeight.normal;
  }
}
