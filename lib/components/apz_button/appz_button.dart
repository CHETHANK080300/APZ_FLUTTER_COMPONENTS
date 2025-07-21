
import 'package:flutter/material.dart';
import 'button_style_config.dart';

enum AppzButtonAppearance { primary, secondary, tertiary }
enum AppzButtonSize { small, medium, large }

class AppzButton extends StatefulWidget {
  final String label;
  final AppzButtonAppearance appearance;
  final AppzButtonSize size;
  final bool disabled;
  final VoidCallback? onPressed;

  const AppzButton({
    super.key,
    required this.label,
    this.appearance = AppzButtonAppearance.primary,
    this.size = AppzButtonSize.medium,
    this.disabled = false,
    this.onPressed,
  });

  @override
  State<AppzButton> createState() => _AppzButtonState();
}

class _AppzButtonState extends State<AppzButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final cfg = ButtonStyleConfig.instance;
    final typeStr = widget.appearance.name;
    final sizeStr = widget.size.name;

    final state = widget.disabled ? 'disabled' : (_hovering ? 'hover' : null);
    final bgColor = cfg.getColor('backgroundColor', category: typeStr, state: state);
    final borderColor = cfg.getColor('borderColor', category: typeStr, state: state);
    final textColor = cfg.getColor('textColor', category: typeStr, state: state);

    final height = cfg.getHeight(sizeStr);
    final width = cfg.getWidth(sizeStr);
    final fontSize = cfg.getFontSize(sizeStr);
    final padding = cfg.getPadding(sizeStr);
    final borderRadius = cfg.getBorderRadius();
    final borderWidth = cfg.getBorderWidth();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: padding[0], vertical: padding[1]),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              fontFamily: cfg.getFontFamily(),
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
