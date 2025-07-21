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

  String _categoryFromLabelPosition(ProgressBarLabelPosition position) {
    switch (position) {
      case ProgressBarLabelPosition.none:
        return 'noLabel';
      case ProgressBarLabelPosition.right:
        return 'rightLabel';
      case ProgressBarLabelPosition.bottom:
        return 'bottomLabel';
      case ProgressBarLabelPosition.topFloating:
        return 'topFloatingLabel';
      case ProgressBarLabelPosition.bottomFloating:
        return 'bottomFloatingLabel';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fillPercent = widget.percentage.clamp(0.0, 100.0);
    final displayText = widget.labelText ??
        '${fillPercent.toInt()}${widget.showPercentage ? '%' : ''}';
    final category = _categoryFromLabelPosition(widget.labelPosition);

    return LayoutBuilder(
      builder: (context, constraints) {
        const double horizontalPadding = 16.0;
        double screenWidth = MediaQuery.of(context).size.width;
        final availableWidth = (constraints.hasBoundedWidth && constraints.maxWidth != double.infinity)
            ? constraints.maxWidth
            : screenWidth;
        final drawableWidth = availableWidth - (horizontalPadding * 2);
        final height = cfg.getDouble('height', category: category);
        final borderRadius = cfg.getDouble('borderRadius');
        final fontSize = cfg.getDouble('fontSize');
        final fontFamily = cfg.get('fontFamily') ?? 'Outfit';
        final labelColor = cfg.getColor('labelColor');
        final labelPadding = cfg.getEdgeInsets('labelPadding');
        final labelSpacing = cfg.getDouble('labelSpacing');
        final floatingOffset = cfg.getDouble('floatingLabelOffset');
        final floatingBg = cfg.getColor('floatingLabelBackgroundColor');
        final floatingShadow = cfg.getColor('floatingLabelShadowColor');
        final bgColor = cfg.getColor('backgroundColor');
        final fillColor = cfg.getColor('fillColor');

        final labelStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
          color: labelColor,
        );

        Widget barWidget;
        switch (widget.labelPosition) {
          case ProgressBarLabelPosition.none:
            barWidget = _buildBarOnly(drawableWidth, height, borderRadius, fillPercent, bgColor, fillColor);
            break;
          case ProgressBarLabelPosition.right:
            const double minBarWidth = 40;
            // Measure natural label width
            final TextPainter textPainter = TextPainter(
              text: TextSpan(text: displayText, style: labelStyle),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout();
            final double naturalLabelWidth = textPainter.size.width;
            final double availableLabelWidth = drawableWidth - minBarWidth - labelSpacing;
            double barWidth;
            double labelWidth;
            if (naturalLabelWidth <= availableLabelWidth) {
              labelWidth = naturalLabelWidth + 4.0; // Add buffer to prevent clipping
              barWidth = drawableWidth - labelSpacing - labelWidth;
            } else {
              barWidth = minBarWidth;
              labelWidth = drawableWidth - barWidth - labelSpacing;
            }
            barWidget = SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: barWidth,
                    child: _buildBarOnly(
                      barWidth,
                      height,
                      borderRadius,
                      fillPercent,
                      bgColor,
                      fillColor,
                    ),
                  ),
                  SizedBox(width: labelSpacing),
                  Text(
                    displayText,
                    style: labelStyle,
                    maxLines: 1,
                  ),
                ],
              ),
            );
            break;
          case ProgressBarLabelPosition.bottom:
            barWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarOnly(drawableWidth, height, borderRadius, fillPercent, bgColor, fillColor),
                SizedBox(height: labelSpacing),
                Text(
                  displayText,
                  style: labelStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            );
            break;
          case ProgressBarLabelPosition.topFloating:
            barWidget = Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBarOnly(drawableWidth, height, borderRadius, fillPercent, bgColor, fillColor),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: height + 4, // 4px gap above the bar
                  child: Align(
                    alignment: Alignment((fillPercent / 50.0) - 1, 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: drawableWidth * 0.7, minWidth: 32),
                      child: Container(
                        padding: labelPadding,
                        decoration: BoxDecoration(
                          color: floatingBg,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: floatingShadow.withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          displayText,
                          style: labelStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
            break;
          case ProgressBarLabelPosition.bottomFloating:
            barWidget = Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBarOnly(drawableWidth, height, borderRadius, fillPercent, bgColor, fillColor),
                Positioned(
                  left: 0,
                  right: 0,
                  top: height + 4, // 4px gap below the bar
                  child: Align(
                    alignment: Alignment((fillPercent / 50.0) - 1, 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: drawableWidth * 0.7, minWidth: 32),
                      child: Container(
                        padding: labelPadding,
                        decoration: BoxDecoration(
                          color: floatingBg,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: floatingShadow.withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          displayText,
                          style: labelStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
            break;
        }
        // Add extra margin for floating labels to prevent overlap with other content
        EdgeInsets margin = EdgeInsets.zero;
        if (widget.labelPosition == ProgressBarLabelPosition.topFloating) {
          margin = const EdgeInsets.only(top: 24.0);
        } else if (widget.labelPosition == ProgressBarLabelPosition.bottomFloating) {
          margin = const EdgeInsets.only(bottom: 24.0);
        }
        return Container(
          margin: margin,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: barWidget,
          ),
        );
      },
    );
  }

  Widget _buildBarOnly(double width, double height, double radius, double fillPercent, Color bg, Color fill) {
    final minBarWidth = 40.0;
    final safeWidth = width < minBarWidth ? minBarWidth : width;
    final fillWidth = (fillPercent.clamp(0.0, 100.0) / 100.0) * safeWidth;
    return SizedBox(
      width: safeWidth,
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
            )
          else
            Container(
              width: height,
              height: height,
              decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
