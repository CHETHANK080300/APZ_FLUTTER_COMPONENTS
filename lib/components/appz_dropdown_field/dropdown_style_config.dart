import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class DropdownStyleConfig {
  static final DropdownStyleConfig instance = DropdownStyleConfig._();
  DropdownStyleConfig._();

  late DropdownStateStyle defaultStyle;
  late DropdownStateStyle focused;
  late DropdownStateStyle error;
  late DropdownStateStyle disabled;
  late DropdownStateStyle filled;
  late HoverStateStyle hover;
  late HoverStateStyle selected;
  late Color mandatoryAsteriskColor;

  Future<void> load() async {
    final tokenParser = TokenParser();
    await tokenParser.loadTokens();

    defaultStyle = DropdownStateStyle.fromTokens(tokenParser, 'default');
    focused = DropdownStateStyle.fromTokens(tokenParser, 'focused');
    error = DropdownStateStyle.fromTokens(tokenParser, 'error');
    disabled = DropdownStateStyle.fromTokens(tokenParser, 'disabled');
    filled = DropdownStateStyle.fromTokens(tokenParser, 'filled');
    hover = HoverStateStyle.fromTokens(tokenParser, 'hover');
    selected = HoverStateStyle.fromTokens(tokenParser, 'selected');

    // Asterisk color from error outline
    mandatoryAsteriskColor = _parseColor(
      tokenParser.getValue<String>(['Form Fields', 'Dropdown', 'Outline error']) ?? '#D80000',
    );
  }
}

class DropdownStateStyle {
  final Color borderColor;
  final double? borderWidth;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color labelColor;
  final Color ddOverlayTextColor;
  final String? fontFamily;
  final double? fontSize;
  final double? labelFontSize;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? dropdownMaxHeight;
  final double? elevation;
  final double? gap;

  DropdownStateStyle({
    required this.borderColor,
    this.borderWidth,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textColor,
    required this.ddOverlayTextColor,
    required this.labelColor,
    this.fontFamily,
    this.fontSize,
    this.labelFontSize,
    this.paddingHorizontal,

    this.paddingVertical,
    this.dropdownMaxHeight,
    this.elevation,
    this.gap,
  });

  factory DropdownStateStyle.fromTokens(TokenParser parser, String state) {
    Color getPropertyColor(String propertyName) {
      final collections = parser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return Colors.transparent;

      final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
      if (tokenCollection == null) return Colors.transparent;

      final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
      final token = variables.firstWhere((v) => v['name'] == propertyName, orElse: () => null);

      if (token == null) return Colors.transparent;

      if (token['isAlias'] == true) {
        final alias = token['value']['name'];
        final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
        if (primitiveCollection == null) return Colors.transparent;

        final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
        final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);

        if (primitiveToken != null) {
          return _parseColor(primitiveToken['value']);
        }
      } else {
        return _parseColor(token['value']);
      }

      return Colors.transparent;
    }

    String getTypography(String tokenName) {
      final collections = parser.getValue<List<dynamic>>(['collections']);
      if (collections == null) return 'Outfit';

      final typographyCollection = collections.firstWhere((c) => c['name'] == 'Typography', orElse: () => null);
      if (typographyCollection == null) return 'Outfit';

      final variables = typographyCollection['modes'][0]['variables'] as List<dynamic>;
      final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);

      if (token != null && token['value'] is Map<String, dynamic>) {
        final typography = token['value'];
        return typography['fontFamily'];
      }

      return 'Outfit';
    }

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    switch (state) {
      case 'focused':
        backgroundColor = getPropertyColor('Form Fields/Dropdown/Default');
        borderColor = getPropertyColor('Form Fields/Dropdown/Outline clicked');
        textColor = getPropertyColor('Text colour/Input/Active');
        break;
      case 'filled':
        backgroundColor = getPropertyColor('Form Fields/Dropdown/Filled');
        borderColor = getPropertyColor('Form Fields/Dropdown/Outline default');
        textColor = getPropertyColor('Text colour/Input/Active');
        break;
      case 'disabled':
        backgroundColor = getPropertyColor('Form Fields/Dropdown/Disabled');
        borderColor = getPropertyColor('Form Fields/Dropdown/Outline disabled');
        textColor = getPropertyColor('Text colour/Input/Disabled');
        break;
      case 'error':
        backgroundColor = getPropertyColor('Form Fields/Dropdown/Error');
        borderColor = getPropertyColor('Form Fields/Dropdown/Outline error');
        textColor = getPropertyColor('Text colour/Input/Active');
        break;
      default:
        backgroundColor = getPropertyColor('Form Fields/Dropdown/Default');
        borderColor = getPropertyColor('Form Fields/Dropdown/Outline default');
        textColor = getPropertyColor('Text colour/Input/Default');
    }

    return DropdownStateStyle(
      borderColor: borderColor,
      borderWidth: 1.0,
      borderRadius: parser.getValue<double>(['dropdown', 'borderRadius'], fromSupportingTokens: true) ?? 12.0,
      backgroundColor: backgroundColor,
      textColor: textColor,
      ddOverlayTextColor: getPropertyColor('Text colour/Input/Active'),
      labelColor: getPropertyColor('Text colour/Label & Help/Default'),
      fontFamily: getTypography('Input/Regular'),
      fontSize: 14.0,
      labelFontSize: parser.getValue<double>(['dropdown', 'labelFontSize'], fromSupportingTokens: true) ?? 12.0,
      paddingHorizontal: parser.getValue<double>(['dropdown', 'padding', 'horizontal'], fromSupportingTokens: true) ?? 16.0,
      paddingVertical: parser.getValue<double>(['dropdown', 'padding', 'vertical'], fromSupportingTokens: true) ?? 12.0,
      dropdownMaxHeight: parser.getValue<double>(['dropdown', 'dropdownMaxHeight'], fromSupportingTokens: true) ?? 220.0,
      elevation: parser.getValue<double>(['dropdown', 'elevation'], fromSupportingTokens: true) ?? 4.0,
      gap: parser.getValue<double>(['dropdown', 'gap'], fromSupportingTokens: true) ?? 8.0,
    );
  }
}

class HoverStateStyle {
  final Color itemBackgroundColor;
  final Color textColor;

  HoverStateStyle({
    required this.itemBackgroundColor,
    required this.textColor,
  });

  factory HoverStateStyle.fromTokens(TokenParser parser, String state) {
    if (state == 'selected') {
      return HoverStateStyle(
        itemBackgroundColor: _parseColor(parser.getValue<String>(['dropdown', 'selectedItemColor'], fromSupportingTokens: true) ?? '#0047AB'),
        textColor: _parseColor(parser.getValue<String>(['dropdown', 'selectedTextColor'], fromSupportingTokens: true) ?? '#FFFFFF'),
      );
    }
    return HoverStateStyle(
      itemBackgroundColor: _parseColor(parser.getValue<String>(['Form Fields', 'Dropdown', state.replaceFirst(state[0], state[0].toUpperCase())]) ?? '#F3F4F6'),
      textColor: _parseColor(parser.getValue<String>(['Text colour', 'Input', 'Default']) ?? '#000000'),
    );
  }
}

Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xff')));
Color? _parseOptionalColor(String? hex) => hex == null ? null : _parseColor(hex);
