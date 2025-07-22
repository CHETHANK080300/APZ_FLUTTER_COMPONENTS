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

        return _buildBarOnly(constraints.maxWidth, height, borderRadius, fillPercent, bgColor, fillColor);
      },
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
