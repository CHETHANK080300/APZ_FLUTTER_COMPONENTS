import 'package:flutter/material.dart';
import '../../common/token_parser.dart';

class FooterStyleConfig {
  static final FooterStyleConfig instance = FooterStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();
  bool _isLoaded = false;

  FooterStyleConfig._internal();

  Future<void> load() async {
    try {
      await _tokenParser.loadTokens();
      final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['footer'], fromSupportingTokens: true);
      _config = supportingConfig;
      _isLoaded = true;
    } catch (e) {
      _isLoaded = false;
    }
  }

  bool get isInitialized => _config != null && _isLoaded;

  Map<String, double> get sizes {
    if (_config == null || !_isLoaded) {
      throw Exception('FooterStyleConfig not initialized. Call load() first.');
    }
    final sizesMap = _config!['sizes'] as Map<String, dynamic>;
    return sizesMap.map((k, v) => (v is num) ? MapEntry(k, (v as num).toDouble()) : MapEntry(k, double.tryParse(v.toString()) ?? 0));
  }

  double size(String key) {
    if (_config == null || !_isLoaded) {
      throw Exception('FooterStyleConfig not initialized. Call load() first.');
    }
    final sizesMap = _config!['sizes'] as Map<String, dynamic>;
    if (!sizesMap.containsKey(key)) {
      throw Exception('FooterStyleConfig: size key "$key" not found in config.');
    }
    final value = sizesMap[key];
    return value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0;
  }

  static Color parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  // Footer-specific size getters
  double getWidth() => size('width');
  double getPadding() => size('padding');
  double getBorderRadius() => size('borderRadius');
  double getBorderWidth() => size('borderWidth');
  double getButtonContainerPadding() => size('buttonContainerPadding');
  double getButtonSpacing() => size('buttonSpacing');

  // Footer-specific color getters
  Color getBackgroundColor() => getColor('Surface/Colour/1');
  Color getBorderColor() => getColor('Form/Fields/Input/Outline/default');
  Color getPrimaryButtonColor() => getColor('Button/Primary/Default');
  Color getSecondaryButtonColor() => getColor('Button/Secondary/Default');
  Color getSecondaryButtonBorderColor() => getColor('Button/Secondary/Default/outline');
  Color getPrimaryButtonTextColor() => getColor('Text/colour/Button/Default');
  Color getSecondaryButtonTextColor() => getColor('Text/colour/Button/Clicked');

  Color getColor(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.transparent;

    // First try to find the token directly in the Primitive collection
    final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
    if (primitiveCollection != null) {
      final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);
      
      if (primitiveToken != null) {
        return parseColor(primitiveToken['value']);
      }
    }

    // If not found in Primitive, try the Tokens collection (for aliases)
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection == null) return Colors.transparent;

    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

    if (token == null) return Colors.transparent;

    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      
      if (primitiveCollection != null) {
        final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
        final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);

        if (primitiveToken != null) {
          return parseColor(primitiveToken['value']);
        }
      }
    } else {
      return parseColor(token['value']);
    }

    return Colors.transparent;
  }
} 