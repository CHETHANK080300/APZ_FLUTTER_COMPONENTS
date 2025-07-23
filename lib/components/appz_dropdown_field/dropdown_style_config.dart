
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
  final Color? backgroundColor;
  final Color? textColor;
  final Color? labelColor;
  final String? fontFamily;
  final double? fontSize;
  final double? labelFontSize;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? dropdownMaxHeight;
  final double? elevation;

  DropdownStateStyle({
    required this.borderColor,
    this.borderWidth,
    required this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.labelColor,
    this.fontFamily,
    this.fontSize,
    this.labelFontSize,
    this.paddingHorizontal,
    this.paddingVertical,
    this.dropdownMaxHeight,
    this.elevation,
  });

  factory DropdownStateStyle.fromTokens(TokenParser parser, String state) {
    return DropdownStateStyle(
      borderColor: _parseColor(parser.getValue<String>(['Form Fields', 'Dropdown', 'Outline ${state.replaceFirst(state[0], state[0].toUpperCase())}']) ?? parser.getValue<String>(['Form Fields', 'Dropdown', 'Outline default']) ?? '#D9D9D9'),
      borderWidth: 1.0,
      borderRadius: parser.getValue<double>(['dropdown', 'borderRadius'], isSupportingToken: true) ?? 10.0,
      backgroundColor: _parseOptionalColor(parser.getValue<String>(['Form Fields', 'Dropdown', state.replaceFirst(state[0], state[0].toUpperCase())]) ?? parser.getValue<String>(['Form Fields', 'Dropdown', 'Default'])),
      textColor: _parseOptionalColor(parser.getValue<String>(['Text colour', 'Input', 'Default'])),
      labelColor: _parseOptionalColor(parser.getValue<String>(['Text colour', 'Label & Help', 'Default'])),
      fontFamily: 'Outfit',
      fontSize: 14.0,
      labelFontSize: parser.getValue<double>(['dropdown', 'labelFontSize'], isSupportingToken: true) ?? 12.0,
      paddingHorizontal: parser.getValue<double>(['dropdown', 'padding', 'horizontal'], isSupportingToken: true) ?? 12.0,
      paddingVertical: parser.getValue<double>(['dropdown', 'padding', 'vertical'], isSupportingToken: true) ?? 10.0,
      dropdownMaxHeight: parser.getValue<double>(['dropdown', 'dropdownMaxHeight'], isSupportingToken: true) ?? 220.0,
      elevation: parser.getValue<double>(['dropdown', 'elevation'], isSupportingToken: true) ?? 4.0,
    );
  }
}

class HoverStateStyle {
  final Color? itemBackgroundColor;
  final Color? textColor;

  HoverStateStyle({
    this.itemBackgroundColor,
    this.textColor,
  });

  factory HoverStateStyle.fromTokens(TokenParser parser, String state) {
    if (state == 'selected') {
      return HoverStateStyle(
        itemBackgroundColor: _parseOptionalColor(parser.getValue<String>(['dropdown', 'selectedItemColor'], isSupportingToken: true)),
        textColor: _parseOptionalColor(parser.getValue<String>(['dropdown', 'selectedTextColor'], isSupportingToken: true)),
      );
    }
    return HoverStateStyle(
      itemBackgroundColor: _parseOptionalColor(parser.getValue<String>(['Form Fields', 'Dropdown', state.replaceFirst(state[0], state[0].toUpperCase())])),
      textColor: _parseOptionalColor(parser.getValue<String>(['Text colour', 'Input', 'Default'])),
    );
  }
}

Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xff')));
Color? _parseOptionalColor(String? hex) => hex == null ? null : _parseColor(hex);