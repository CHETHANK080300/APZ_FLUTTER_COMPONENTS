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
  final IconData? iconTrailing;
  final IconData? iconLeading;

  const AppzButton({
    super.key,
    required this.label,
    this.appearance = AppzButtonAppearance.primary,
    this.size = AppzButtonSize.medium,
    this.disabled = false,
    this.onPressed,
    this.iconTrailing,
    this.iconLeading,
  });

  @override
  State<AppzButton> createState() => _AppzButtonState();
}

class _AppzButtonState extends State<AppzButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final cfg = ButtonStyleConfig.instance;
    final sizeStr = widget.size.name;

    if (widget.appearance == AppzButtonAppearance.tertiary) {
      return _buildTertiaryButton(cfg);
    }

    return _buildPrimaryOrSecondaryButton(cfg, sizeStr);
  }

  Widget _buildPrimaryOrSecondaryButton(ButtonStyleConfig cfg, String sizeStr) {
    final state = widget.disabled ? 'Disabled' : (_hovering ? 'Hover' : 'Default');
    final appearanceStr = widget.appearance.name[0].toUpperCase() + widget.appearance.name.substring(1);

    final bgColor = cfg.getColor('Button/$appearanceStr/$state');
    final borderColor = cfg.getColor('Button/$appearanceStr/$state outline');

    Color textColor;
    if (widget.disabled) {
      textColor = cfg.getColor('Text colour/Button/Disabled');
    } else if (_hovering) {
      textColor = cfg.getColor('Text colour/Button/Hover');
    } else {
      textColor = widget.appearance == AppzButtonAppearance.primary
          ? cfg.getColor('Text colour/Button/Default')
          : cfg.getColor('Text colour/Button/Clicked');
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        child: Container(
          height: cfg.getHeight(sizeStr),
          padding: cfg.getPadding(sizeStr),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(cfg.getDouble('borderRadius', fromSupportingTokens: true) ?? 0),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.iconLeading != null) ...[
                Icon(widget.iconLeading, color: textColor, size: 16),
                SizedBox(width: cfg.getGap(sizeStr)),
              ],
              Text(
                widget.label,
                style: cfg.getTextStyle('Button/Semibold').copyWith(color: textColor),
              ),
              if (widget.iconTrailing != null) ...[
                SizedBox(width: cfg.getGap(sizeStr)),
                Icon(widget.iconTrailing, color: textColor, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTertiaryButton(ButtonStyleConfig cfg) {
    final state = widget.disabled ? 'Disabled' : (_hovering ? 'Hover' : 'Default');
    final textColor = cfg.getColor('Text colour/Hyperlink/$state');

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.iconLeading != null) ...[
              Icon(widget.iconLeading, color: textColor, size: 16),
              const SizedBox(width: 4),
            ],
            Text(
              widget.label,
              style: cfg.getTextStyle('Hyperlink/Medium').copyWith(color: textColor),
            ),
            if (widget.iconTrailing != null) ...[
              const SizedBox(width: 4),
              Icon(widget.iconTrailing, color: textColor, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
