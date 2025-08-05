import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class AppzProgressStepStyleConfig {
  static final AppzProgressStepStyleConfig instance =
      AppzProgressStepStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();
  List<String> _stepLabels = [];

  AppzProgressStepStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  Future<void> loadWithLabels(Map<String, dynamic> resolvedConfig) async {
    await load();
    final steps = resolvedConfig['steps'] as List<dynamic>?;
    if (steps != null) {
      _stepLabels = steps.map((e) => e['label'] as String).toList();
    }
  }

  List<String> get stepLabels => _stepLabels;

  List<String> get stepsFromSupportingTokens =>
      _tokenParser.getValue<List<dynamic>>(['progressStep', 'steps'],
          fromSupportingTokens: true)?.cast<String>() ??
      [];

  // Typography for labels
  TextStyle getInactiveLabelTextStyle() {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return TextStyle();
    final typographyCollection = collections
        .firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
    if (typographyCollection == null) return TextStyle();
    final variables =
        typographyCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == 'Paragraph/Semibold',
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

  TextStyle getActiveLabelTextStyle() {
    // Same as inactive, Paragraph/Semibold
    return getInactiveLabelTextStyle();
  }

  // Colors for labels
  Color getInactiveLabelColor() => _getColorToken('Text colour/Input/Default');
  Color getActiveLabelColor() =>
      _getColorToken('Text colour/Paragraph/Style 2');
  Color getCompletedLabelColor() => _getColorToken('Text colour/Input/Default');

  // Connector colors
  Color getConnectorInactiveColor() => _getColorToken('Outline/Disabled');
  Color getConnectorCompletedColor() => _getColorToken('Icon/Default');

  // Static values from supporting tokens
  double getCircleSize() =>
      _tokenParser.getValue<double>(['progressStep', 'circleSize'],
          fromSupportingTokens: true) ??
      24.0;
  double getIconSize() =>
      _tokenParser.getValue<double>(['progressStep', 'iconSize'],
          fromSupportingTokens: true) ??
      12.0;
  double getBorderWidth() =>
      _tokenParser.getValue<double>(['progressStep', 'borderWidth'],
          fromSupportingTokens: true) ??
      1.5;
  double getBorderRadius() =>
      _tokenParser.getValue<double>(['progressStep', 'borderRadius'],
          fromSupportingTokens: true) ??
      999.0;
  double getStepSpacing() =>
      _tokenParser.getValue<double>(['progressStep', 'stepSpacing'],
          fromSupportingTokens: true) ??
      12.0;
  double getVerticalSpacing() =>
      _tokenParser.getValue<double>(['progressStep', 'verticalSpacing'],
          fromSupportingTokens: true) ??
      4.0;
  double getConnectorLineWidth() =>
      _tokenParser.getValue<double>(['progressStep', 'connectorLineWidth'],
          fromSupportingTokens: true) ??
      4.0;
  double getConnectorLineHeight() =>
      _tokenParser.getValue<double>(['progressStep', 'connectorLineHeight'],
          fromSupportingTokens: true) ??
      24.0;

  // Icon asset paths
  String getIconCompleted() =>
      _tokenParser.getValue<String>(['progressStep', 'icons', 'completed'],
          fromSupportingTokens: true) ??
      '';
  String getIconCurrent() =>
      _tokenParser.getValue<String>(['progressStep', 'icons', 'current'],
          fromSupportingTokens: true) ??
      '';
  String getIconNext() =>
      _tokenParser.getValue<String>(['progressStep', 'icons', 'next'],
          fromSupportingTokens: true) ??
      '';
  String getIconNextDashed() =>
      _tokenParser.getValue<String>(['progressStep', 'icons', 'nextdashed'],
          fromSupportingTokens: true) ??
      '';
  String getIconLineEnabled() =>
      _tokenParser.getValue<String>(['progressStep', 'icons', 'lineEnabled'],
          fromSupportingTokens: true) ??
      '';
  String getIconLineDisabled() =>
      _tokenParser.getValue<String>(['progressStep', 'icons', 'lineDisabled'],
          fromSupportingTokens: true) ??
      '';

  // Helper to get color from token name
  Color _getColorToken(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.black;
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens',
        orElse: () => null);
    if (tokenCollection == null) return Colors.black;
    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token =
        variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);
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
