import 'package:flutter/material.dart';
import 'toggle_with_label_style_config.dart';

enum AppzToggleWithLabelSize { small, large }

class AppzToggleWithLabel extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppzToggleWithLabelSize size;
  final String inactiveText;
  final String activeText;
  final bool isDisabled;

  const AppzToggleWithLabel({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.size = AppzToggleWithLabelSize.large,
    this.inactiveText = 'No',
    this.activeText = 'Yes',
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cfg = ToggleWithLabelStyleConfig.instance;
    final sizeStr = size.name;
    final width = cfg.getDouble('width', sizeStr);
    final height = cfg.getDouble('height', sizeStr);
    final borderRadius = cfg.getDouble('borderRadius', sizeStr);
    final fontSize = cfg.getDouble('fontSize', sizeStr);
    final labelFontSize = cfg.getDouble('labelFontSize', sizeStr);
    final spacing = cfg.getDouble('spacing', sizeStr);

    Widget buildToggleButton({required String text, required bool selected, required VoidCallback onTap, required bool disabled}) {
      final state = disabled
          ? 'disabled'
          : (selected ? 'selected' : 'unselected');
      final bgColor = cfg.getColor('${state}_backgroundColor');
      final borderColor = cfg.getColor('${state}_borderColor');
      final textColor = cfg.getColor('${state}_textColor');
      final fontFamily = cfg.getFontFamily();
      final fontWeight = cfg.getFontWeight();
      return Container(
        width: width / 2 - 2,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: disabled ? null : onTap,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final labelFontFamily = cfg.getFontFamily();
    final labelFontWeight = cfg.getLabelFontWeight();
    final labelTextColor = cfg.getColor('label_textColor');

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: labelFontFamily,
            fontWeight: labelFontWeight,
            fontSize: labelFontSize,
            color: labelTextColor,
          ),
        ),
        SizedBox(height: spacing),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: cfg.getColor('unselected_borderColor'),
              width: 1.0,
            ),
            color: cfg.getColor('unselected_backgroundColor'),
          ),
          child: Row(
            children: [
              buildToggleButton(
                text: inactiveText,
                selected: !value,
                onTap: () => onChanged(false),
                disabled: isDisabled,
              ),
              buildToggleButton(
                text: activeText,
                selected: value,
                onTap: () => onChanged(true),
                disabled: isDisabled,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 