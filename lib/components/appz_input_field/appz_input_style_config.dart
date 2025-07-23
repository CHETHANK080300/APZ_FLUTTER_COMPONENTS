import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';
import 'appz_input_field_enums.dart';

class AppzStateStyle {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color labelColor;
  final String fontFamily;
  final double fontSize;
  final double labelFontSize;
  final double paddingHorizontal;
  final double paddingVertical;

  const AppzStateStyle({
    required this.borderColor,
    this.borderWidth = 1.0,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textColor,
    required this.labelColor,
    required this.fontFamily,
    required this.fontSize,
    required this.labelFontSize,
    required this.paddingHorizontal,
    required this.paddingVertical,
  });
}

class AppzStyleConfig {
  AppzStyleConfig._privateConstructor();
  static final AppzStyleConfig _instance = AppzStyleConfig._privateConstructor();
  static AppzStyleConfig get instance => _instance;

  final TokenParser _tokenParser = TokenParser();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> load() async {
    await _tokenParser.loadTokens();
    _isInitialized = true;
  }

  AppzStateStyle getStyleForState(AppzFieldState state, {bool isFilled = false}) {
    if (!_isInitialized) {
      throw Exception("AppzStyleConfig not initialized. Call load() first.");
    }

    String stateName = state.toString().split('.').last;
    if (isFilled) {
      stateName = 'filled';
    }

    // Capitalize first letter
    stateName = stateName[0].toUpperCase() + stateName.substring(1);


    return AppzStateStyle(
      borderColor: _getColor('Form Fields/Input/Outline $stateName') ?? Colors.grey,
      borderWidth: 1.0,
      borderRadius: _tokenParser.getValue<double>(['inputField', 'borderRadius'], fromSupportingTokens: true) ?? 8.0,
      backgroundColor: _getColor('Form Fields/Input/$stateName') ?? Colors.white,
      textColor: _getColor('Text colour/Input/Active') ?? Colors.black,
      labelColor: _getColor('Text colour/Label & Help/Default') ?? Colors.grey,
      fontFamily: _getFontFamily(),
      fontSize: _getFontSize(),
      labelFontSize: _getLabelFontSize(),
      paddingHorizontal: _tokenParser.getValue<double>(['inputField', 'padding', 'horizontal'], fromSupportingTokens: true) ?? 16.0,
      paddingVertical: _tokenParser.getValue<double>(['inputField', 'padding', 'vertical'], fromSupportingTokens: true) ?? 12.0,
    );
  }

  Color? _getColor(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return null;

    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection == null) return null;

    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

    if (token == null) return null;

    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection == null) return null;

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

    return null;
  }

  String _getFontFamily() {
    final textStyle = _getTextStyle('Input/Regular');
    return textStyle.fontFamily ?? 'Outfit';
  }

  double _getFontSize() {
    final textStyle = _getTextStyle('Input/Regular');
    return textStyle.fontSize ?? 14.0;
  }

  double _getLabelFontSize() {
    final textStyle = _getTextStyle('Label & Helper Text/Regular');
    return textStyle.fontSize ?? 12.0;
  }

  TextStyle _getTextStyle(String tokenName) {
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
