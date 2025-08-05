import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'appz_image_style.dart';

/// Size configuration for AppzImage
class AppzImageSize {
  final double? width;
  final double? height;
  final double? cornerRadius;
  final String _type; // 'circular', 'square', 'rectangle'

  const AppzImageSize({
    this.width,
    this.height,
    this.cornerRadius,
    String? type,
  }) : _type = type ?? 'rectangle';

  /// Factory constructor for circular appearance
  const AppzImageSize.circular({
    double? size,
    double? cornerRadius,
  }) : width = size,
       height = size,
       cornerRadius = cornerRadius,
       _type = 'circular';

  /// Factory constructor for square appearance
  const AppzImageSize.square({
    double? size,
    double? cornerRadius,
  }) : width = size,
       height = size,
       cornerRadius = cornerRadius,
       _type = 'square';

  /// Factory constructor for rectangle appearance
  const AppzImageSize.rectangle({
    double? width,
    double? height,
    double? cornerRadius,
  }) : width = width,
       height = height,
       cornerRadius = cornerRadius,
       _type = 'rectangle';

  /// Get the appearance type based on the size configuration
  String get appearanceType => _type;
}

/// Usage:
/// AppzImage.asset(
///   'your_asset_name',
///   size: AppzImageSize.square(size: 40), // determines appearance automatically
/// )
class AppzImage extends StatefulWidget {
  final String assetName;
  final AppzImageSize? size;

  /// assetName should be either:
  /// - An icon path from AppzIcons (e.g., AppzIcons.address, AppzIcons.search, etc.) - automatically detected as icon
  /// - A path to an image in assets (e.g., 'assets/images/photo.png') - automatically detected as image
  /// The component automatically detects if it's an icon or image based on the asset path
  const AppzImage({
    Key? key,
    required this.assetName,
    this.size,
  }) : super(key: key);

  @override
  State<AppzImage> createState() => _AppzImageState();
}

class _AppzImageState extends State<AppzImage> {
  late final AppzImageStyleConfig _styleConfig;
  bool _styleLoaded = false;

  @override
  void initState() {
    super.initState();
    _styleConfig = AppzImageStyleConfig.instance;
    _loadStyle();
  }

  Future<void> _loadStyle() async {
    await _styleConfig.load();
    if (mounted) {
      setState(() {
        _styleLoaded = true;
      });
    }
  }

  Widget _buildAsset({
    required String assetPath,
    required double width,
    required double height,
    required double borderRadius,
    required bool isSvg,
  }) {
    final Widget imageWidget = isSvg
        ? SvgPicture.asset(
            assetPath,
            width: width,
            height: height,
            fit: BoxFit.cover,
          )
        : Image.asset(
            assetPath,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
    
    Widget result = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageWidget,
    );
    
    // Add fixed padding for icons (2 pixels from JSON config)
    if (_isIcon()) {
      final double padding = _styleConfig.getIconPadding();
      if (padding > 0) {
        result = Padding(
          padding: EdgeInsets.all(padding),
          child: result,
        );
      }
    }
    
    return result;
  }

  bool _isIcon() {
    // Automatically detect if it's an icon based on asset path
    return widget.assetName.startsWith('assets/icons/');
  }

  String _getAppearanceType() {
    if (_isIcon()) {
      // Icons are restricted to square shape only
      return 'square';
    }
    
    if (widget.size != null) {
      return widget.size!.appearanceType;
    }
    // Default to rectangle if no size is specified
    return 'rectangle';
  }

  double _getBorderRadius() {
    if (_isIcon()) {
      // Icons ignore developer-provided corner radius and always use JSON value (0)
      return _styleConfig.getIconCornerRadius('square');
    }
    
    final String appearanceType = _getAppearanceType();
    
    // Use custom corner radius if provided in AppzImageSize
    if (widget.size?.cornerRadius != null) {
      return widget.size!.cornerRadius!;
    }
    
    // Use default from style config (JSON values)
    final double jsonValue = _styleConfig.getImageCornerRadius(appearanceType);
    
    return jsonValue;
  }

  double _getWidth() {
    final String appearanceType = _getAppearanceType();
    if (_isIcon()) {
      // Icons can have custom size, fallback to appearance-specific default
      return widget.size?.width ?? _styleConfig.getIconWidth(appearanceType);
    } else {
      // Images can have custom size, fallback to appearance-specific default
      return widget.size?.width ?? _styleConfig.getImageWidth(appearanceType);
    }
  }

  double _getHeight() {
    final String appearanceType = _getAppearanceType();
    if (_isIcon()) {
      // Icons can have custom size, fallback to appearance-specific default
      return widget.size?.height ?? _styleConfig.getIconHeight(appearanceType);
    } else {
      // Images can have custom size, fallback to appearance-specific default
      return widget.size?.height ?? _styleConfig.getImageHeight(appearanceType);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_styleLoaded) {
      return const SizedBox.shrink();
    }

    final double borderRadius = _getBorderRadius();
    final double width = _getWidth();
    final double height = _getHeight();
    final bool isSvg = widget.assetName.toLowerCase().endsWith('.svg');

    return _buildAsset(
      assetPath: widget.assetName,
      width: width,
      height: height,
      borderRadius: borderRadius,
      isSvg: isSvg,
    );
  }
}
