import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class RadioStyleConfig {
  static final RadioStyleConfig instance = RadioStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  RadioStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  Color getColor(String tokenName) {
    // Map state tokens for radio
    if (tokenName == 'selected_borderColor' || tokenName == 'selected_innerColor' || tokenName == 'selected_outerColor') {
      tokenName = 'Form Fields/Selections/Active';
    } else if (tokenName == 'unselected_borderColor' || tokenName == 'unselected_innerColor' || tokenName == 'unselected_outerColor') {
      tokenName = 'Form Fields/Selections/Inactive';
    }
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
    return _tokenParser.getValue<double>(['radio', size, key], fromSupportingTokens: true) ?? 0.0;
  }

  double getSpacing(String size) {
    return _tokenParser.getValue<double>(['radio', 'spacing', size], fromSupportingTokens: true) ?? 8.0;
  }

  Color _parseColor(String hex) {
    if (hex == null || hex is! String) return Colors.transparent;
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.tryParse(hex, radix: 16) ?? 0);
  }

  TextStyle getTextStyle(String type, String size, bool disabled) {
    final fontFamily = _tokenParser.getValue<String>(['radio', 'text', 'fontFamily'], fromSupportingTokens: true) ?? '';
    final fontSize = getDouble('outerRadius', size); // Use outerRadius as fontSize for demo, adjust as needed
    final colorToken = _tokenParser.getValue<String>(['radio', 'text', 'colors', disabled ? 'disabled' : 'default'], fromSupportingTokens: true);
    final color = colorToken != null ? getColor(colorToken) : Colors.black;
    final weight = type == 'title' ? FontWeight.w500 : FontWeight.w400;
    final sizeAdjust = type == 'subtitle' ? -2.0 : 0.0;
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize + sizeAdjust,
      color: color,
      fontWeight: weight,
    );
  }
} 