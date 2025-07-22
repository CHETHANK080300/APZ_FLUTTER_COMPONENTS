import 'package:flutter/material.dart';
import 'progress_bar_style_config.dart';

enum ProgressBarLabelPosition {
  none,
  right,
  bottom,
  topFloating,
  bottomFloating,
}

class AppzProgressBar extends StatefulWidget {
  final double percentage;
  final ProgressBarLabelPosition labelPosition;
  final String? labelText;
  final bool showPercentage;

  const AppzProgressBar({
    super.key,
    required this.percentage,
    this.labelPosition = ProgressBarLabelPosition.none,
    this.labelText,
    this.showPercentage = true,
  });

  @override
  State<AppzProgressBar> createState() => _AppzProgressBarState();
}

class _AppzProgressBarState extends State<AppzProgressBar> {
  late ProgressBarStyleConfig cfg;

  @override
  void initState() {
    super.initState();
    cfg = ProgressBarStyleConfig.instance;
  }

  @override
  Widget build(BuildContext context) {
    final fillPercent = widget.percentage.clamp(0.0, 100.0);
    final displayText = widget.labelText ??
        '${fillPercent.toInt()}${widget.showPercentage ? '%' : ''}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = cfg.getDouble('height', fromSupportingTokens: true) ?? 8.0;
        final borderRadius = cfg.getDouble('borderRadius', fromSupportingTokens: true) ?? 8.0;
        final bgColor = cfg.getColor('Form Fields/Progress bar/Color 2');
        final fillColor = cfg.getColor('Form Fields/Progress bar/Color 3');
        final labelStyle = cfg.getTextStyle('Label & Helper Text/Regular').copyWith(
              color: cfg.getColor('Text colour/Tooltip/Style 2'),
            );

        Widget barWidget;
        switch (widget.labelPosition) {
          case ProgressBarLabelPosition.none:
            barWidget = _buildBarOnly(constraints.maxWidth, height, borderRadius, fillPercent, bgColor, fillColor);
            break;
          case ProgressBarLabelPosition.right:
            barWidget = Row(
              children: [
                Expanded(child: _buildBarOnly(constraints.maxWidth, height, borderRadius, fillPercent, bgColor, fillColor)),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(displayText, style: labelStyle),
                ),
              ],
            );
            break;
          case ProgressBarLabelPosition.bottom:
            barWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarOnly(constraints.maxWidth, height, borderRadius, fillPercent, bgColor, fillColor),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(displayText, style: labelStyle),
                ),
              ],
            );
            break;
          case ProgressBarLabelPosition.topFloating:
            barWidget = Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBarOnly(constraints.maxWidth, height, borderRadius, fillPercent, bgColor, fillColor),
                Positioned(
                  left: (constraints.maxWidth * (fillPercent / 100.0)) - 20,
                  bottom: height + 5,
                  child: _buildFloatingLabel(displayText, labelStyle),
                ),
              ],
            );
            break;
          case ProgressBarLabelPosition.bottomFloating:
            barWidget = Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBarOnly(constraints.maxWidth, height, borderRadius, fillPercent, bgColor, fillColor),
                Positioned(
                  left: (constraints.maxWidth * (fillPercent / 100.0)) - 20,
                  top: height + 5,
                  child: _buildFloatingLabel(displayText, labelStyle),
                ),
              ],
            );
            break;
        }
        return barWidget;
      },
    );
  }

  Widget _buildFloatingLabel(String text, TextStyle style) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: cfg.getColor('Form Fields/Tooltip/Default'),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: cfg.getColor('Shadow/lg').withOpacity(0.08),
            offset: const Offset(0, 12),
            blurRadius: 16.0,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: cfg.getColor('Shadow/lg').withOpacity(0.03),
            offset: const Offset(0, 4),
            blurRadius: 6.0,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Text(text, style: style.copyWith(color: cfg.getColor('Text colour/Tooltip/Style 2'))),
    );
  }

  Widget _buildBarOnly(double width, double height, double radius, double fillPercent, Color bg, Color fill) {
    final fillWidth = (fillPercent / 100.0) * width;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          if (fillPercent > 0)
            Container(
              width: fillWidth,
              height: height,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
        ],
      ),
    );
  }
}
