import 'package:flutter/material.dart';
import '../../common/token_parser.dart';

class AlertStyleConfig extends ChangeNotifier {
  static final AlertStyleConfig instance = AlertStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();
  bool _useMaterialTheme = true;
  bool _isLoaded = false;

  AlertStyleConfig._internal();

  bool get useMaterialTheme => _useMaterialTheme;

  void setUseMaterialTheme(bool value) {
    _useMaterialTheme = value;
    notifyListeners();
  }

  Future<void> load() async {
    try {
      await _tokenParser.loadTokens();
      final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['alert'], fromSupportingTokens: true);
      _config = supportingConfig;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      _isLoaded = false;
    }
  }

  Future<void> reload(String path) async {
    try {
      await _tokenParser.loadTokens();
      final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['alert'], fromSupportingTokens: true);
      _config = supportingConfig;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      _isLoaded = false;
    }
  }

  bool get isInitialized => _config != null && _isLoaded;

  Color color(String key) {
    if (_useMaterialTheme) {
      final theme = _getCurrentTheme();
      switch (key) {
        case 'backgroundColor':
          return theme.colorScheme.surface;
        case 'borderColor':
          return theme.colorScheme.outline;
        case 'titleColor':
          return theme.colorScheme.onSurface;
        case 'descriptionColor':
          return theme.colorScheme.onSurfaceVariant;
        case 'primaryButtonColor':
          return theme.colorScheme.primary;
        case 'secondaryButtonColor':
          return theme.colorScheme.surface;
        case 'secondaryButtonBorderColor':
          return theme.colorScheme.outline;
        case 'primaryButtonTextColor':
          return theme.colorScheme.onPrimary;
        case 'secondaryButtonTextColor':
          return theme.colorScheme.onSurface;
        default:
          return theme.colorScheme.onSurface;
      }
    }

    throw Exception('AlertStyleConfig: color key "$key" not found in color token map.');
  }

  ThemeData _getCurrentTheme() {
    return ThemeData();
  }

  Map<String, double> get sizes {
    if (_config == null || !_isLoaded) {
      throw Exception('AlertStyleConfig not initialized. Call load() first.');
    }
    final sizesMap = _config!['sizes'] as Map<String, dynamic>;
    return sizesMap.map((k, v) => (v is num) ? MapEntry(k, (v as num).toDouble()) : MapEntry(k, double.tryParse(v.toString()) ?? 0));
  }

  double size(String key) {
    if (_config == null || !_isLoaded) {
      throw Exception('AlertStyleConfig not initialized. Call load() first.');
    }
    final sizesMap = _config!['sizes'] as Map<String, dynamic>;
    if (!sizesMap.containsKey(key)) {
      throw Exception('AlertStyleConfig: size key "$key" not found in config.');
    }
    final value = sizesMap[key];
    return value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0;
  }

  List<dynamic>? get boxShadow {
    if (_config == null || !_isLoaded) {
      throw Exception('AlertStyleConfig not initialized. Call load() first.');
    }
    return _config!['boxShadow'] as List<dynamic>?;
  }

  static Color parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  // Alert-specific color getters
  Color getBackgroundColor() => color('backgroundColor');
  Color getBorderColor() => color('borderColor');
  Color getTitleColor() => color('titleColor');
  Color getDescriptionColor() => color('descriptionColor');
  Color getPrimaryButtonColor() => color('primaryButtonColor');
  Color getSecondaryButtonColor() => color('secondaryButtonColor');
  Color getSecondaryButtonBorderColor() => color('secondaryButtonBorderColor');
  Color getPrimaryButtonTextColor() => color('primaryButtonTextColor');
  Color getSecondaryButtonTextColor() => color('secondaryButtonTextColor');

  // Icon background color getters
  Color getSuccessIconBackgroundColor() {
    return getColor('Success colors/green-500');
  }

  Color getWarningIconBackgroundColor() {
    return getColor('Alert colors/orange-500');
  }

  Color getErrorIconBackgroundColor() {
    return getColor('Error colors/red-500');
  }

  Color getInfoIconBackgroundColor() {
    return getColor('Primary colors/primary 500');
  }

  Color getIconColor() {
    return getColor('Base colors/White');
  }

  Color getColor(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.transparent;

    final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
    if (primitiveCollection != null) {
      final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);
      
      if (primitiveToken != null) {
        return parseColor(primitiveToken['value']);
      }
    }

    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection == null) return Colors.transparent;

    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

    if (token == null) return Colors.transparent;

    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      
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

  String getSuccessIconPath() {
    if (_config == null || !_isLoaded) {
      throw Exception('AlertStyleConfig not initialized. Call load() first.');
    }
    final iconsMap = _config!['icons'] as Map<String, dynamic>;
    return iconsMap['success'] as String;
  }

  String getWarningIconPath() {
    if (_config == null || !_isLoaded) {
      throw Exception('AlertStyleConfig not initialized. Call load() first.');
    }
    final iconsMap = _config!['icons'] as Map<String, dynamic>;
    return iconsMap['warning'] as String;
  }

  String getErrorIconPath() {
    if (_config == null || !_isLoaded) {
      throw Exception('AlertStyleConfig not initialized. Call load() first.');
    }
    final iconsMap = _config!['icons'] as Map<String, dynamic>;
    return iconsMap['error'] as String;
  }

  String getInfoIconPath() {
    if (_config == null || !_isLoaded) {
      throw Exception('AlertStyleConfig not initialized. Call load() first.');
    }
    final iconsMap = _config!['icons'] as Map<String, dynamic>;
    return iconsMap['info'] as String;
  }

  String getCloseIconPath() {
    if (_config == null || !_isLoaded) {
      throw Exception('AlertStyleConfig not initialized. Call load() first.');
    }
    final iconsMap = _config!['icons'] as Map<String, dynamic>;
    return iconsMap['close'] as String;
  }
} 