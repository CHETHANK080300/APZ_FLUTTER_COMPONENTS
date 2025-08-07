import 'package:apz_flutter_components/components/appz_text/appz_text.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_components/components/appz_text/appz_text.dart';
import 'toggle_style_config.dart';

class AppzToggleController extends ChangeNotifier {
  bool _isToggled;
  bool _enabled;

  AppzToggleController({bool isToggled = false, bool enabled = true})
      : _isToggled = isToggled,
        _enabled = enabled;

  bool get isToggled => _isToggled;
  bool get enabled => _enabled;

  void setValue(bool value) {
    if (_isToggled != value) {
      _isToggled = value;
      notifyListeners();
    }
  }

  void toggle() {
    _isToggled = !_isToggled;
    notifyListeners();
  }

  void setEnabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      notifyListeners();
    }
  }

  void reset() {
    _isToggled = false;
    _enabled = true;
    notifyListeners();
  }
}

enum AppzToggleAppearance {
  primary,
  secondary,
  tertiary,
}

enum AppzToggleSize {
  small,
  large,
}

class AppzToggleSwitch extends StatefulWidget {
  final String label;
  final AppzToggleAppearance appearance;
  final AppzToggleSize size;
  final String? subtitle;
  final bool isToggled;
  final VoidCallback? onTap;
  final AppzToggleController?
      controller; // <-- Change type to AppzToggleController

  const AppzToggleSwitch({
    Key? key,
    required this.label,
    this.appearance = AppzToggleAppearance.primary,
    this.size = AppzToggleSize.large,
    this.subtitle,
    this.isToggled = false,
    this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  _AppzToggleSwitchState createState() => _AppzToggleSwitchState();
}

class _AppzToggleSwitchState extends State<AppzToggleSwitch> {
  bool _isToggled = false;
  bool _configLoaded = false;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.controller?.isToggled ?? widget.isToggled;
    _enabled = widget.controller?.enabled ?? true;
    _loadConfig();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AppzToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
      _isToggled = widget.controller?.isToggled ?? widget.isToggled;
      _enabled = widget.controller?.enabled ?? true;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {
        _isToggled = widget.controller?.isToggled ?? _isToggled;
        _enabled = widget.controller?.enabled ?? _enabled;
      });
    }
  }

  Future<void> _loadConfig() async {
    await ToggleStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }

    final config = ToggleStyleConfig.instance;
    final sizeVariant = widget.size == AppzToggleSize.small ? 'small' : 'large';

    final width = config.size('width', sizeVariant: sizeVariant);
    final height = config.size('height', sizeVariant: sizeVariant);
    final thumbSize = config.size('thumbSize', sizeVariant: sizeVariant);
    final padding = config.size('padding', sizeVariant: sizeVariant);

    final toggle = GestureDetector(
      onTap: _enabled
          ? () {
              if (widget.controller != null) {
                widget.controller!.toggle();
              } else {
                setState(() {
                  _isToggled = !_isToggled;
                });
              }
              if (widget.onTap != null) {
                widget.onTap!();
              }
            }
          : null,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color:
              _isToggled ? config.getActiveColor() : config.getInactiveColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Align(
          alignment: _isToggled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: ShapeDecoration(
              color: config.getThumbColor(),
              shape: const OvalBorder(),
              shadows: [
                const BoxShadow(
                  color: Color(0x0F101828),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                ),
                const BoxShadow(
                  color: Color(0x19101828),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );

    // Updated label and subtitle logic to match checkbox structure, but use toggle's own styles
    final bool hasLabel = widget.label.trim().isNotEmpty;
    final bool hasSubtitle =
        widget.subtitle != null && widget.subtitle!.trim().isNotEmpty;
    Widget? labelAndSubtitle;
    if (hasLabel && hasSubtitle) {
      labelAndSubtitle = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppzText(
            widget.label,
            category: 'label', // toggle's label style
            fontWeight: 'medium', // toggle's label style
          ),
          AppzText(
            widget.subtitle!,
            category: 'label', // toggle's subtitle style (as per original)
            fontWeight: 'regular', // toggle's subtitle style
          ),
        ],
      );
    } else if (hasLabel && !hasSubtitle) {
      labelAndSubtitle = AppzText(
        widget.label,
        category: 'label', // toggle's subtitle style (as per original)
        fontWeight: 'regular', // toggle's subtitle style
      );
    } else {
      labelAndSubtitle = null;
    }

    switch (widget.appearance) {
      case AppzToggleAppearance.primary:
        return Column(
          children: [
            if (labelAndSubtitle != null) labelAndSubtitle,
            const SizedBox(height: 8),
            toggle,
          ],
        );
      case AppzToggleAppearance.secondary:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (labelAndSubtitle != null) labelAndSubtitle,
            toggle,
          ],
        );
      case AppzToggleAppearance.tertiary:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            toggle,
            if (labelAndSubtitle != null) labelAndSubtitle,
          ],
        );
    }
  }
}
