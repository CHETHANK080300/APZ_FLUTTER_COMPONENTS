/*import 'package:flutter/material.dart';
import '../../common/token_parser.dart';
 
class ToggleButtonStyleConfig extends ChangeNotifier {
  static final ToggleButtonStyleConfig instance = ToggleButtonStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();
  bool _useMaterialTheme = true;
  bool _isLoaded = false;
 
  ToggleButtonStyleConfig._internal();
 
  bool get useMaterialTheme => _useMaterialTheme;
 
  void setUseMaterialTheme(bool value) {
    _useMaterialTheme = value;
    notifyListeners();
  }
 
  Future<void> load() async {
    try {
      await _tokenParser.loadTokens();
      final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['toggleButton'], fromSupportingTokens: true);
      _config = supportingConfig;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      _isLoaded = false;
    }
  }
 
  bool get isInitialized => _config != null && _isLoaded;
 
  Color getActiveColor() {
    return getColor('Form Fields/Toggle/Button/Active');
  }
 
  Color getInactiveColor() {
    return getColor('Form Fields/Toggle/Button/Inactive');
  }
 
  Color getActiveTextColor() {
    return getColor('Text colour/Button/Default');
  }
 
  Color getInactiveTextColor() {
    return getColor('Text colour/Button/Clicked');
  }
 
  double getBorderRadius() {
    return _tokenParser.getValue<double>(['toggleButton', 'borderRadius'], fromSupportingTokens: true) ?? 0.0;
  }
 
  EdgeInsets getPadding(String size) {
    final paddingMap = _tokenParser.getValue<Map<String, dynamic>>(['toggleButton', size, 'padding'], fromSupportingTokens: true);
    if (paddingMap != null) {
      return EdgeInsets.symmetric(
        horizontal: paddingMap['horizontal']?.toDouble() ?? 0.0,
        vertical: paddingMap['vertical']?.toDouble() ?? 0.0,
      );
    }
    return EdgeInsets.zero;
  }
 
  Color getColor(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.transparent;
 
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection == null) return Colors.transparent;
 
    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);
 
    if (token == null) return Colors.transparent;
 
    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection != null) {
        final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
        final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);
 
        if (primitiveToken != null) {
          return parseColor(primitiveToken['value']);
        }
      }
    } else {
      return parseColor(token['value']);
    }
 
    return Colors.transparent;
  }
 
  static Color parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}*/
import 'package:flutter/material.dart';
import '../../common/token_parser.dart';

class ToggleButtonStyleConfig extends ChangeNotifier {
  static final ToggleButtonStyleConfig instance = ToggleButtonStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();
  bool _useMaterialTheme = true;
  bool _isLoaded = false;

  ToggleButtonStyleConfig._internal();

  bool get useMaterialTheme => _useMaterialTheme;

  void setUseMaterialTheme(bool value) {
    _useMaterialTheme = value;
    notifyListeners();
  }

  Future<void> load() async {
    try {
      await _tokenParser.loadTokens();
      final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['toggleButton'], fromSupportingTokens: true);
      _config = supportingConfig;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      _isLoaded = false;
    }
  }

  bool get isInitialized => _config != null && _isLoaded;

  Color getActiveColor() {
    return getColor('Form Fields/Toggle/Button/Active');
  }

  Color getInactiveColor() {
    return getColor('Form Fields/Toggle/Button/Inactive');
  }

  Color getActiveTextColor() {
    return getColor('Text colour/Button/Default');
  }

  Color getInactiveTextColor() {
    return getColor('Text colour/Button/Clicked');
  }

  double getBorderRadius() {
    return _tokenParser.getValue<double>(['toggleButton', 'borderRadius'], fromSupportingTokens: true) ?? 0.0;
  }

  EdgeInsets getPadding(String size) {
    final paddingMap = _tokenParser.getValue<Map<String, dynamic>>(['toggleButton', size, 'padding'], fromSupportingTokens: true);
    if (paddingMap != null) {
      return EdgeInsets.symmetric(
        horizontal: paddingMap['horizontal']?.toDouble() ?? 0.0,
        vertical: paddingMap['vertical']?.toDouble() ?? 0.0,
      );
    }
    return EdgeInsets.zero;
  }

  Color getColor(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.transparent;

    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection == null) return Colors.transparent;

    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

    if (token == null) return Colors.transparent;

    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection != null) {
        final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
        final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);

        if (primitiveToken != null) {
          return parseColor(primitiveToken['value']);
        }
      }
    } else {
      return parseColor(token['value']);
    }

    return Colors.transparent;
  }

  static Color parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}