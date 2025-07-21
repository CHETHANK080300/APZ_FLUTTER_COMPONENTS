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

    final state = widget.disabled ? 'Disabled' : (_hovering ? 'Hover' : 'Default');
    final appearance = widget.appearance.name[0].toUpperCase() + widget.appearance.name.substring(1);

    final bgColor = cfg.getColor('Button/$appearance/$state');
    final borderColor = cfg.getColor('Button/$appearance/$state outline');
    final textColor = cfg.getColor('Text colour/Button/Default'); // This might need more specific token names

    final spacings = cfg.getSpacings();
    final double horizontalPadding = spacings['medium'] ?? 16.0;
    final double verticalPadding = spacings['small'] ?? 8.0;

    final textStyle = cfg.getTextStyle('Button/Semibold'); // Assuming 'Button/Semibold' is a valid token

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(spacings['x-small'] ?? 4.0),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: textStyle.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
