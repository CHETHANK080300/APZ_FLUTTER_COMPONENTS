import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class ApzListContentStyleConfig {
  static final ApzListContentStyleConfig instance = ApzListContentStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  ApzListContentStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  Color getLabelColor() {
    return _getColorFromToken('Text colour/Label & Help/Default');
  }

  Color getValueColor() {
    return _getColorFromToken('Text colour/Input/Active');
  }

  double getSideBySideSpacing() {
    return _tokenParser.getValue<double>(['listContent', 'sideBySide', 'spacing'], fromSupportingTokens: true) ?? 24.0;
  }

  double getTwoLineSpacing() {
    return _tokenParser.getValue<double>(['listContent', 'twoLine', 'spacing'], fromSupportingTokens: true) ?? 10.0;
  }

  double getSideBySideTotalWidth() {
    return _tokenParser.getValue<double>(['listContent', 'sideBySide', 'totalWidth'], fromSupportingTokens: true) ?? 311.0;
  }

  double getSideBySideLabelWidth() {
    return _tokenParser.getValue<double>(['listContent', 'sideBySide', 'labelWidth'], fromSupportingTokens: true) ?? 103.0;
  }

  double getTwoLineWidth() {
    return _tokenParser.getValue<double>(['listContent', 'twoLine', 'width'], fromSupportingTokens: true) ?? 219.0;
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