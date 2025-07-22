import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class ButtonStyleConfig {
  static final ButtonStyleConfig instance = ButtonStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  ButtonStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  Color getColor(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.transparent;

    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection == null) return Colors.transparent;

    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

    if (token == null) return Colors.transparent;

    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection == null) return Colors.transparent;

      final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);

      if (primitiveToken != null) {
        return _parseColor(primitiveToken['value']);
      }
    } else {
      return _parseColor(token['value']);
    }

    return Colors.transparent;
  }

  double? getDouble(String tokenName, {bool fromSupportingTokens = false}) {
    if (fromSupportingTokens) {
      return _tokenParser.getValue<double>(['button', tokenName], fromSupportingTokens: true);
    }
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return 0.0;

    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection == null) return 0.0;

    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

    if (token != null && token['value'] is num) {
      return (token['value'] as num).toDouble();
    }
    return 0.0;
  }

  double getHeight(String size) {
    return _tokenParser.getValue<double>(['button', size, 'height'], fromSupportingTokens: true) ?? 0.0;
  }

  EdgeInsets getPadding(String size) {
    final paddingMap = _tokenParser.getValue<Map<String, dynamic>>(['button', size, 'padding'], fromSupportingTokens: true);
    if (paddingMap != null) {
      return EdgeInsets.symmetric(
        horizontal: (paddingMap['horizontal'] as num).toDouble(),
        vertical: (paddingMap['vertical'] as num).toDouble(),
      );
    }
    return EdgeInsets.zero;
  }

  double getGap(String size) {
    return _tokenParser.getValue<double>(['button', size, 'gap'], fromSupportingTokens: true) ?? 0.0;
  }

  TextStyle getTextStyle(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return TextStyle();

    final typographyCollection = collections.firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
    if (typographyCollection == null) return TextStyle();

    final variables = typographyCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

    if (token != null && token['value'] is Map<String, dynamic>) {
      final typography = token['value'];
      return TextStyle(
        fontFamily: typography['fontFamily'],
        fontSize: (typography['fontSize'] as num).toDouble(),
        fontWeight: _getFontWeight(typography['fontWeight']),
      );
    }

    return TextStyle();
  }

  FontWeight _getFontWeight(String fontWeight) {
    switch (fontWeight) {
      case 'Regular':
        return FontWeight.w400;
      case 'Medium':
        return FontWeight.w500;
      case 'SemiBold':
        return FontWeight.w600;
      case 'Bold':
        return FontWeight.w700;
      default:
        return FontWeight.normal;
    }
  }

  Color _parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
