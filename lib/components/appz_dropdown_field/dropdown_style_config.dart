
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
  }
}

class DropdownStateStyle {
  final Color borderColor;
  final double? borderWidth;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color labelColor;
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
    String backgroundColor;
    String borderColor;
    String textColor;

    switch (state) {
      case 'focused':
        backgroundColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Default']) ?? '#FFFFFF';
        borderColor = parser.getValue<String>(['Form Fields', 'Input', 'Outline default']) ?? '#D9D9D9';
        textColor = parser.getValue<String>(['Text colour', 'Input', 'Active']) ?? '#000000';
        break;
      case 'filled':
        backgroundColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Filled']) ?? '#FFFFFF';
        borderColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Outline default']) ?? '#D9D9D9';
        textColor = parser.getValue<String>(['Text colour', 'Input', 'Active']) ?? '#000000';
        break;
      case 'disabled':
        backgroundColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Disabled']) ?? '#EEEEEE';
        borderColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Outline disabled']) ?? '#E0E0E0';
        textColor = parser.getValue<String>(['Text colour', 'Input', 'Disabled']) ?? '#000000';
        break;
      case 'error':
        backgroundColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Disabled']) ?? '#FEECEC';
        borderColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Outline error']) ?? '#D80000';
        textColor = parser.getValue<String>(['Text colour', 'Input', 'Disabled']) ?? '#000000';
        break;
      default:
        backgroundColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Default']) ?? '#FFFFFF';
        borderColor = parser.getValue<String>(['Form Fields', 'Dropdown', 'Outline default']) ?? '#D9D9D9';
        textColor = parser.getValue<String>(['Text colour', 'Input', 'Default']) ?? '#000000';
    }

    return DropdownStateStyle(
      borderColor: _parseColor(borderColor),
      borderWidth: 1.0,
      borderRadius: parser.getValue<double>(['dropdown', 'borderRadius'], fromSupportingTokens: true) ?? 12.0,
      backgroundColor: _parseColor(backgroundColor),
      textColor: _parseColor(textColor),
      labelColor: _parseColor(parser.getValue<String>(['Text colour', 'Label & Help', 'Default']) ?? '#000000'),
      fontFamily: 'Outfit',
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