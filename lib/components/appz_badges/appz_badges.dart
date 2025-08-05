import 'package:flutter/material.dart';
import 'appz_badges_style_config.dart';
import '../appz_text/appz_text.dart';

enum AppzBadgeSize { small, large }
enum AppzBadgeState { defaultState, success, warning, error, info }

class AppzBadges extends StatefulWidget {
  final AppzBadgeSize size;
  final AppzBadgeState state;
  final String label;

  const AppzBadges({
    super.key,
    required this.size,
    required this.state,
    required this.label,
  });

  @override
  State<AppzBadges> createState() => _AppzBadgesState();
}

class _AppzBadgesState extends State<AppzBadges> {
  @override
  Widget build(BuildContext context) {
    final config = AppzBadgesStyleConfig.instance;
    final sizeStr = widget.size.name;
    final stateStr = _getStateString(widget.state);

    // Get colors based on state
    final backgroundColor = config.getBackgroundColor(stateStr);
    final strokeColor = config.getStrokeColor(stateStr);
    final fontColor = config.getFontColor(stateStr);

    // Get dimensions
    final height = config.getHeight(sizeStr);
    final padding = config.getPadding(sizeStr);
    final borderRadius = config.getBorderRadius();
    final borderWeight = config.getBorderWeight();

    // Determine AppzText category and fontWeight based on size
    final textCategory = sizeStr == 'small' ? 'label' : 'input';
    final textFontWeight = sizeStr == 'small' ? 'label' : 'medium';

    return Container(
      constraints: BoxConstraints(
        minHeight: height,
      ),
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: strokeColor,
          width: borderWeight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppzText(
            widget.label,
            category: textCategory,
            fontWeight: textFontWeight,
            color: fontColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStateString(AppzBadgeState state) {
    switch (state) {
      case AppzBadgeState.defaultState:
        return 'Default';
      case AppzBadgeState.success:
        return 'Success';
      case AppzBadgeState.warning:
        return 'Warning';
      case AppzBadgeState.error:
        return 'Error';
      case AppzBadgeState.info:
        return 'Info';
    }
  }
} 