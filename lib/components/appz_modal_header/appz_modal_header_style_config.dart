import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class AppzModalHeaderStyleConfig {
  static final AppzModalHeaderStyleConfig instance = AppzModalHeaderStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  AppzModalHeaderStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  double getWidth() {
    return _tokenParser.getValue<double>(['modalHeader', 'width'], fromSupportingTokens: true) ?? 343.0;
  }

  EdgeInsets getPadding() {
    final paddingMap = _tokenParser.getValue<Map<String, dynamic>>(['modalHeader', 'padding'], fromSupportingTokens: true);
    if (paddingMap != null) {
      return EdgeInsets.symmetric(
        horizontal: (paddingMap['horizontal'] as num).toDouble(),
        vertical: (paddingMap['vertical'] as num).toDouble(),
      );
    }
    return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
  }

  BorderRadius getBorderRadius() {
    final borderRadiusMap = _tokenParser.getValue<Map<String, dynamic>>(['modalHeader', 'borderRadius'], fromSupportingTokens: true);
    if (borderRadiusMap != null) {
      return BorderRadius.only(
        topLeft: Radius.circular((borderRadiusMap['topLeft'] as num).toDouble()),
        topRight: Radius.circular((borderRadiusMap['topRight'] as num).toDouble()),
      );
    }
    return const BorderRadius.only(
      topLeft: Radius.circular(16.0),
      topRight: Radius.circular(16.0),
    );
  }

  double getBorderWidth() {
    return _tokenParser.getValue<double>(['modalHeader', 'borderWidth'], fromSupportingTokens: true) ?? 1.0;
  }

  double getSpacing() {
    return _tokenParser.getValue<double>(['modalHeader', 'spacing'], fromSupportingTokens: true) ?? 4.0;
  }

  double getCloseButtonIconSize() {
    final closeButtonMap = _tokenParser.getValue<Map<String, dynamic>>(['modalHeader', 'closeButton'], fromSupportingTokens: true);
    if (closeButtonMap != null) {
      return (closeButtonMap['iconSize'] as num).toDouble();
    }
    return 24.0;
  }

  Color getBackgroundColor() {
    return _getColorFromToken('Surface/Colour 1');
  }

  Color getBorderColor() {
    return _getColorFromToken('Form Fields/Input/Outline default');
  }

  Color getTextColor() {
    return _getColorFromToken('Text colour/Table Header/Default');
  }

  Color getIconColor() {
    return _getColorFromToken('Icon/Default');
  }

  Color _getColorFromToken(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.transparent;

    // First try to find in Tokens collection
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection != null) {
      final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
      final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

      if (token != null) {
        if (token['isAlias'] == true) {
          final alias = token['value']['name'];
          
          // Try to find the alias in Primitive collection
          final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
          if (primitiveCollection != null) {
            final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
            final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);
            
            if (primitiveToken != null) {
              return _parseColor(primitiveToken['value']);
            }
          }
          
          // If not found in Primitive, try to find in Tokens collection
          final aliasToken = variables.firstWhere((v) => v['name'] == alias, orElse: () => null);
          if (aliasToken != null) {
            // Recursively resolve the alias
            return _getColorFromToken(alias);
          }
        } else {
          return _parseColor(token['value']);
        }
      }
    }
    
    // If not found in Tokens collection, try to find directly in Primitive collection
    final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
    if (primitiveCollection != null) {
      final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);
      
      if (primitiveToken != null) {
        return _parseColor(primitiveToken['value']);
      }
    }
    
    return Colors.transparent;
  }

  Color _parseColor(dynamic value) {
    if (value is String) {
      if (value.startsWith('#')) {
        return Color(int.parse(value.replaceAll('#', '0xFF')));
      }
    }
    return Colors.transparent;
  }
} 