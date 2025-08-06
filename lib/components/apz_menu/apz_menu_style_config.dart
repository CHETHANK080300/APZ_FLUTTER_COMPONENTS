import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class ApzMenuStyleConfig {
  static final ApzMenuStyleConfig instance = ApzMenuStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  ApzMenuStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  // Menu frame properties
  Color getMenuBackgroundColor() {
    return _getColorFromToken('Surface/Colour 1');
  }

  double getMenuBorderRadius() {
    return _tokenParser.getValue<double>(['menu', 'frame', 'borderRadius'], fromSupportingTokens: true) ?? 24.0;
  }

  double getMenuPadding() {
    return _tokenParser.getValue<double>(['menu', 'frame', 'padding'], fromSupportingTokens: true) ?? 24.0;
  }

  // Close button properties
  Color getCloseButtonBackgroundColor() {
    return _getColorFromToken('Surface/Colour 1');
  }

  double getCloseButtonBorderRadius() {
    return _tokenParser.getValue<double>(['menu', 'closeButton', 'borderRadius'], fromSupportingTokens: true) ?? 749.25;
  }

  double getCloseButtonPadding() {
    return _tokenParser.getValue<double>(['menu', 'closeButton', 'padding'], fromSupportingTokens: true) ?? 3.0;
  }

  double getCloseButtonIconSize() {
    return _tokenParser.getValue<double>(['menu', 'closeButton', 'iconSize'], fromSupportingTokens: true) ?? 16.0;
  }

  // Menu item properties
  double getMenuItemPaddingTop() {
    return _tokenParser.getValue<double>(['menu', 'menuItem', 'paddingTop'], fromSupportingTokens: true) ?? 8.0;
  }

  double getMenuItemPaddingBottom() {
    return _tokenParser.getValue<double>(['menu', 'menuItem', 'paddingBottom'], fromSupportingTokens: true) ?? 8.0;
  }



  double getMenuItemSpacing() {
    return _tokenParser.getValue<double>(['menu', 'menuItem', 'spacing'], fromSupportingTokens: true) ?? 16.0;
  }

  // Signout item properties
  Color getSignoutBackgroundColor() {
    final colorHex = _tokenParser.getValue<String>(['menu', 'signout', 'backgroundColor'], fromSupportingTokens: true) ?? '#262633';
    return _parseColor(colorHex);
  }

  Color getSignoutBorderColor() {
    final colorHex = _tokenParser.getValue<String>(['menu', 'signout', 'borderColor'], fromSupportingTokens: true) ?? '#FFC9C6';
    return _parseColor(colorHex);
  }

  double getSignoutBorderRadius() {
    return _tokenParser.getValue<double>(['menu', 'signout', 'borderRadius'], fromSupportingTokens: true) ?? 16.0;
  }

  double getSignoutBorderWidth() {
    return _tokenParser.getValue<double>(['menu', 'signout', 'borderWidth'], fromSupportingTokens: true) ?? 1.0;
  }

  double getSignoutHeight() {
    return _tokenParser.getValue<double>(['menu', 'signout', 'height'], fromSupportingTokens: true) ?? 34.0;
  }

  double getSignoutPaddingHorizontal() {
    return _tokenParser.getValue<double>(['menu', 'signout', 'paddingHorizontal'], fromSupportingTokens: true) ?? 16.0;
  }

  double getSignoutPaddingTop() {
    return _tokenParser.getValue<double>(['menu', 'signout', 'paddingTop'], fromSupportingTokens: true) ?? 6.0;
  }

  double getSignoutPaddingBottom() {
    return _tokenParser.getValue<double>(['menu', 'signout', 'paddingBottom'], fromSupportingTokens: true) ?? 6.0;
  }

  double getSignoutWidth() {
    return _tokenParser.getValue<double>(['menu', 'signout', 'width'], fromSupportingTokens: true) ?? 119.0;
  }

  double getSignoutSpacing() {
    return _tokenParser.getValue<double>(['menu', 'signout', 'spacing'], fromSupportingTokens: true) ?? 16.0;
  }

  Color getSignoutTextColor() {
    final colorHex = _tokenParser.getValue<String>(['menu', 'signout', 'textColor'], fromSupportingTokens: true) ?? '#FFAA99';
    return _parseColor(colorHex);
  }

  Color getMenuItemTextColor() {
    return _getColorFromToken('Text colour/Title Text/Default');
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

  double? _parseSize(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return null;
  }
} 