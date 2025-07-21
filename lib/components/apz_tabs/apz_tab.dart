import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/apz_tabs/apz_tab_enums.dart';
import 'package:apz_flutter_components/components/apz_tabs/apz_tab_style_config.dart';


class AppzTabBar extends StatefulWidget {
  final List<String> tabs;
  final int? selectedIndex;
  final ValueChanged<int>? onTabChanged;
  final SelectionMode? isScrollable;
  final SelectionMode? isEnabled;
  final TabBarDirection? tabDirection;

  const AppzTabBar({
    super.key,
    required this.tabs,
    this.selectedIndex,
    this.onTabChanged,
    this.isScrollable,
    this.isEnabled,
    this.tabDirection,
  });

  @override
  State<AppzTabBar> createState() => _AppzTabBarState();
}

class _AppzTabBarState extends State<AppzTabBar> {
  late int _currentIndex;
  late final TabStyleConfig _effectiveConfig;
  late final Axis _direction;
  late final bool _isEnabled;
  late final bool _isScrollable;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex ?? 0;
    _effectiveConfig = TabStyleConfig.instance;
    _direction = widget.tabDirection?.axis ?? Axis.horizontal;
    _isEnabled = widget.isEnabled?.value ?? true;
    _isScrollable = widget.isScrollable?.value ?? true;
  }

  @override
  void didUpdateWidget(AppzTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != null && widget.selectedIndex != _currentIndex) {
      setState(() {
        _currentIndex = widget.selectedIndex!;
      });
    }
  }

  void _onTabTapped(int index) {
    if (!_isEnabled) return;
    setState(() {
      _currentIndex = index;
    });
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal = _direction == Axis.horizontal;
    return isHorizontal
      ? Container(
          decoration: _effectiveConfig.containerDecoration,
          padding: _effectiveConfig.tabPadding,
          child: _isScrollable
              ? SingleChildScrollView(
                  scrollDirection: _direction,
                  child: Row(children: _buildTabs()),
                )
              : Wrap(
                  spacing: _effectiveConfig.tabSpacing,
                  runSpacing: _effectiveConfig.tabSpacing,
                  children: _buildTabs(),
                ),
        )
      : Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: _effectiveConfig.containerDecoration,
            padding: _effectiveConfig.tabPadding,
            child: _isScrollable
                ? ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    scrollDirection: _direction,
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildTabs(),
                      ),
                    ),
                  ),
                )
                : Wrap(
                    direction: Axis.vertical,
                    spacing: _effectiveConfig.tabSpacing,
                    runSpacing: _effectiveConfig.tabSpacing,
                    children: _buildTabs(),
                  ),
          ),
        );
  }

  List<Widget> _buildTabs() {
    final bool isHorizontal = _direction == Axis.horizontal;

    return List.generate(widget.tabs.length, (index) {
      final bool isActive = index == _currentIndex;
      final style = isActive
          ? _effectiveConfig.activeTextStyle
          : _effectiveConfig.defaultTextStyle;

      final EdgeInsets tabMargin = isHorizontal
          ? EdgeInsets.only(
              right: index < widget.tabs.length - 1
                  ? _effectiveConfig.tabSpacing
                  : 0,
            )
          : EdgeInsets.only(
              bottom: index < widget.tabs.length - 1
                  ? _effectiveConfig.tabSpacing
                  : 0,
            );

      return Padding(
        padding: tabMargin,
        child: InkWell(
          onTap: () => _onTabTapped(index),
          child: Container(
            padding: _effectiveConfig.tabPadding,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive
                      ? _effectiveConfig.activeBorderColor
                      : Colors.transparent,
                  width: isActive ? _effectiveConfig.activeBorderWidth : 0.0,
                ),
              ),
            ),
            child: Text(widget.tabs[index], style: style),
          ),
        ),
      );
    });
  }
}
