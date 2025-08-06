import 'package:flutter/material.dart';
import '../../common/token_parser.dart';
import 'appz_tags.dart';

class TagsStyleConfig {
  static final TagsStyleConfig instance = TagsStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();

  TagsStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
    final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['tags'], fromSupportingTokens: true);
    _config = supportingConfig;
  }

  bool get isInitialized => _config != null;

  Map<String, double> get sizes {
    if (_config == null) {
      throw Exception('TagsStyleConfig not initialized. Call load() first.');
    }
    final sizesMap = _config!['sizes'] as Map<String, dynamic>;
    return sizesMap.map((k, v) => (v is num) ? MapEntry(k, (v as num).toDouble()) : MapEntry(k, double.tryParse(v.toString())!));
  }

  double size(String key) {
    final sizesMap = sizes;
    if (!sizesMap.containsKey(key)) {
      throw Exception('TagsStyleConfig: size key "' + key + '" not found in config.');
    }
    return sizesMap[key]!;
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

  Color getBackgroundColor() {
    return getColor('Tags/Default');
  }

  Color getTextColor() {
    return getColor('Text colour/Input/Active');
  }

  Color getIconColor() {
    return getColor('Icon/Default');
  }

  Color _parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
} 