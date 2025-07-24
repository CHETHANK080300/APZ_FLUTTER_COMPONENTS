import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class AppzSearchBarStyleConfig {
  static final AppzSearchBarStyleConfig instance =
      AppzSearchBarStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  AppzSearchBarStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  double getHeight(String variant) =>
      _tokenParser.getValue<double>(['searchBar', variant, 'height'],
          fromSupportingTokens: true) ??
      40.0;

  double getBorderRadius(String variant) =>
      _tokenParser.getValue<double>(['searchBar', variant, 'borderRadius'],
          fromSupportingTokens: true) ??
      12.0;

  double getIconSize(String variant) =>
      _tokenParser.getValue<double>(['searchBar', variant, 'iconSize'],
          fromSupportingTokens: true) ??
      20.0;

  double getPaddingHorizontal(String variant) =>
      _tokenParser.getValue<double>(['searchBar', variant, 'paddingHorizontal'],
          fromSupportingTokens: true) ??
      16.0;

  /// Returns the text color for the enabled state (Text colour/Input/Default)
  Color getTextColor() {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.black;
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens',
        orElse: () => null);
    if (tokenCollection == null) return Colors.black;
    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere(
        (v) => v['name'] == 'Text colour/Input/Default',
        orElse: () => null);
    if (token == null) return Colors.black;
    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections
          .firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection == null) return Colors.black;
      final primitiveVariables =
          primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables
          .firstWhere((v) => v['name'] == alias, orElse: () => null);
      if (primitiveToken != null) {
        return _parseColor(primitiveToken['value']);
      }
    } else {
      return _parseColor(token['value']);
    }
    return Colors.black;
  }

  /// Returns the text color for the hovered state (Text colour/Input/Active)
  Color getHoveredTextColor() {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.black;
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens',
        orElse: () => null);
    if (tokenCollection == null) return Colors.black;
    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere(
        (v) => v['name'] == 'Text colour/Input/Active',
        orElse: () => null);
    if (token == null) return Colors.black;
    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections
          .firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection == null) return Colors.black;
      final primitiveVariables =
          primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables
          .firstWhere((v) => v['name'] == alias, orElse: () => null);
      if (primitiveToken != null) {
        return _parseColor(primitiveToken['value']);
      }
    } else {
      return _parseColor(token['value']);
    }
    return Colors.black;
  }

  Color getBorderColor() {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.grey;
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens',
        orElse: () => null);
    if (tokenCollection == null) return Colors.grey;
    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere(
        (v) => v['name'] == 'Form Fields/Search/Search outline',
        orElse: () => null);
    if (token == null) return Colors.grey;
    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections
          .firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection == null) return Colors.grey;
      final primitiveVariables =
          primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables
          .firstWhere((v) => v['name'] == alias, orElse: () => null);
      if (primitiveToken != null) {
        return _parseColor(primitiveToken['value']);
      }
    } else {
      return _parseColor(token['value']);
    }
    return Colors.grey;
  }

  Color getBackgroundColor() {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.white;
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens',
        orElse: () => null);
    if (tokenCollection == null) return Colors.white;
    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere(
        (v) => v['name'] == 'Form Fields/Search/Default',
        orElse: () => null);
    if (token == null) return Colors.white;
    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections
          .firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection == null) return Colors.white;
      final primitiveVariables =
          primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables
          .firstWhere((v) => v['name'] == alias, orElse: () => null);
      if (primitiveToken != null) {
        return _parseColor(primitiveToken['value']);
      }
    } else {
      return _parseColor(token['value']);
    }
    return Colors.white;
  }

  /// Returns the input text style for both enabled and hovered (Input/Regular)
  TextStyle getInputTextStyle() {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return TextStyle();
    final typographyCollection = collections
        .firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
    if (typographyCollection == null) return TextStyle();
    final variables =
        typographyCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == 'Input/Regular',
        orElse: () => null);
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

  /// Returns the input text style for hovered (same as enabled, Input/Regular)
  TextStyle getHoveredInputTextStyle() {
    return getInputTextStyle();
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

  /// Returns the asset path for the search icon from supporting tokens
  String get searchIconAsset =>
      _tokenParser.getValue<String>(['searchBar', 'icons', 'search'],
          fromSupportingTokens: true) ??
      'assets/icons/search.svg';

  /// Returns the asset path for the microphone icon from supporting tokens
  String get microphoneIconAsset =>
      _tokenParser.getValue<String>(['searchBar', 'icons', 'microphone'],
          fromSupportingTokens: true) ??
      'assets/icons/microphone-2.svg';
}
