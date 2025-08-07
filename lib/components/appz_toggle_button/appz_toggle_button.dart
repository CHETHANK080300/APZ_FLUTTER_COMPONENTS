/*import 'package:apz_flutter_components/components/appz_text/appz_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_components/components/appz_text/appz_text.dart';
import 'toggle_button_style_config.dart';
 
enum AppzToggleButtonAppearance {
  primary,
  secondary,
}
 
enum AppzToggleButtonSize {
  small,
  large,
}
 
class AppzToggleButton extends StatefulWidget {
  final String label;
  final AppzToggleButtonAppearance appearance;
  final AppzToggleButtonSize size;
  final String? subtitle;
  final bool isToggled;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final List<String> options;
 
  const AppzToggleButton({
    Key? key,
    required this.label,
    this.appearance = AppzToggleButtonAppearance.primary,
    this.size = AppzToggleButtonSize.large,
    this.subtitle,
    this.isToggled = false,
    this.onTap,
    this.controller,
    required this.options,
  }) : super(key: key);
 
  @override
  _AppzToggleButtonState createState() => _AppzToggleButtonState();
}
 
class _AppzToggleButtonState extends State<AppzToggleButton> {
  int _selectedIndex = 0;
  bool _configLoaded = false;
 
  @override
  void initState() {
    super.initState();
    _loadConfig();
  }
 
  Future<void> _loadConfig() async {
    await ToggleButtonStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }
 
  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }
 
    final config = ToggleButtonStyleConfig.instance;
    final sizeVariant = widget.size == AppzToggleButtonSize.small ? 'small' : 'large';
 
    final labelAndSubtitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppzText(
          widget.label,
          category: 'label',
          fontWeight: 'medium',
        ),
        if (widget.subtitle != null)
          AppzText(
            widget.subtitle!,
            category: 'label',
            fontWeight: 'regular',
          ),
      ],
    );
 
    final toggleButtons = Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: config.getInactiveColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.getBorderRadius()),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.options.length, (index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: config.getPadding(sizeVariant),
              decoration: ShapeDecoration(
                color: isSelected ? config.getActiveColor() : config.getInactiveColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(config.getBorderRadius()),
                ),
              ),
              child: AppzText(
                widget.options[index],
                category: 'button',
                fontWeight: 'semibold',
                color: isSelected ? config.getActiveTextColor() : config.getInactiveTextColor(),
              ),
            ),
          );
        }),
      ),
    );
 
    switch (widget.appearance) {
      case AppzToggleButtonAppearance.primary:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelAndSubtitle,
            const SizedBox(height: 8),
            toggleButtons,
          ],
        );
      case AppzToggleButtonAppearance.secondary:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            labelAndSubtitle,
            toggleButtons,
          ],
        );
    }
  }
}*/
import 'package:apz_flutter_components/components/appz_text/appz_text.dart';
import 'package:flutter/material.dart';
import 'toggle_button_style_config.dart';

enum AppzToggleButtonAppearance {
  primary,
  secondary,
}

enum AppzToggleButtonSize {
  small,
  large,
}

class AppzToggleButton extends StatefulWidget {
  final String label;
  final AppzToggleButtonAppearance appearance;
  final AppzToggleButtonSize size;
  final String? subtitle;
  final bool isToggled;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final List<String> options;

  const AppzToggleButton({
    Key? key,
    required this.label,
    this.appearance = AppzToggleButtonAppearance.primary,
    this.size = AppzToggleButtonSize.large,
    this.subtitle,
    this.isToggled = false,
    this.onTap,
    this.controller,
    required this.options,
  }) : super(key: key);

  @override
  _AppzToggleButtonState createState() => _AppzToggleButtonState();
}

class _AppzToggleButtonState extends State<AppzToggleButton> {
  int _selectedIndex = 0;
  bool _configLoaded = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.isToggled ? 1 : 0;
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    await ToggleButtonStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }

    final config = ToggleButtonStyleConfig.instance;
    final sizeVariant = widget.size == AppzToggleButtonSize.small ? 'small' : 'large';

    final labelAndSubtitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppzText(
          widget.label,
          category: 'label',
          fontWeight: 'medium',
          color: config.getInactiveTextColor(),
        ),
        if (widget.subtitle != null)
          AppzText(
            widget.subtitle!,
            category: 'label',
            fontWeight: 'regular',
          ),
      ],
    );

    final toggleButtons = Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: config.getInactiveColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.getBorderRadius()),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0F101828),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x19101828),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.options.length, (index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: config.getPadding(sizeVariant),
              decoration: ShapeDecoration(
                color: isSelected ? config.getActiveColor() : config.getInactiveColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(config.getBorderRadius()),
                ),
              ),
              child: AppzText(
                widget.options[index],
                category: 'button',
                fontWeight: 'semibold',
                color: isSelected ? config.getActiveTextColor() : config.getInactiveTextColor(),
              ),
            ),
          );
        }),
      ),
    );

    switch (widget.appearance) {
      case AppzToggleButtonAppearance.primary:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelAndSubtitle,
            const SizedBox(height: 8),
            toggleButtons,
          ],
        );
      case AppzToggleButtonAppearance.secondary:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            labelAndSubtitle,
            toggleButtons,
          ],
        );
    }
  }
}