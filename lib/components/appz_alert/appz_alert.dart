import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'alert_style_config.dart';
import '../appz_text/appz_text.dart';
import '../appz_image/appz_image.dart';
import '../apz_button/appz_button.dart';

enum AppzAlertType {
  success,
  warning,
  error,
  info,
}

enum AppzAlertVariant {
  withIcon,
  withoutIcon,
}

class AppzAlert extends StatefulWidget {
  final String title;
  final String description;
  final AppzAlertType type;
  final AppzAlertVariant variant;
  final String? iconPath;
  final String? headerIconPath;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryButtonTap;
  final VoidCallback? onSecondaryButtonTap;
  final VoidCallback? onHeaderIconTap;

  const AppzAlert({
    Key? key,
    required this.title,
    required this.description,
    this.type = AppzAlertType.info,
    this.variant = AppzAlertVariant.withIcon,
    this.iconPath,
    this.headerIconPath,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryButtonTap,
    this.onSecondaryButtonTap,
    this.onHeaderIconTap,
  }) : super(key: key);

  @override
  State<AppzAlert> createState() => _AppzAlertState();
}

class _AppzAlertState extends State<AppzAlert> {
  bool _configLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    await AlertStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }

  String _getDefaultIconPath() {
    final config = AlertStyleConfig.instance;
    switch (widget.type) {
      case AppzAlertType.success:
        return config.getSuccessIconPath();
      case AppzAlertType.warning:
        return config.getWarningIconPath();
      case AppzAlertType.error:
        return config.getErrorIconPath();
      case AppzAlertType.info:
        return config.getInfoIconPath();
    }
  }

  String _getHeaderIconPath() {
    return widget.headerIconPath ?? AlertStyleConfig.instance.getCloseIconPath();
  }

  Widget _buildDefaultIcon(double size) {
    final config = AlertStyleConfig.instance;
    final defaultIconPath = widget.iconPath ?? _getDefaultIconPath();
    
    return SvgPicture.asset(
      defaultIconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        config.getIconColor(),
        BlendMode.srcIn,
      ),
    );
  }

  Color _getIconBackgroundColor() {
    final config = AlertStyleConfig.instance;
    switch (widget.type) {
      case AppzAlertType.success:
        return config.getSuccessIconBackgroundColor();
      case AppzAlertType.warning:
        return config.getWarningIconBackgroundColor();
      case AppzAlertType.error:
        return config.getErrorIconBackgroundColor();
      case AppzAlertType.info:
        return config.getInfoIconBackgroundColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }

    final config = AlertStyleConfig.instance;
    final boxShadows = config.boxShadow != null
        ? config.boxShadow!.map<BoxShadow>((shadow) {
            return BoxShadow(
              color: AlertStyleConfig.parseColor(shadow['color']),
              blurRadius: shadow['blurRadius'] ?? 0,
              offset: Offset(shadow['offsetX'] ?? 0, shadow['offsetY'] ?? 0),
              spreadRadius: shadow['spreadRadius'] ?? 0,
            );
          }).toList()
        : <BoxShadow>[];

    return Container(
      width: config.size('width'),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: config.getBackgroundColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.size('borderRadius')),
        ),
        shadows: boxShadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header section
          Container(
            width: config.size('width'),
            height: config.size('headerHeight'),
            padding: EdgeInsets.symmetric(
              horizontal: config.size('headerPaddingHorizontal'),
              vertical: config.size('headerPaddingVertical'),
            ),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: config.getBackgroundColor(),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: config.size('borderWidth'),
                  color: config.getBorderColor(),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(config.size('borderRadius')),
                  topRight: Radius.circular(config.size('borderRadius')),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppzText(
                    widget.title,
                    category: 'heading',
                    fontWeight: 'bold',
                    color: config.getTitleColor(),
                  ),
                ),
                Container(
                  width: config.size('closeIconSize'),
                  height: config.size('closeIconSize'),
                  child: GestureDetector(
                    onTap: widget.onHeaderIconTap,
                    child: AppzImage(
                      assetName: _getHeaderIconPath(),
                      size: AppzImageSize.square(size: config.size('closeIconSize')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(config.size('contentPadding')),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.variant == AppzAlertVariant.withIcon) ...[
                  Container(
                    width: config.size('iconContainerSize'),
                    height: config.size('iconContainerSize'),
                    decoration: BoxDecoration(
                      color: _getIconBackgroundColor(),
                      borderRadius: BorderRadius.circular(config.size('iconBorderRadius')),
                    ),
                    child: Center(
                      child: _buildDefaultIcon(config.size('iconSize')),
                    ),
                  ),
                  SizedBox(width: config.size('iconSpacing')),
                ],
                Expanded(
                  child: AppzText(
                    widget.description,
                    category: 'paragraph',
                    fontWeight: 'regular',
                    color: config.getDescriptionColor(),
                  ),
                ),
              ],
            ),
          ),
          // Button section
          if (widget.primaryButtonText != null || widget.secondaryButtonText != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(config.size('buttonContainerPadding')),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.primaryButtonText != null) ...[
                    Expanded(
                      child: AppzButton(
                        label: widget.primaryButtonText!,
                        appearance: AppzButtonAppearance.primary,
                        size: AppzButtonSize.medium,
                        onPressed: widget.onPrimaryButtonTap,
                      ),
                    ),
                    if (widget.secondaryButtonText != null)
                      SizedBox(width: config.size('buttonSpacing')),
                  ],
                  if (widget.secondaryButtonText != null) ...[
                    Expanded(
                      child: AppzButton(
                        label: widget.secondaryButtonText!,
                        appearance: AppzButtonAppearance.secondary,
                        size: AppzButtonSize.medium,
                        onPressed: widget.onSecondaryButtonTap,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
} 