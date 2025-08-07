import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';
import 'appz_checkbox.dart';

class AppzCheckboxStyleConfig {
  static final AppzCheckboxStyleConfig instance = AppzCheckboxStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  AppzCheckboxStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  double getWidth() {
    return _tokenParser.getValue<double>(['checkbox', 'width'], fromSupportingTokens: true) ?? 20.0; // Default to 20.0 as per Figma 'Check'
  }

  double getHeight() {
    return _tokenParser.getValue<double>(['checkbox', 'height'], fromSupportingTokens: true) ?? 20.0; // Default to 20.0 as per Figma 'Check'
  }

  double getBorderRadius() {
    return _tokenParser.getValue<double>(['checkbox', 'borderRadius'], fromSupportingTokens: true) ?? 4.0; // Default to 4.0 as per Figma 'Check'
  }

  double getBorderWidth() {
    return _tokenParser.getValue<double>(['checkbox', 'borderWidth'], fromSupportingTokens: true) ?? 1.43; // Default to 1.43 as per Figma 'Inactive'
  }

  double getIconSize() {
    return _tokenParser.getValue<double>(['checkbox', 'iconSize'], fromSupportingTokens: true) ?? 16.0;
  }

  double getSpacing() {
    return _tokenParser.getValue<double>(['checkbox', 'spacing'], fromSupportingTokens: true) ?? 12.0;
  }

  double getGroupSpacing() {
    return _tokenParser.getValue<double>(['checkbox', 'groupSpacing'], fromSupportingTokens: true) ?? 16.0;
  }

  double getGroupRunSpacing() {
    return _tokenParser.getValue<double>(['checkbox', 'groupRunSpacing'], fromSupportingTokens: true) ?? 8.0;
  }

  double getContainerWidth() {
    return _tokenParser.getValue<double>(['checkbox', 'containerWidth'], fromSupportingTokens: true) ?? 24.5;
  }

  double getContainerHeight() {
    return _tokenParser.getValue<double>(['checkbox', 'containerHeight'], fromSupportingTokens: true) ?? 24.0;
  }

  // Font sizes are now handled by AppzText component
  // getLabelFontSize method removed as typography is managed by AppzText

  Color getActiveBackgroundColor() {
    return _getColorFromToken('Form Fields/Selections/Active');
  }

  Color getInactiveBorderColor() {
    return _getColorFromToken('Form Fields/Selections/Inactive');
  }

  Color getCheckmarkColor() {
    return _getColorFromToken('Base colors/White');
  }

  Color getLabelColor() {
    return _getColorFromToken('Text colour/Input/Active');
  }

  Color getDisabledLabelColor() {
    return _getColorFromToken('Text colour/Label & Help/Disabled');
  }

  double getSubtitleSpacing() {
    return 4.0; // Default spacing between label and subtitle
  }

  Color getSubtitleColor() {
    return _getColorFromToken('Text colour/Input/Default');
  }

  Color getDisabledSubtitleColor() {
    return _getColorFromToken('Text colour/Label & Help/Disabled');
  }

  // Font sizes are now handled by AppzText component
  // getSubtitleFontSize method removed as typography is managed by AppzText

  Color _getColorFromToken(String tokenName) {
    try {
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
    } catch (e) {
      // Return transparent color if tokens are not loaded
      return Colors.transparent;
    }
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