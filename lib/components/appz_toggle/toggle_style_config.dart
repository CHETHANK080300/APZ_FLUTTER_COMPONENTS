import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class ToggleStyleConfig {
  static final ToggleStyleConfig instance = ToggleStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  ToggleStyleConfig._internal();

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

  double getDouble(String key, String size) {
    return _tokenParser.getValue<double>(['toggleSwitch', size, key], fromSupportingTokens: true) ?? 0.0;
  }

  double getSpacing(String size) {
    return _tokenParser.getValue<double>(['toggleSwitch', 'spacing', size], fromSupportingTokens: true) ?? 8.0;
  }

  Color _parseColor(String hex) {
    if (hex == null || hex is! String) return Colors.transparent;
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.tryParse(hex, radix: 16) ?? 0);
  }

  TextStyle getTextStyle(String size, Color color) {
    final fontFamily = _tokenParser.getValue<String>(['toggleSwitch', 'text', 'fontFamily'], fromSupportingTokens: true) ?? '';
    final fontSize = getDouble('thumbSize', size); // Use thumbSize as fontSize for demo, adjust as needed
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }
} 