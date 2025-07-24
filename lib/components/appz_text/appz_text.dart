import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'appz_text_style_config.dart';

class AppzText extends StatefulWidget {
  final String content;
  final String category;
  final String fontWeight;
  final String? url; // Optional URL for hyperlink
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppzText(
    this.content, {
    Key? key,
    required this.category,
    required this.fontWeight,
    this.url,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  State<AppzText> createState() => _AppzTextState();
}

class _AppzTextState extends State<AppzText> {
  bool _hovering = false;

  double _nextFontSize(double current) {
    // Increase font size by 2 for hover effect (customize as needed)
    return current + 1;
  }

  @override
  Widget build(BuildContext context) {
    final style = AppzTextStyleConfig.instance.getTextStyle(
      category: widget.category,
      fontWeight: widget.fontWeight,
    );

    TextStyle effectiveStyle = style;
    if (widget.category == 'hyperlink' && widget.url != null) {
      effectiveStyle = effectiveStyle.copyWith(
        color: Colors.blue,
        fontSize: _hovering && style.fontSize != null ? _nextFontSize(style.fontSize!) : style.fontSize,
        decoration: TextDecoration.none,
      );
    }

    Widget textWidget = Text(
      widget.content,
      style: effectiveStyle,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );

    // If it's a hyperlink and url is provided, wrap with GestureDetector and MouseRegion
    if (widget.category == 'hyperlink' && widget.url != null) {
      textWidget = MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(widget.url!);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: textWidget,
          ),
        ),
      );
    }

    return textWidget;
  }
} 