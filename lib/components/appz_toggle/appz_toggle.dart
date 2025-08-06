import 'package:flutter/material.dart';
import 'toggle_style_config.dart';

enum AppzToggleSize { small, large }

class AppzToggle extends StatefulWidget {
  final bool isOn;
  final bool isDisabled;
  final AppzToggleSize size;
  final String? text;
  final ValueChanged<bool>? onChanged;

  const AppzToggle({
    Key? key,
    this.isOn = false,
    this.isDisabled = false,
    this.size = AppzToggleSize.large,
    this.text,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppzToggle> createState() => _AppzToggleState();
}

class _AppzToggleState extends State<AppzToggle> {
  late bool _on;
  late ToggleStyleConfig _cfg;

  @override
  void initState() {
    super.initState();
    _on = widget.isOn;
    _cfg = ToggleStyleConfig.instance;
  }

  String _getState() {
    if (widget.isDisabled) return 'disabled';
    return _on ? 'on' : 'off';
  }

  @override
  Widget build(BuildContext context) {
    final sizeStr = widget.size.name;
    final state = _getState();

    final width = _cfg.getDouble('width', sizeStr);
    final height = _cfg.getDouble('height', sizeStr);
    final thumbSize = _cfg.getDouble('thumbSize', sizeStr);
    final padding = _cfg.getDouble('padding', sizeStr);
    final trackRadius = height / 2;
    final thumbPositionOn = width - thumbSize - padding;
    final thumbPositionOff = padding;
    final thumbPosition = _on ? thumbPositionOn : thumbPositionOff;

    final bgColor = _cfg.getColor('${state}_backgroundColor');
    final borderColor = _cfg.getColor('${state}_borderColor');
    final thumbColor = _cfg.getColor('${state}_thumbColor');
    final textColor = _cfg.getColor('${state}_textColor');
    final textStyle = _cfg.getTextStyle(sizeStr, textColor);
    final spacing = _cfg.getSpacing(sizeStr);

    return GestureDetector(
      onTap: widget.isDisabled
          ? null
          : () {
              setState(() {
                _on = !_on;
              });
              widget.onChanged?.call(_on);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(trackRadius),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: thumbPosition,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.text != null) ...[
            SizedBox(width: spacing),
            Text(
              widget.text!,
              style: textStyle,
            ),
          ],
        ],
      ),
    );
  }
} 