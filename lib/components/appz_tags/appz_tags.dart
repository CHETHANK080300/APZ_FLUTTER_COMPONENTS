import 'package:flutter/material.dart';
import 'tags_style_config.dart';
import '../appz_text/appz_text.dart';
import '../appz_image/appz_image.dart';

enum AppzTagType {
  rounded,
  rectangle,
}

class AppzTags extends StatefulWidget {
  final String text;
  final AppzTagType type;
  final String? leadingIconPath;
  final String? trailingIconPath;
  final VoidCallback? onTap;

  const AppzTags({
    Key? key,
    required this.text,
    this.type = AppzTagType.rounded,
    this.leadingIconPath,
    this.trailingIconPath,
    this.onTap,
  }) : super(key: key);

  @override
  State<AppzTags> createState() => _AppzTagsState();
}

class _AppzTagsState extends State<AppzTags> {
  bool _configLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Widget _buildImage(String imagePath, double size) {
    return AppzImage(
      assetName: imagePath,
      size: AppzImageSize.square(size: size),
    );
  }

  Future<void> _loadConfig() async {
    await TagsStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }

    final config = TagsStyleConfig.instance;
    final sizes = config.sizes;
    final borderRadius = widget.type == AppzTagType.rounded 
        ? sizes['roundedBorderRadius']! 
        : sizes['rectangleBorderRadius']!;
    
    final backgroundColor = config.getBackgroundColor();
    final textColor = config.getTextColor();

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: sizes['height']!,
        padding: EdgeInsets.symmetric(
          horizontal: sizes['paddingHorizontal']!,
          vertical: sizes['paddingVertical']!,
        ),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading icon
            if (widget.leadingIconPath != null) ...[
              _buildImage(widget.leadingIconPath!, sizes['iconSize']!),
              SizedBox(width: sizes['iconSpacing']!),
            ],
            // Text
            AppzText(
              widget.text,
              category: 'paragraph',
              fontWeight: 'regular',
              color: textColor,
            ),
            // Trailing icon
            if (widget.trailingIconPath != null) ...[
              SizedBox(width: sizes['iconSpacing']!),
              _buildImage(widget.trailingIconPath!, sizes['iconSize']!),
            ],
          ],
        ),
      ),
    );
  }
} 