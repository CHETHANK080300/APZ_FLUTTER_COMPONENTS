import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class AppzImageStyleConfig {
  static final AppzImageStyleConfig instance = AppzImageStyleConfig._();
  AppzImageStyleConfig._();

  // Icon defaults (customizable) - only square shape supported
  late Map<String, double> iconSquareDefaults;

  // Image defaults (customizable) - nested by appearance
  late Map<String, Map<String, double>> imageAppearances;

  final TokenParser _tokenParser = TokenParser();

  Future<void> load() async {
    await _tokenParser.loadTokens();
    
    // Load icon square defaults (icons only support square shape)
    iconSquareDefaults = {
      'width': _tokenParser.getValue<double>(['icon', 'square', 'width'], fromSupportingTokens: true) ?? 24.0,
      'height': _tokenParser.getValue<double>(['icon', 'square', 'height'], fromSupportingTokens: true) ?? 24.0,
      'cornerRadius': _tokenParser.getValue<double>(['icon', 'square', 'cornerRadius'], fromSupportingTokens: true) ?? 0.0,
      'padding': _tokenParser.getValue<double>(['icon', 'square', 'padding'], fromSupportingTokens: true) ?? 2.0,
    };
    
    // Load image appearances (circular, square, rectangle)
    imageAppearances = {
      'circular': {
        'width': _tokenParser.getValue<double>(['image', 'circular', 'width'], fromSupportingTokens: true) ?? 60.0,
        'height': _tokenParser.getValue<double>(['image', 'circular', 'height'], fromSupportingTokens: true) ?? 60.0,
        'cornerRadius': _tokenParser.getValue<double>(['image', 'circular', 'cornerRadius'], fromSupportingTokens: true) ?? 30.0,
      },
      'square': {
        'width': _tokenParser.getValue<double>(['image', 'square', 'width'], fromSupportingTokens: true) ?? 60.0,
        'height': _tokenParser.getValue<double>(['image', 'square', 'height'], fromSupportingTokens: true) ?? 60.0,
        'cornerRadius': _tokenParser.getValue<double>(['image', 'square', 'cornerRadius'], fromSupportingTokens: true) ?? 8.0,
      },
      'rectangle': {
        'width': _tokenParser.getValue<double>(['image', 'rectangle', 'width'], fromSupportingTokens: true) ?? 80.0,
        'height': _tokenParser.getValue<double>(['image', 'rectangle', 'height'], fromSupportingTokens: true) ?? 40.0,
        'cornerRadius': _tokenParser.getValue<double>(['image', 'rectangle', 'cornerRadius'], fromSupportingTokens: true) ?? 0.0,
      },
    };
  }

  // Helper methods to get icon square values (icons only support square)
  double getIconCornerRadius(String appearance) {
    // Icons only support square shape, so ignore the appearance parameter
    return iconSquareDefaults['cornerRadius'] ?? 0.0;
  }

  double getIconPadding() {
    return iconSquareDefaults['padding'] ?? 2.0;
  }

  double getImageCornerRadius(String appearance) {
    return imageAppearances[appearance]?['cornerRadius'] ?? 0.0;
  }

  // Helper methods to get appearance-specific dimensions
  double getIconWidth(String appearance) {
    // Icons only support square shape, so ignore the appearance parameter
    return iconSquareDefaults['width'] ?? 24.0;
  }

  double getIconHeight(String appearance) {
    // Icons only support square shape, so ignore the appearance parameter
    return iconSquareDefaults['height'] ?? 24.0;
  }

  double getImageWidth(String appearance) {
    return imageAppearances[appearance]?['width'] ?? 40.0;
  }

  double getImageHeight(String appearance) {
    return imageAppearances[appearance]?['height'] ?? 40.0;
  }
}
