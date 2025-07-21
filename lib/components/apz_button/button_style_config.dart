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
    final tokenValue = _tokenParser.getValue<Map<String, dynamic>>(['Tokens', 'CSC - Light theme', 'variables', tokenName, 'value']);
    if (tokenValue != null && tokenValue.containsKey('collection') && tokenValue.containsKey('name')) {
      final primitiveColor = _tokenParser.getValue<Map<String, dynamic>>(['Primitive', 'color', 'variables', tokenValue['name'], 'value']);
      if (primitiveColor != null && primitiveColor.containsKey('value')) {
        return _parseColor(primitiveColor['value']);
      }
    }
    final directColor = _tokenParser.getValue<String>(['Tokens', 'CSC - Light theme', 'variables', tokenName, 'value']);
    if (directColor != null) {
      return _parseColor(directColor);
    }
    return Colors.transparent;
  }

  double getDouble(String tokenName) {
    final value = _tokenParser.getValue<num>(['Tokens', 'CSC - Light theme', 'variables', tokenName, 'value']);
    return value?.toDouble() ?? 0.0;
  }

  Map<String, double> getSpacings() {
    final spacingsList = _tokenParser.getValue<List<dynamic>>(['Tokens', 'CSC - Light theme', 'variables'])
        ?.where((v) => v['name'].startsWith('Spacings/'))
        .toList();
    if (spacingsList == null) return {};

    Map<String, double> spacings = {};
    for (var spacingToken in spacingsList) {
      final name = spacingToken['name'].split('/').last;
      final value = spacingToken['value'];
      if (value is num) {
        spacings[name] = value.toDouble();
      }
    }
    return spacings;
  }

  TextStyle getTextStyle(String tokenName) {
    final typography = _tokenParser.getValue<Map<String, dynamic>>(['Typography', 'Style', 'variables', tokenName, 'value']);
    if (typography == null) return TextStyle();

    return TextStyle(
      fontFamily: typography['fontFamily'],
      fontSize: (typography['fontSize'] as num).toDouble(),
      fontWeight: _getFontWeight(typography['fontWeight']),
    );
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
