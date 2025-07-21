import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TabStyleConfig {
  static final TabStyleConfig _instance = TabStyleConfig._internal();
  static TabStyleConfig get instance => _instance;
  factory TabStyleConfig() => _instance;
  TabStyleConfig._internal();

  late TextStyle defaultTextStyle;
  late TextStyle activeTextStyle;

  late Color activeBorderColor;
  late double activeBorderWidth;

  late double tabSpacing;
  late EdgeInsets tabPadding;

  late BoxDecoration containerDecoration;

  Future<void> load(String path) async {
    final jsonStr = await rootBundle.loadString(path);
    final parsed = jsonDecode(jsonStr);
    await loadFromResolved(parsed);
  }

  Future<void> loadFromResolved(Map<String, dynamic> json) async {
    final defaultStyle = json['default'] ?? {};
    final focused = json['focused'] ?? {};
    final layout = json['layout'] ?? {};

    final Color defaultTextColor = _hexToColor(defaultStyle['textColor'] ?? '#8A96A6');
    final Color activeTextColor = _hexToColor(focused['textColor'] ?? '#7B61FF');
     

    final double defaultFontSize = (defaultStyle['fontSize'] ?? 14).toDouble();
    final String defaultFontFamily = defaultStyle['fontFamily'] ?? 'Roboto';
    final double activeFontSize = (focused['fontSize'] ?? defaultFontSize).toDouble();
    final String activeFontFamily = focused['fontFamily'] ?? defaultFontFamily;

    
    activeBorderColor = _hexToColor(focused['borderColor'] ?? '#7B61FF');
    activeBorderWidth = (focused['borderWidth'] ?? 2).toDouble();

    final int defaultFontWeight = defaultStyle['fontWeight'] ?? 500;
    final int activeFontWeight = focused['fontWeight'] ?? 600;

    final borderRadius = (layout['borderRadius'] ?? 0).toDouble();

    defaultTextStyle = TextStyle(
      fontSize: defaultFontSize,
      fontWeight: getFontWeight(defaultFontWeight),
      color: defaultTextColor,
      fontFamily: defaultFontFamily,
    );

    activeTextStyle = TextStyle(
      fontSize: activeFontSize,
      fontWeight: getFontWeight(activeFontWeight),
      color: activeTextColor,
      fontFamily: activeFontFamily,
    );
    

    tabSpacing = (layout['tabSpacing'] ?? 8).toDouble();
    tabPadding = EdgeInsets.symmetric(
      horizontal: (layout['tabPaddingHorizontal'] ?? 18).toDouble(),
      vertical: (layout['tabPaddingVertical'] ?? 16).toDouble(),
    );

    containerDecoration = BoxDecoration(
      color: _hexToColor(layout['backgroundColor'] ?? '#FFFFFF'),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: _hexToColor(layout['borderColor'] ?? '#D9D9D9'),
        width: (layout['borderWidth'] ?? 0),
      ),
    );
  }

  FontWeight getFontWeight(dynamic weight) {
    final int w = int.tryParse(weight.toString()) ?? 500;
    return FontWeight.values[((w ~/ 100).clamp(1, 9)) - 1];
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}