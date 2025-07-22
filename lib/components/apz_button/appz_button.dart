import 'package:flutter/material.dart';
import 'button_style_config.dart';

enum AppzButtonAppearance { primary, secondary, tertiary }
enum AppzButtonSize { small, medium, large }

class AppzButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final cfg = ButtonStyleConfig.instance;
    final sizeStr = size.name;

    if (appearance == AppzButtonAppearance.tertiary) {
      return _buildTertiaryButton(cfg);
    }

    return _buildPrimaryOrSecondaryButton(cfg, sizeStr);
  }

  Widget _buildPrimaryOrSecondaryButton(ButtonStyleConfig cfg, String sizeStr) {
    final state = disabled ? 'Disabled' : 'Default';
    final hover = !disabled;
    final appearanceStr = appearance.name[0].toUpperCase() + appearance.name.substring(1);

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: disabled ? null : onPressed,
        child: Builder(builder: (context) {
          final isHovering = context.findAncestorStateOfType<_AppzButtonHoverState>()?._hovering ?? false;
          final stateStr = disabled ? 'Disabled' : (isHovering && hover ? 'Hover' : 'Default');

          final bgColor = cfg.getColor('Button/$appearanceStr/$stateStr');
          final borderColor = cfg.getColor('Button/$appearanceStr/$stateStr outline');

          Color textColor;
          if (disabled) {
            textColor = cfg.getColor('Text colour/Button/Disabled');
          } else if (isHovering && hover) {
            textColor = cfg.getColor('Text colour/Button/Hover');
          } else {
             textColor = appearance == AppzButtonAppearance.primary
                ? cfg.getColor('Text colour/Button/Default')
                : cfg.getColor('Text colour/Button/Clicked');
          }

          return Container(
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
                if (iconLeading != null) ...[
                  Icon(iconLeading, color: textColor, size: 16),
                  SizedBox(width: cfg.getGap(sizeStr)),
                ],
                Text(
                  label,
                  style: cfg.getTextStyle('Button/Semibold').copyWith(color: textColor),
                ),
                if (iconTrailing != null) ...[
                  SizedBox(width: cfg.getGap(sizeStr)),
                  Icon(iconTrailing, color: textColor, size: 16),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTertiaryButton(ButtonStyleConfig cfg) {
    final state = disabled ? 'Disabled' : 'Default';
    final hover = !disabled;

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: disabled ? null : onPressed,
        child: Builder(builder: (context) {
          final isHovering = context.findAncestorStateOfType<_AppzButtonHoverState>()?._hovering ?? false;
          final stateStr = disabled ? 'Disabled' : (isHovering && hover ? 'Hover' : 'Default');

          final textColor = cfg.getColor('Text colour/Hyperlink/$stateStr');

          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconLeading != null) ...[
                Icon(iconLeading, color: textColor, size: 16),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: cfg.getTextStyle('Hyperlink/Medium').copyWith(color: textColor),
              ),
              if (iconTrailing != null) ...[
                const SizedBox(width: 4),
                Icon(iconTrailing, color: textColor, size: 16),
              ],
            ],
          );
        }),
      ),
    );
  }
}

class AppzButtonHover extends StatefulWidget {
  final Widget child;

  const AppzButtonHover({super.key, required this.child});

  @override
  State<AppzButtonHover> createState() => _AppzButtonHoverState();
}

class _AppzButtonHoverState extends State<AppzButtonHover> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: widget.child,
    );
  }
}
