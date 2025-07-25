/*import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';
import 'appz_input_field_enums.dart';

class AppzStateStyle {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color labelColor;
  final TextStyle labelTextStyle;
  final double paddingHorizontal;
  final double paddingVertical;
  final double height;
  final double gap;
  final double labelFontSize;
  final String fontFamily;

  const AppzStateStyle({
    required this.borderColor,
    this.borderWidth = 1.0,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textColor,
    required this.labelColor,
    required this.labelTextStyle,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.height,
    required this.gap,
    required this.labelFontSize,
    required this.fontFamily,
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

    Color getPropertyColor(String propertyName) {
      final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
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
          letterSpacing: (typography['letterSpacing'] as num).toDouble(),
        );
      }

      return TextStyle();
    }

    final labelTextStyle = getTextStyle('Label & Helper Text/Regular');
    Color borderColor;
    Color backgroundColor;
    Color textColor;
    Color labelColor;

    String stateName = state.toString().split('.').last;
    if (isFilled) {
      stateName = 'filled';
    }

    switch (state) {
      case AppzFieldState.focused:
        borderColor = getPropertyColor('Form Fields/Input/Outline focused');
        backgroundColor = getPropertyColor('Form Fields/Input/Focused');
        textColor = getPropertyColor('Text colour/Input/Active');
        labelColor = getPropertyColor('Text colour/Label & Help/Default');
        break;
      case AppzFieldState.error:
        borderColor = getPropertyColor('Form Fields/Input/Outline error');
        backgroundColor = getPropertyColor('Form Fields/Input/Error');
        textColor = getPropertyColor('Text colour/Input/Active');
        labelColor = getPropertyColor('Text colour/Label & Help/Default');
        break;
      case AppzFieldState.disabled:
        borderColor = getPropertyColor('Form Fields/Input/Outline disabled');
        backgroundColor = getPropertyColor('Form Fields/Input/Disabled');
        textColor = getPropertyColor('Text colour/Input/Disabled');
        labelColor = getPropertyColor('Text colour/Label & Help/Disabled');
        break;
      default:
        borderColor = getPropertyColor('Form Fields/Input/Outline default');
        backgroundColor = getPropertyColor('Form Fields/Input/Default');
        textColor = getPropertyColor('Text colour/Input/Active');
        labelColor = getPropertyColor('Text colour/Label & Help/Default');
    }

    if (isFilled) {
      borderColor = getPropertyColor('Form Fields/Input/Outline Filled');
      backgroundColor = getPropertyColor('Form Fields/Input/Filled');
    }

    return AppzStateStyle(
      borderColor: borderColor,
      borderWidth: 1.0,
      borderRadius: _tokenParser.getValue<double>(['inputField', 'borderRadius'], fromSupportingTokens: true) ?? 12.0,
      backgroundColor: backgroundColor,
      textColor: textColor,
      labelColor: labelColor,
      labelTextStyle: labelTextStyle,
      paddingHorizontal: _tokenParser.getValue<double>(['inputField', 'padding', 'horizontal'], fromSupportingTokens: true) ?? 16.0,
      paddingVertical: _tokenParser.getValue<double>(['inputField', 'padding', 'vertical'], fromSupportingTokens: true) ?? 12.0,
      height: _tokenParser.getValue<double>(['inputField', 'height'], fromSupportingTokens: true) ?? 44.0,
      gap: _tokenParser.getValue<double>(['inputField', 'gap'], fromSupportingTokens: true) ?? 8.0,
      labelFontSize: labelTextStyle.fontSize ?? 12.0,
      fontFamily: labelTextStyle.fontFamily ?? 'Outfit',
    );
  }

  Color getMandatoryAsteriskColor() {
    if (!_isInitialized) {
      throw Exception("AppzStyleConfig not initialized. Call load() first.");
    }
    return _getColor('Form Fields/Input/Outline error') ?? Colors.red;
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
}*/
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
  final TextStyle labelTextStyle;
  final double paddingHorizontal;
  final double paddingVertical;
  final double height;
  final double gap;
  final double labelFontSize;
  final String fontFamily;

  const AppzStateStyle({
    required this.borderColor,
    this.borderWidth = 1.0,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textColor,
    required this.labelColor,
    required this.labelTextStyle,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.height,
    required this.gap,
    required this.labelFontSize,
    required this.fontFamily,
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

    Color getPropertyColor(String propertyName) {
      final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
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
          letterSpacing: (typography['letterSpacing'] as num).toDouble(),
        );
      }

      return TextStyle();
    }

    final labelTextStyle = getTextStyle('Label & Helper Text/Regular');
    Color borderColor;
    Color backgroundColor;
    Color textColor;
    Color labelColor;

    String stateName = state.toString().split('.').last;
    if (isFilled) {
      stateName = 'filled';
    }

    switch (state) {
      case AppzFieldState.focused:
        borderColor = getPropertyColor('Form Fields/Input/Outline focused');
        backgroundColor = getPropertyColor('Form Fields/Input/Focused');
        textColor = getPropertyColor('Text colour/Input/Active');
        labelColor = getPropertyColor('Text colour/Label & Help/Default');
        break;
      case AppzFieldState.error:
        borderColor = getPropertyColor('Form Fields/Input/Outline error');
        backgroundColor = getPropertyColor('Form Fields/Input/Error');
        textColor = getPropertyColor('Text colour/Input/Active');
        labelColor = getPropertyColor('Text colour/Label & Help/Default');
        break;
      case AppzFieldState.disabled:
        borderColor = getPropertyColor('Form Fields/Input/Outline disabled');
        backgroundColor = getPropertyColor('Form Fields/Input/Disabled');
        textColor = getPropertyColor('Text colour/Input/Disabled');
        labelColor = getPropertyColor('Text colour/Label & Help/Disabled');
        break;
      default:
        borderColor = getPropertyColor('Form Fields/Input/Outline default');
        backgroundColor = getPropertyColor('Form Fields/Input/Default');
        textColor = getPropertyColor('Text colour/Input/Active');
        labelColor = getPropertyColor('Text colour/Label & Help/Default');
    }

    if (isFilled) {
      borderColor = getPropertyColor('Form Fields/Input/Outline Filled');
      backgroundColor = getPropertyColor('Form Fields/Input/Filled');
    }

    return AppzStateStyle(
      borderColor: borderColor,
      borderWidth: 1.0,
      borderRadius: _tokenParser.getValue<double>(['inputField', 'borderRadius'], fromSupportingTokens: true) ?? 12.0,
      backgroundColor: backgroundColor,
      textColor: textColor,
      labelColor: labelColor,
      labelTextStyle: labelTextStyle,
      paddingHorizontal: _tokenParser.getValue<double>(['inputField', 'padding', 'horizontal'], fromSupportingTokens: true) ?? 16.0,
      paddingVertical: _tokenParser.getValue<double>(['inputField', 'padding', 'vertical'], fromSupportingTokens: true) ?? 12.0,
      height: _tokenParser.getValue<double>(['inputField', 'height'], fromSupportingTokens: true) ?? 44.0,
      gap: _tokenParser.getValue<double>(['inputField', 'gap'], fromSupportingTokens: true) ?? 8.0,
      labelFontSize: labelTextStyle.fontSize ?? 12.0,
      fontFamily: labelTextStyle.fontFamily ?? 'Outfit',
    );
  }

  Color getMandatoryAsteriskColor() {
    if (!_isInitialized) {
      throw Exception("AppzStyleConfig not initialized. Call load() first.");
    }
    return _getColor('Form Fields/Input/Outline error') ?? Colors.red;
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
