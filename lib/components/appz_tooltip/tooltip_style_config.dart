import 'package:flutter/material.dart';
import '../../common/token_parser.dart';

class TooltipStyleConfig {
  static final TooltipStyleConfig instance = TooltipStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();

  TooltipStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
    final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['tooltip'], fromSupportingTokens: true);
    _config = supportingConfig;
  }

  bool get isInitialized => _config != null;

  // Color keys to resolve from token_variables.json
  static const Map<String, String> _colorTokenMap = {
    'backgroundColor': 'Form Fields/Tooltip/Default',
    'outlineColor': 'Form Fields/Tooltip/Outline',
  };

  Color color(String key) {
    if (!_colorTokenMap.containsKey(key)) {
      throw Exception('TooltipStyleConfig: color key "' + key + '" not found in color token map.');
    }
    final tokenName = _colorTokenMap[key]!;
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
        return parseColor(primitiveToken['value']);
      }
    } else {
      return parseColor(token['value']);
    }
    return Colors.transparent;
  }

  double get borderRadius {
    if (_config == null) {
      throw Exception('TooltipStyleConfig not initialized. Call load() first.');
    }
    return (_config!['borderRadius'] as num).toDouble();
  }

  double? get outerBorderRadius {
    if (_config == null) {
      throw Exception('TooltipStyleConfig not initialized. Call load() first.');
    }
    return _config!['outerBorderRadius'] != null ? (_config!['outerBorderRadius'] as num).toDouble() : null;
  }

  String getFontFamily(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return 'Outfit';
    final typographyCollection = collections.firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
    if (typographyCollection == null) return 'Outfit';
    final variables = typographyCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);
    if (token != null && token['value'] is Map<String, dynamic>) {
      return token['value']['fontFamily'] ?? 'Outfit';
    }
    return 'Outfit';
  }

  Map<String, double> get sizes {
    if (_config == null) {
      throw Exception('TooltipStyleConfig not initialized. Call load() first.');
    }
    final sizesMap = _config!['sizes'] as Map<String, dynamic>;
    return sizesMap.map((k, v) => (v is num) ? MapEntry(k, (v as num).toDouble()) : MapEntry(k, double.tryParse(v.toString()) ?? 0));
  }

  double size(String key) {
    final sizesMap = sizes;
    if (!sizesMap.containsKey(key)) {
      throw Exception('TooltipStyleConfig: size key "' + key + '" not found in config.');
    }
    return sizesMap[key]!;
  }

  List<dynamic>? get boxShadow {
    if (_config == null) {
      throw Exception('TooltipStyleConfig not initialized. Call load() first.');
    }
    return _config!['boxShadow'] as List<dynamic>?;
  }

  static Color parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  double getOuterBorderRadius() => outerBorderRadius ?? borderRadius;
} 