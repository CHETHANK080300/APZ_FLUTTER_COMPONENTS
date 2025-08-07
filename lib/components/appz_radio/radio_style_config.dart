/*import 'package:apz_flutter_components/common/token_parser.dart';
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
}*/
import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class RadioStyleConfig {
  static final RadioStyleConfig instance = RadioStyleConfig._();
  RadioStyleConfig._();

  bool isInitialized = false;

  late double outerRadius;
  late double innerRadius;
  late double borderWidth;
  late double spacing;
  late TextStyle labelStyle;
  late TextStyle optionStyle;
  late TextStyle errorTextStyle;
  late Color mandatoryAsteriskColor;

  late RadioStateStyle selected;
  late RadioStateStyle unselected;
  late RadioStateStyle disabled;

  Future<void> load() async {
    if (isInitialized) return;

    final tokenParser = TokenParser();
    await tokenParser.loadTokens();

    outerRadius = tokenParser.getValue<double>(['radio', 'outerRadius'], fromSupportingTokens: true) ?? 10.0;
    innerRadius = tokenParser.getValue<double>(['radio', 'innerRadius'], fromSupportingTokens: true) ?? 5.0;
    borderWidth = tokenParser.getValue<double>(['radio', 'borderWidth'], fromSupportingTokens: true) ?? 1.5;
    spacing = tokenParser.getValue<double>(['radio', 'spacing'], fromSupportingTokens: true) ?? 10.0;

    selected = RadioStateStyle.fromTokens(tokenParser, 'selected');
    unselected = RadioStateStyle.fromTokens(tokenParser, 'unselected');
    disabled = RadioStateStyle.fromTokens(tokenParser, 'disabled');
    
    labelStyle = selected.labelStyle;
    optionStyle = selected.optionStyle;
    errorTextStyle = selected.optionStyle.copyWith(color: selected.errorColor, fontSize: 12);
    mandatoryAsteriskColor = selected.errorColor;

    isInitialized = true;
  }
}

class RadioStateStyle {
  final Color borderColor;
  final Color innerColor;
  final Color labelColor;
  final Color textColor;
  final Color errorColor;
  final String fontFamily;
  final double labelFontSize;
  final double optionFontSize;
  final TextStyle labelStyle;
  final TextStyle optionStyle;

  RadioStateStyle({
    required this.borderColor,
    required this.innerColor,
    required this.labelColor,
    required this.textColor,
    required this.errorColor,
    required this.fontFamily,
    required this.labelFontSize,
    required this.optionFontSize,
    required this.labelStyle,
    required this.optionStyle,
  });

  factory RadioStateStyle.fromTokens(TokenParser parser, String state) {
    Color getPropertyColor(String propertyName) {
      final collections = parser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return Colors.transparent;

      final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
      if (tokenCollection == null) return Colors.transparent;

      final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
      final token = variables.firstWhere((v) => v['name'] == propertyName, orElse: () => null);

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
        final value = token['value'];
        if (value is String) {
          return _parseColor(value);
        }
      }

      return Colors.transparent;
    }

    String getTypography(String tokenName) {
      final collections = parser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return 'Outfit';

      final typographyCollection = collections.firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
      if (typographyCollection == null) return 'Outfit';

      final variables = typographyCollection['modes'][0]['variables'] as List<dynamic>;
      final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

      if (token != null && token['value'] is Map<String, dynamic>) {
        final typography = token['value'];
        return typography['fontFamily'];
      }

      return 'Outfit';
    }

    Color borderColor;
    Color innerColor;
    Color textColor;

    switch (state) {
      case 'selected':
        borderColor = getPropertyColor('Form Fields/Selections/Active');
        innerColor = getPropertyColor('Form Fields/Selections/Active');
        textColor = getPropertyColor('Text colour/Input/Active');
        break;
      case 'disabled':
        borderColor = getPropertyColor('Form Fields/Selections/Disabled');
        innerColor = getPropertyColor('Form Fields/Selections/Disabled');
        textColor = getPropertyColor('Text colour/Input/Disabled');
        break;
      default: // unselected
        borderColor = getPropertyColor('Form Fields/Selections/Inactive');
        innerColor = Colors.transparent;
        textColor = getPropertyColor('Text colour/Input/Default');
    }

    final labelColor = getPropertyColor('Text colour/Label & Help/Default');
    final errorColor = getPropertyColor('Form Fields/Input/Outline error');
    final fontFamily = getTypography('Input/Regular');
    final labelFontSize = parser.getValue<double>(['radio', 'labelFontSize'], fromSupportingTokens: true) ?? 14.0;
    final optionFontSize = parser.getValue<double>(['radio', 'optionFontSize'], fromSupportingTokens: true) ?? 14.0;
    
    return RadioStateStyle(
      borderColor: borderColor,
      innerColor: innerColor,
      labelColor: labelColor,
      textColor: textColor,
      errorColor: errorColor,
      fontFamily: fontFamily,
      labelFontSize: labelFontSize,
      optionFontSize: optionFontSize,
      labelStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: labelFontSize,
        color: labelColor,
        fontWeight: FontWeight.w500,
      ),
      optionStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: optionFontSize,
        color: textColor,
      ),
    );
  }
}

Color _parseColor(String? hex) {
  if (hex == null) return Colors.transparent;
  if (hex == 'transparent') return Colors.transparent;
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.tryParse(hex, radix: 16) ?? 0);
}