import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class AppzBadgesStyleConfig {
  static final AppzBadgesStyleConfig instance =
      AppzBadgesStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  AppzBadgesStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  Color getBackgroundColor(String state) {
    switch (state) {
      case 'Default':
        return _getColorFromToken('Form Fields/Badges/Default');
      case 'Success':
        return _getColorFromToken('Form Fields/Badges/Success/Default');
      case 'Error':
        return _getColorFromToken('Form Fields/Badges/Error/Default');
      case 'Warning':
        return _getColorFromToken('Form Fields/Badges/Warning/Default');
      case 'Info':
        return _getColorFromToken('Semantics/Info/Info Container');
      default:
        return Colors.transparent;
    }
  }

  Color getStrokeColor(String state) {
    switch (state) {
      case 'Default':
        return _getColorFromToken('Form Fields/Badges/Default outline');
      case 'Success':
        return _getColorFromToken('Form Fields/Badges/Success/Default outline');
      case 'Error':
        return _getColorFromToken('Form Fields/Badges/Error/Default outline');
      case 'Warning':
        return _getColorFromToken('Form Fields/Badges/Warning/Default outline');
      case 'Info':
        return _getColorFromToken('Semantics/Info/Info');
      default:
        return Colors.transparent;
    }
  }

  Color getFontColor(String state) {
    switch (state) {
      case 'Default':
        return _getColorFromToken('Form Fields/Input/Default');
      case 'Success':
        return _getColorFromToken('Success colors/green-500');
      case 'Error':
        return _getColorFromToken('Form Fields/Badges/Error/Default outline');
      case 'Warning':
        return _getColorFromToken('Alert colors/orange-500');
      case 'Info':
        return _getColorFromToken('Semantics/Info/Info');
      default:
        return Colors.black;
    }
  }

  double getHeight(String size) {
    return _tokenParser.getValue<double>(['badges', size, 'height'],
            fromSupportingTokens: true) ??
        25.0;
  }

  EdgeInsets getPadding(String size) {
    final paddingMap = _tokenParser.getValue<Map<String, dynamic>>(
        ['badges', size, 'padding'],
        fromSupportingTokens: true);
    // if (paddingMap != null) {
    return EdgeInsets.fromLTRB(
      (paddingMap?['left'] as num).toDouble(),
      (paddingMap?['top'] as num).toDouble(),
      (paddingMap?['right'] as num).toDouble(),
      (paddingMap?['bottom'] as num).toDouble(),
    );
    // }
    // Fallback to hardcoded values if token parsing fails
    // switch (size) {
    //   case 'small':
    //     return const EdgeInsets.fromLTRB(12, 6, 12, 6);
    //   case 'large':
    //     return const EdgeInsets.fromLTRB(16, 8, 16, 8);
    //   default:
    //     return const EdgeInsets.fromLTRB(12, 6, 12, 6);
    // }
  }

  double getBorderRadius() {
    return _tokenParser.getValue<double>(['badges', 'borderRadius'],
            fromSupportingTokens: true) ??
        30.0;
  }

  double getBorderWeight() {
    return _tokenParser.getValue<double>(['badges', 'borderWeight'],
            fromSupportingTokens: true) ??
        1.0;
  }

  double getItemSpacing() {
    return _tokenParser.getValue<double>(['badges', 'itemSpacing'],
            fromSupportingTokens: true) ??
        4.0;
  }

  Color _getColorFromToken(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.transparent;

    // First try to find in Tokens collection
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens',
        orElse: () => null);
    if (tokenCollection != null) {
      final variables =
          tokenCollection['modes'][0]['variables'] as List<dynamic>;
      final token = variables.firstWhere((v) => v['name'] == tokenName,
          orElse: () => null);

      if (token != null) {
        if (token['isAlias'] == true) {
          final alias = token['value']['name'];

          // Try to find the alias in Primitive collection
          final primitiveCollection = collections
              .firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
          if (primitiveCollection != null) {
            final primitiveVariables =
                primitiveCollection['modes'][0]['variables'] as List<dynamic>;
            final primitiveToken = primitiveVariables
                .firstWhere((v) => v['name'] == alias, orElse: () => null);

            if (primitiveToken != null) {
              return _parseColor(primitiveToken['value']);
            }
          }

          // If not found in Primitive, try to find in Tokens collection
          final aliasToken = variables.firstWhere((v) => v['name'] == alias,
              orElse: () => null);
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
    final primitiveCollection = collections
        .firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
    if (primitiveCollection != null) {
      final primitiveVariables =
          primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables
          .firstWhere((v) => v['name'] == tokenName, orElse: () => null);

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

  FontWeight _getFontWeight(dynamic weight) {
    if (weight is String) {
      switch (weight.toLowerCase()) {
        case 'normal':
          return FontWeight.normal;
        case 'bold':
          return FontWeight.bold;
        case 'w100':
          return FontWeight.w100;
        case 'w200':
          return FontWeight.w200;
        case 'w300':
          return FontWeight.w300;
        case 'w400':
          return FontWeight.w400;
        case 'w500':
          return FontWeight.w500;
        case 'w600':
          return FontWeight.w600;
        case 'w700':
          return FontWeight.w700;
        case 'w800':
          return FontWeight.w800;
        case 'w900':
          return FontWeight.w900;
        default:
          return FontWeight.normal;
      }
    }
    return FontWeight.normal;
  }
}
