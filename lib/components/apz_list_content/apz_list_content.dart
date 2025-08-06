import 'package:flutter/material.dart';
import 'apz_list_content_style_config.dart';
import '../appz_text/appz_text.dart';


enum ListContentType { sideBySide, twoLine, labelOnly, valueOnly }

class ApzListContent extends StatefulWidget {
  final ListContentType type;
  final String? label;
  final String? value;

  const ApzListContent({
    super.key,
    required this.type,
    this.label,
    this.value,
  });

  @override
  State<ApzListContent> createState() => _ApzListContentState();
}

class _ApzListContentState extends State<ApzListContent> {
  @override
  Widget build(BuildContext context) {
    final config = ApzListContentStyleConfig.instance;
    
    switch (widget.type) {
      case ListContentType.sideBySide:
        return _buildSideBySideLayout(config);
      case ListContentType.twoLine:
        return _buildTwoLineLayout(config);
      case ListContentType.labelOnly:
        return _buildLabelOnlyLayout(config);
      case ListContentType.valueOnly:
        return _buildValueOnlyLayout(config);
    }
  }

  Widget _buildSideBySideLayout(ApzListContentStyleConfig config) {
    final spacing = config.getSideBySideSpacing();
    final totalWidth = config.getSideBySideTotalWidth();
    final labelWidth = config.getSideBySideLabelWidth();
    
    return SizedBox(
      width: totalWidth,
      child: Row(
        children: [
          if (widget.label != null)
            SizedBox(
              width: labelWidth,
              child: AppzText(
                widget.label!,
                category: 'label',
                fontWeight: 'regular',
                color: config.getLabelColor(),
              ),
            ),
          if (widget.label != null && widget.value != null)
            SizedBox(width: spacing),
          if (widget.value != null)
            Expanded(
              child: _buildValueText(widget.value!, config),
            ),
        ],
      ),
    );
  }

  Widget _buildTwoLineLayout(ApzListContentStyleConfig config) {
    final spacing = config.getTwoLineSpacing();
    final width = config.getTwoLineWidth();
    
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            AppzText(
              widget.label!,
              category: 'label',
              fontWeight: 'regular',
              color: config.getLabelColor(),
            ),
          if (widget.label != null && widget.value != null)
            SizedBox(height: spacing),
          if (widget.value != null)
            _buildValueText(widget.value!, config),
        ],
      ),
    );
  }

  Widget _buildLabelOnlyLayout(ApzListContentStyleConfig config) {
    if (widget.label == null) return const SizedBox.shrink();
    
    return AppzText(
      widget.label!,
      category: 'label',
      fontWeight: 'regular',
      color: config.getLabelColor(),
    );
  }

  Widget _buildValueOnlyLayout(ApzListContentStyleConfig config) {
    if (widget.value == null) return const SizedBox.shrink();
    
    return _buildValueText(widget.value!, config);
  }

  Widget _buildValueText(String value, ApzListContentStyleConfig config) {
    // Use AppzText with Input/Medium styling and override color
    return AppzText(
      value,
      category: 'input',
      fontWeight: 'medium',
      color: config.getValueColor(),
    );
  }
} 