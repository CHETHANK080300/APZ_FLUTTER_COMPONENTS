import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apz_flutter_components/components/appz_chips/appz_chips_style_config.dart';
import 'package:apz_flutter_components/components/appz_text/appz_text.dart';

class AppzChips extends StatefulWidget {
  final bool category;
  final String? categoryLabel;
  final List<Map<String, String>>
      chips; // Each map: {'label': ..., 'state': ...}
  final bool leadingIcon;
  final bool trailingIcon;
  final String? leadingIconPath;
  final String? trailingIconPath;
  final VoidCallback? onTap;
  final void Function(int index)? onRemove;
  final void Function(int index, String newState)? onStateChange;

  const AppzChips({
    Key? key,
    this.category = false,
    this.categoryLabel,
    required this.chips,
    this.leadingIcon = false,
    this.trailingIcon = false,
    this.leadingIconPath,
    this.trailingIconPath,
    this.onTap,
    this.onRemove,
    this.onStateChange,
  }) : super(key: key);

  @override
  State<AppzChips> createState() => _AppzChipsState();
}

class _AppzChipsState extends State<AppzChips> {
  void _handleTap(int index) {
    final state = widget.chips[index]['chipState']?.toLowerCase();
    if (state == 'disabled') return;
    final newState = state == 'active' ? 'Default' : 'Active';
    if (widget.onStateChange != null) widget.onStateChange!(index, newState);
    if (widget.onTap != null) widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppzChipsStyleConfig.instance;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(widget.chips.length, (index) {
        final chip = widget.chips[index];
        final state = chip['chipState']?.toLowerCase();
        final List<Widget> chipRow = [];
        // Category (if enabled, always leading)
        if (widget.category && widget.categoryLabel != null) {
          chipRow.add(AppzText(
            widget.categoryLabel!,
            category: 'label',
            fontWeight: 'regular',
            color: config.getTextColor(state),
          ));
          chipRow.add(SizedBox(width: config.getCategorySpacing()));
        }
        // Icon (leading)
        if (widget.leadingIcon && widget.leadingIconPath != null) {
          chipRow.add(SvgPicture.asset(
            widget.leadingIconPath!,
            width: config.getIconSize(),
            height: config.getIconSize(),
            color: config.getTextColor(state),
          ));
          chipRow.add(SizedBox(width: 4));
        }
        // Label
        chipRow.add(AppzText(
          chip['chipName'] ?? '',
          category: 'chips',
          fontWeight: 'text',
          color: config.getTextColor(state),
        ));
        // Icon (trailing)
        if (widget.trailingIcon && widget.trailingIconPath != null) {
          chipRow.add(SizedBox(width: 4));
          chipRow.add(
            GestureDetector(
              onTap: () {
                // Don't allow removal if chip is disabled
                if (state != 'disabled' && widget.onRemove != null) {
                  widget.onRemove!(index);
                }
              },
              child: SvgPicture.asset(
                widget.trailingIconPath!,
                width: config.getIconSize(),
                height: config.getIconSize(),
                color: config.getTextColor(state),
              ),
            ),
          );
        }
        // Category (trailing) - removed
        return GestureDetector(
          onTap: state == 'disabled' ? null : () => _handleTap(index),
          child: MouseRegion(
            cursor: state == 'disabled'
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            child: Container(
              padding: EdgeInsets.only(
                top: config.getPaddingTop(),
                bottom: config.getPaddingBottom(),
                left: config.getPaddingLeft(),
                right: config.getPaddingRight(),
              ),
              decoration: BoxDecoration(
                color: config.getBackgroundColor(state),
                borderRadius: BorderRadius.circular(config.getBorderRadius()),
                boxShadow: config.getBoxShadow(state) != null
                    ? [config.getBoxShadow(state)!]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: chipRow,
              ),
            ),
          ),
        );
      }),
    );
  }
}
