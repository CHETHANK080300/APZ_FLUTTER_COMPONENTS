import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'appz_modal_header_style_config.dart';
import '../appz_text/appz_text.dart';
import '../appz_image/appz_image.dart';
import '../appz_image/appz_assets.dart';

class AppzModalHeader extends StatelessWidget {
  final String title;
  final Widget? closeButton;
  final VoidCallback? onClose;

  const AppzModalHeader({
    super.key,
    required this.title,
    this.closeButton,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final config = AppzModalHeaderStyleConfig.instance;

    // Get dimensions and styling from config
    final width = config.getWidth();
    final padding = config.getPadding();
    final borderRadius = config.getBorderRadius();
    final borderWidth = config.getBorderWidth();
    final closeButtonIconSize = config.getCloseButtonIconSize();

    // Get colors from tokens
    final backgroundColor = config.getBackgroundColor();
    final borderColor = config.getBorderColor();
    final textColor = config.getTextColor();
    final iconColor = config.getIconColor();

    return Container(
      width: width,
      padding: padding,
      clipBehavior: Clip.antiAlias,
             decoration: BoxDecoration(
         color: backgroundColor,
         borderRadius: borderRadius,
         border: Border(
           bottom: BorderSide(
             width: borderWidth,
             color: borderColor,
           ),
         ),
       ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppzText(
                          title,
                          category: 'tableHeader',
                          fontWeight: 'bold',
                          color: textColor,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                if (closeButton != null || onClose != null)
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: closeButtonIconSize,
                      height: closeButtonIconSize,
                      child: closeButton ?? SvgPicture.asset(
                        AppzIcons.closeCircle1,
                        width: closeButtonIconSize,
                        height: closeButtonIconSize,
                        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 