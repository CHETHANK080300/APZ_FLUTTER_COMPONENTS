import 'package:flutter/material.dart';
import 'radio_style_config.dart';

enum AppzRadioSize { small, medium, large }

class AppzRadio extends StatefulWidget {
  final bool isChecked;
  final bool isDisabled;
  final String? title;
  final String? subtitle;
  final AppzRadioSize size;
  final bool showError;
  final ValueChanged<bool>? onChanged;

  const AppzRadio({
    Key? key,
    this.isChecked = false,
    this.isDisabled = false,
    this.title,
    this.subtitle,
    this.size = AppzRadioSize.medium,
    this.showError = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppzRadio> createState() => _AppzRadioState();
}

class _AppzRadioState extends State<AppzRadio> {
  late bool _checked;
  late RadioStyleConfig _cfg;

  @override
  void initState() {
    super.initState();
    _checked = widget.isChecked;
    _cfg = RadioStyleConfig.instance;
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

    final outerRadius = _cfg.getDouble('outerRadius', sizeStr);
    final innerRadius = _cfg.getDouble('innerRadius', sizeStr);
    final borderWidth = _cfg.getDouble('borderWidth', sizeStr);

    final borderColor = _cfg.getColor('${state}_borderColor');
    final innerColor = _cfg.getColor('${state}_innerColor');
    final outerColor = _cfg.getColor('${state}_outerColor');

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
            width: outerRadius * 2.0,
            height: outerRadius * 2.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Center(
              child: _checked
                  ? Container(
                      width: innerRadius * 2.0,
                      height: innerRadius * 2.0,
                      decoration: BoxDecoration(
                        color: innerColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
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