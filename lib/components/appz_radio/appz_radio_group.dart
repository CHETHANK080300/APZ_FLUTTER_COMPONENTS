import 'package:apz_flutter_components/components/appz_radio/radio_style_config.dart';
import 'package:flutter/material.dart';

enum AppzRadioSize { small, medium, large }

class AppzRadioItem extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? defaultValue;
  final AppzRadioSize size;
  final bool isDisabled;
  final bool isMandatory;
  final bool showError;
  final ValueChanged<String>? onChanged;

  const AppzRadioItem({
    Key? key,
    required this.label,
    required this.options,
    this.defaultValue,
    this.size = AppzRadioSize.medium,
    this.isDisabled = false,
    this.isMandatory = false,
    this.showError = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppzRadioItem> createState() => _AppzRadioItemState();
}

class _AppzRadioItemState extends State<AppzRadioItem> {
  late String? _selected;
  late RadioStyleConfig _cfg;

  @override
  void initState() {
    super.initState();
    _selected = widget.defaultValue;
    _cfg = RadioStyleConfig.instance;
  }

  void _handleSelection(String value) {
    if (widget.isDisabled) return;
    setState(() {
      _selected = value;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final double outerRadius;
    final double innerRadius;
    final double borderWidth;
    final double spacing;
    final TextStyle labelStyle;
    final TextStyle optionStyle;
    final TextStyle errorStyle;
    outerRadius = _cfg.getDouble('outerRadius', widget.size.name);
    innerRadius = _cfg.getDouble('innerRadius', widget.size.name);
    borderWidth = _cfg.getDouble('borderWidth', widget.size.name);
    spacing = _cfg.getDouble('spacing', widget.size.name);

    switch (widget.size) {
      case AppzRadioSize.small:
        labelStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
        optionStyle = TextStyle(fontSize: 12);
        errorStyle = TextStyle(fontSize: 10, color: Colors.red);
        break;
      case AppzRadioSize.large:
        labelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
        optionStyle = TextStyle(fontSize: 16);
        errorStyle = TextStyle(fontSize: 12, color: Colors.red);
        break;
      default:
        labelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
        optionStyle = TextStyle(fontSize: 14);
        errorStyle = TextStyle(fontSize: 11, color: Colors.red);
    }

    final showError = widget.isMandatory && widget.showError && _selected == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label + (widget.isMandatory ? ' *' : ''),
          style: labelStyle,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: spacing * 2,
          runSpacing: spacing,
          children: widget.options.map((option) {
            final isSelected = _selected == option;
            final bool isDisabled = widget.isDisabled;

            final borderColor = isDisabled
                ? Colors.grey
                : isSelected ? Colors.blue : Colors.black54;
            final innerColor = isSelected
                ? (isDisabled ? Colors.grey : Colors.blue)
                : Colors.transparent;

            return GestureDetector(
              onTap: () => _handleSelection(option),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: outerRadius * 2,
                    height: outerRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: borderWidth),
                    ),
                    child: Center(
                      child: Container(
                        width: innerRadius * 2,
                        height: innerRadius * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: innerColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing / 2),
                  Text(option, style: optionStyle),
                ],
              ),
            );
          }).toList(),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text('Please select ${widget.label}', style: errorStyle),
          ),
      ],
    );
  }
}
