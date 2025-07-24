import 'package:flutter/material.dart';
import '../../common/token_parser.dart';

class AppzTextStyleConfig {
  static final AppzTextStyleConfig instance = AppzTextStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  AppzTextStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  TextStyle getTextStyle({
    required String category,
    required String fontWeight,
  }) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return const TextStyle();

    final typographyCollection = collections.firstWhere(
      (c) => c['name'] == 'Typography',
      orElse: () => null,
    );
    if (typographyCollection == null) return const TextStyle();

    final variables = typographyCollection['modes'][0]['variables'] as List<dynamic>;
    final tokenName = _composeTokenName(category, fontWeight);
    final token = variables.firstWhere(
      (v) => v['name'] == tokenName,
      orElse: () => null,
    );
    if (token == null || token['value'] == null) {
      return const TextStyle();
    }
    final typography = token['value'] as Map<String, dynamic>;

    // Map category to color token name
    final colorTokenName = _getColorTokenName(category);
    String? colorHex = colorTokenName != null
        ? _resolveColorToken(colorTokenName)
        : null;
    final textColor = colorHex != null ? _parseColor(colorHex) : Colors.black;
    final textDecoration = _parseTextDecoration(typography['textDecoration']);

    return TextStyle(
      fontFamily: typography['fontFamily'],
      fontSize: (typography['fontSize'] as num?)?.toDouble(),
      fontWeight: _getFontWeight(typography['fontWeight']),
      letterSpacing: (typography['letterSpacing'] as num?)?.toDouble(),
      height: _parseLineHeight(typography['lineHeight']),
      color: textColor,
      decoration: textDecoration,
    );
  }

  String _composeTokenName(String category, String fontWeight) {
    String weight = fontWeight[0].toUpperCase() + fontWeight.substring(1).toLowerCase();
    switch (category.toLowerCase()) {
      case 'title':
        return 'Title Text/$weight';
      case 'subtitle':
        return 'Subtitle/$weight';
      case 'header':
        return 'Header/$weight';
      case 'paragraph':
        return 'Paragraph/$weight';
      case 'body':
        return 'Body/$weight';
      case 'label':
        return weight == 'Label'
            ? 'Label & Helper Text/label'
            : 'Label & Helper Text/$weight';
      case 'input':
        return 'Input/$weight';
      case 'currency':
        return 'Currency/$weight';
      case 'note':
        return 'Note/$weight';
      case 'button':
        return 'Button/$weight';
      case 'hyperlink':
        return 'Hyperlink/$weight';
      case 'tooltip':
        return 'Tooltip/$weight';
      case 'tableheader':
      case 'table_header':
      case 'table-header':
        return 'Table Header/$weight';
      case 'tablecontent':
      case 'table_content':
      case 'table-content':
        return 'Table content/$weight';
      case 'chips':
        return 'Chips/$weight';
      case 'menuitem':
      case 'menu_item':
      case 'menu-item':
        return 'Menu Item/$weight';
      case 'subheader':
        return 'Subheader/Subheader';
      default:
        String titleCase = category.split(RegExp(r'[_\-\s]+')).map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
        return '$titleCase/$weight';
    }
  }

  TextDecoration? _parseTextDecoration(dynamic decoration) {
    if (decoration == null) return null;
    switch (decoration.toString().toLowerCase()) {
      case 'underline':
        return TextDecoration.underline;
      case 'line-through':
        return TextDecoration.lineThrough;
      case 'overline':
        return TextDecoration.overline;
      case 'none':
      default:
        return TextDecoration.none;
    }
  }

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

  double? _parseLineHeight(dynamic lineHeight) {
    if (lineHeight == null || lineHeight == 'auto') return null;
    if (lineHeight is num) return lineHeight.toDouble();
    return null;
  }

  Color _parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  /// Maps a text category to its color token name in token_variables.json
  String? _getColorTokenName(String category) {
    switch (category.toLowerCase()) {
      case 'title':
        return 'Text colour/Title Text/Default';
      case 'subtitle':
        return 'Text colour/Subtitle/Default';
      case 'header':
        return 'Text colour/Header/Default';
      case 'paragraph':
        return 'Text colour/Paragraph/Style 1';
      case 'body':
        return 'Text colour/Body/Style 1';
      case 'label':
        return 'Text colour/Label & Help/Default';
      case 'input':
        return 'Text colour/Input/Default';
      case 'currency':
        return 'Text colour/Currency/Default';
      case 'note':
        return 'Text colour/Note/Default';
      case 'button':
        return 'Text colour/Button/Default';
      case 'hyperlink':
        return 'Text colour/Hyperlink/Default';
      case 'tooltip':
        return 'Text colour/Tooltip/Style 1';
      case 'tableheader':
      case 'table_header':
      case 'table-header':
        return 'Text colour/Table Header/Default';
      case 'tablecontent':
      case 'table_content':
      case 'table-content':
        return 'Text colour/Table Content/Style 1';
      case 'chips':
        return 'Text colour/Chips/Default';
      case 'menuitem':
      case 'menu_item':
      case 'menu-item':
        return 'Text colour/Menu Item/Default';
      case 'subheader':
        return 'Text colour/Subtitle/Default'; // fallback
      default:
        return null;
    }
  }

  /// Resolves a color token by name from token_variables.json, including alias resolution, searching all collections.
  String? _resolveColorToken(String colorTokenName, {String mode = 'CSC - Light theme'}) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return null;

    // Helper to search for a color token by name in all collections and modes
    String? findColorToken(String name) {
      for (final collection in collections) {
        final modes = collection['modes'] as List<dynamic>?;
        if (modes == null) continue;
        for (final modeObj in modes) {
          // If mode is specified, prefer that mode, else search all
          if (modeObj['name'] != mode && collection['name'] == 'Tokens') continue;
          final variables = modeObj['variables'] as List<dynamic>?;
          if (variables == null) continue;
          for (final v in variables) {
            if (v['type'] == 'color' && v['name'] == name) {
              final value = v['value'];
              if (value is String) return value;
              if (value is Map && value.containsKey('name')) {
                // Recursively resolve alias
                return findColorToken(value['name']);
              }
            }
          }
        }
      }
      return null;
    }

    return findColorToken(colorTokenName);
  }
} 