import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class AppzChipsStyleConfig {
  static final AppzChipsStyleConfig instance = AppzChipsStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();
  TokenParser get tokenParser => _tokenParser;

  AppzChipsStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
  }

  double getHeight() =>
      _tokenParser
          .getValue<double>(['chips', 'height'], fromSupportingTokens: true) ??
      32.0;

  double getBorderRadius() =>
      _tokenParser.getValue<double>(['chips', 'borderRadius'],
          fromSupportingTokens: true) ??
      28.0;

  double getPaddingTop() =>
      _tokenParser.getValue<double>(['chips', 'padding', 'top'],
          fromSupportingTokens: true) ??
      11.0;
  double getPaddingBottom() =>
      _tokenParser.getValue<double>(['chips', 'padding', 'bottom'],
          fromSupportingTokens: true) ??
      11.0;
  double getPaddingLeft() =>
      _tokenParser.getValue<double>(['chips', 'padding', 'left'],
          fromSupportingTokens: true) ??
      16.0;
  double getPaddingRight() =>
      _tokenParser.getValue<double>(['chips', 'padding', 'right'],
          fromSupportingTokens: true) ??
      16.0;

  double getCategorySpacing() =>
      _tokenParser.getValue<double>(['chips', 'categorySpacing'],
          fromSupportingTokens: true) ??
      4.0;

  String getShadowToken() =>
      _tokenParser
          .getValue<String>(['chips', 'shadow'], fromSupportingTokens: true) ??
      'Shadow/sm';

  String getIconAsset() =>
      _tokenParser.getValue<String>(['chips', 'icon', 'asset'],
          fromSupportingTokens: true) ??
      'assets/icons/X.svg';
  double getIconSize() =>
      _tokenParser.getValue<double>(['chips', 'icon', 'size'],
          fromSupportingTokens: true) ??
      16.0;

  Color getBackgroundColor(String? state) {
    switch (state) {
      case 'active':
        return getColorToken('Chips/Active');
      case 'disabled':
        return getColorToken('Button/Primary/Disabled');
      default:
        return getColorToken('Chips/Default');
    }
  }

  Color getTextColor(String? state) {
    switch (state) {
      case 'active':
        return getColorToken('Text colour/Chips/Inverse');
      case 'disabled':
        return getColorToken('Text colour/Chips/Disabled');
      default:
        return getColorToken('Text colour/Chips/Default');
    }
  }

  Color getColorToken(String name) {
    // This uses the TokenParser directly for color tokens
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.grey;
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens',
        orElse: () => null);
    if (tokenCollection == null) return Colors.grey;
    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token =
        variables.firstWhere((v) => v['name'] == name, orElse: () => null);
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
        return parseColor(primitiveToken['value']);
      }
    } else {
      return parseColor(token['value']);
    }
    return Colors.grey;
  }

  Color parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  BoxShadow? getBoxShadow(String? state) {
    if (state == 'active') {
      return BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 4,
        offset: Offset(0, 2),
      );
    }
    return null;
  }
}
