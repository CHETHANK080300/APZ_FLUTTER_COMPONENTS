import 'package:flutter/material.dart';
import 'checkbox_style_config.dart';

enum AppzCheckboxSize { small, medium, large }

class AppzCheckbox extends StatefulWidget {
  final bool isChecked;
  final bool isDisabled;
  final String? title;
  final String? subtitle;
  final AppzCheckboxSize size;
  final bool showError;
  final ValueChanged<bool>? onChanged;

  const AppzCheckbox({
    Key? key,
    this.isChecked = false,
    this.isDisabled = false,
    this.title,
    this.subtitle,
    this.size = AppzCheckboxSize.medium,
    this.showError = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppzCheckbox> createState() => _AppzCheckboxState();
}

class _AppzCheckboxState extends State<AppzCheckbox> {
  late bool _checked;
  late CheckboxStyleConfig _cfg;

  @override
  void initState() {
    super.initState();
    _checked = widget.isChecked;
    _cfg = CheckboxStyleConfig.instance;
  }

  String _getState() {
    if (widget.isDisabled) return 'disabled';
    if (_checked) return 'selected';
    return 'unselected';
  }

  @override
  Widget build(BuildContext context) {
    final sizeStr = widget.size.name;
    final state = _getState();

    final width = _cfg.getDouble('width', sizeStr);
    final height = _cfg.getDouble('height', sizeStr);
    final borderRadius = _cfg.getDouble('borderRadius', sizeStr);
    final iconSize = _cfg.getDouble('iconSize', sizeStr);
    final borderWidth = _cfg.getDouble('borderWidth', sizeStr);

    final bgColor = _cfg.getColor('${state}_backgroundColor');
    final borderColor = _cfg.getColor('${state}_borderColor');
    final iconColor = _cfg.getColor('${state}_iconColor');

    final textStyle = _cfg.getTextStyle('title', sizeStr, widget.isDisabled);
    final subtitleStyle = _cfg.getTextStyle('subtitle', sizeStr, widget.isDisabled);
    final spacing = _cfg.getDouble('spacing', sizeStr);

    return GestureDetector(
      onTap: widget.isDisabled
          ? null
          : () {
              setState(() {
                _checked = !_checked;
              });
              widget.onChanged?.call(_checked);
            },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: _checked
                ? Icon(Icons.check, size: iconSize, color: iconColor)
                : null,
          ),
          if (widget.title != null || widget.subtitle != null) ...[
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    Text(widget.title!, style: textStyle),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(widget.subtitle!, style: subtitleStyle),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
} 