import 'dart:async';
import 'package:flutter/material.dart';
import 'tooltip_style_config.dart';
import '../apz_button/appz_button.dart';
import '../appz_text/appz_text.dart';

enum AppzTooltipType {
  withSupportingMsg,
  withoutSupportingMsg,
}

enum AppzTooltipPosition {
  top,
  down,
  left,
  right,
}

enum AppzTooltipTriggerType {
  click,
  hover,
}

class TooltipOverlayManager {
  static OverlayEntry? _currentEntry;

  static void show(BuildContext context, OverlayEntry entry) {
    hide();
    Overlay.of(context).insert(entry);
    _currentEntry = entry;
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class AppzTooltip extends StatefulWidget {
  final Widget child;
  final AppzTooltipType type;
  final String message;
  final String? supportingText;
  final String? linkText;
  final VoidCallback? onLinkTap;
  final AppzTooltipPosition position;
  final AppzTooltipTriggerType triggerType;

  const AppzTooltip({
    Key? key,
    required this.child,
    required this.type,
    required this.message,
    this.supportingText,
    this.linkText,
    this.onLinkTap,
    this.position = AppzTooltipPosition.top,
    this.triggerType = AppzTooltipTriggerType.hover,
  }) : super(key: key);

  @override
  State<AppzTooltip> createState() => _AppzTooltipState();
}

class _AppzTooltipState extends State<AppzTooltip> {
  bool _configLoaded = false;
  Timer? _hideTimer;
  OverlayEntry? _currentEntry;
  final GlobalKey _tooltipKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    await TooltipStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }

  Offset _calculateTooltipOffset({
    required Offset targetCenter,
    required Size targetSize,
    required Size tooltipSize,
    required Size screenSize,
    required double horizontalOffset,
    required AppzTooltipPosition position,
  }) {
    Offset clampOffset(Offset offset) {
      double dx = offset.dx;
      double dy = offset.dy;
      if (dx < 0) dx = 0;
      if (dx + tooltipSize.width > screenSize.width) dx = screenSize.width - tooltipSize.width;
      if (dy < 0) dy = 0;
      if (dy + tooltipSize.height > screenSize.height) dy = screenSize.height - tooltipSize.height;
      return Offset(dx, dy);
    }
    switch (position) {
      case AppzTooltipPosition.left:
      case AppzTooltipPosition.right: {
        final Offset right = Offset(
          targetCenter.dx + targetSize.width / 2 + horizontalOffset,
          targetCenter.dy - tooltipSize.height / 2,
        );
        final Offset left = Offset(
          targetCenter.dx - targetSize.width / 2 - horizontalOffset - tooltipSize.width,
          targetCenter.dy - tooltipSize.height / 2,
        );
        final bool fitsRight = right.dx + tooltipSize.width <= screenSize.width;
        final bool fitsLeft = left.dx >= 0;
        return position == AppzTooltipPosition.right
            ? (fitsRight ? right : (fitsLeft ? left : clampOffset(right)))
            : (fitsLeft ? left : (fitsRight ? right : clampOffset(left)));
      }
      case AppzTooltipPosition.top:
      case AppzTooltipPosition.down: {
        final Offset below = Offset(
          targetCenter.dx - tooltipSize.width / 2,
          targetCenter.dy + targetSize.height / 2 + horizontalOffset,
        );
        final Offset above = Offset(
          targetCenter.dx - tooltipSize.width / 2,
          targetCenter.dy - targetSize.height / 2 - horizontalOffset - tooltipSize.height,
        );
        final bool fitsBelow = below.dy + tooltipSize.height <= screenSize.height;
        final bool fitsAbove = above.dy >= 0;
        return position == AppzTooltipPosition.down
            ? (fitsBelow ? below : (fitsAbove ? above : clampOffset(below)))
            : (fitsAbove ? above : (fitsBelow ? below : clampOffset(above)));
      }
    }
  }

  void _showTooltip() {
    if (!_configLoaded) return;
    final config = TooltipStyleConfig.instance;
    final renderBox = context.findRenderObject() as RenderBox;
    final Size targetSize = renderBox.size;
    final Offset targetCenter = renderBox.localToGlobal(targetSize.center(Offset.zero));
    final screenSize = MediaQuery.of(context).size;
    final double horizontalGap = 8.0;

    void insertOverlay([Size? measuredTooltipSize]) {
      Size tooltipSize = measuredTooltipSize ?? Size(config.size('maxWidth'), 40.0);
      final Offset tooltipOffset = _calculateTooltipOffset(
        targetCenter: targetCenter,
        targetSize: targetSize,
        tooltipSize: tooltipSize,
        screenSize: screenSize,
        horizontalOffset: horizontalGap,
        position: widget.position,
      );
      final entry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            // Only for click trigger: tap outside to dismiss
            if (widget.triggerType == AppzTooltipTriggerType.click)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    TooltipOverlayManager.hide();
                    _currentEntry = null;
                  },
                ),
              ),
            Positioned(
              left: tooltipOffset.dx,
              top: tooltipOffset.dy,
              child: MouseRegion(
                onEnter: (_) => _cancelHide(),
                onExit: (_) => _hideTooltip(),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    key: _tooltipKey,
                    child: _buildTooltipContent(config),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      TooltipOverlayManager.show(context, entry);
      _currentEntry = entry;
    }

    insertOverlay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tooltipBox = _tooltipKey.currentContext?.findRenderObject() as RenderBox?;
      if (tooltipBox != null) {
        final actualTooltipSize = tooltipBox.size;
        TooltipOverlayManager.hide();
        insertOverlay(actualTooltipSize);
      }
    });
  }

  void _hideTooltip() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 150), () {
      TooltipOverlayManager.hide();
    });
  }

  void _cancelHide() {
    _hideTimer?.cancel();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  Widget _buildTooltipContent(TooltipStyleConfig config) {
    final isWithSupporting = widget.type == AppzTooltipType.withSupportingMsg;
    final double paddingHorizontal = isWithSupporting
        ? config.size('paddingHorizontal')
        : config.size('noSupportingPaddingHorizontal');
    final double paddingVertical = isWithSupporting
        ? config.size('paddingVertical')
        : config.size('noSupportingPaddingVertical');
    final double borderRadius = isWithSupporting ? config.getOuterBorderRadius() : config.borderRadius;
    final List<BoxShadow> boxShadows = config.boxShadow != null
        ? config.boxShadow!.map((shadow) {
            return BoxShadow(
              color: TooltipStyleConfig.parseColor(shadow['color']),
              blurRadius: shadow['blurRadius'] ?? 16,
              offset: Offset(shadow['offsetX'] ?? 0, shadow['offsetY'] ?? 4),
              spreadRadius: shadow['spreadRadius'] ?? 0,
            );
          }).toList()
        : [];
    final children = <Widget>[];
    children.add(
      AppzText(
        widget.message,
        category: 'tooltipstyle2',
        fontWeight: 'semibold',
        maxLines: null,
        overflow: null,
      ),
    );
    if (isWithSupporting && widget.supportingText != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: config.size('verticalSpacing')),
          child: AppzText(
            widget.supportingText!,
            category: 'label',
            fontWeight: 'regular',
            maxLines: null,
            overflow: null,
          ),
        ),
      );
    }
    if (widget.linkText != null) {
      children.add(
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: config.size('verticalSpacing')),
            child: AppzButton(
              label: widget.linkText!,
              onPressed: () {
                if (widget.onLinkTap != null) {
                  widget.onLinkTap!();
                }
              },
              appearance: AppzButtonAppearance.tertiary,
              size: AppzButtonSize.small,
            ),
          ),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: isWithSupporting ? BoxConstraints(maxWidth: config.size('maxWidth')) : null,
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        decoration: BoxDecoration(
          color: config.color('backgroundColor'),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: boxShadows,
        ),
        child: Column(
          crossAxisAlignment: isWithSupporting ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.triggerType == AppzTooltipTriggerType.hover) {
      return MouseRegion(
        onEnter: (_) => _showTooltip(),
        onExit: (_) => _hideTooltip(),
        child: GestureDetector(
          onLongPress: _showTooltip,
          onLongPressEnd: (_) => _hideTooltip(),
          child: widget.child,
        ),
      );
    } else {
      // Click trigger
      return GestureDetector(
        onTap: () {
          if (_currentEntry == null) {
            _showTooltip();
          } else {
            TooltipOverlayManager.hide();
            _currentEntry = null;
          }
        },
        child: widget.child,
      );
    }
  }
} 