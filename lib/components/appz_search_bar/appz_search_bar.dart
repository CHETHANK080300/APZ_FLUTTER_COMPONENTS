import 'package:apz_flutter_components/components/appz_search_bar/appz_search_bar_style_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppzSearchBarSize { small, large }

enum AppzSearchBarState { enabled, hovered }

class AppzSearchBar<T> extends StatefulWidget {
  final AppzSearchBarSize size;
  final AppzSearchBarState state;
  final List<T> items;
  final String Function(T) labelSelector;
  final ValueChanged<List<T>> onFiltered;
  final String? hintText;
  final FocusNode? focusNode;
  final bool showTrailingIcon;
  final bool useWidget;
  final Widget? categoriesWidget;
  final List<String>? recommendations;
  final double? width;

  const AppzSearchBar({
    Key? key,
    this.size = AppzSearchBarSize.small,
    this.state = AppzSearchBarState.hovered,
    required this.items,
    required this.labelSelector,
    required this.onFiltered,
    this.hintText,
    this.focusNode,
    this.showTrailingIcon = false,
    this.useWidget = false,
    this.categoriesWidget,
    this.recommendations,
    this.width,
  }) : super(key: key);

  @override
  State<AppzSearchBar<T>> createState() => _AppzSearchBarState<T>();
}

class _AppzSearchBarState<T> extends State<AppzSearchBar<T>> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isHovered = false;
  bool _isFocused = false;
  // Track the current input for responsive updates
  String _currentInput = '';

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = TextEditingController();
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(() {
      _onSearchChanged();
      setState(() {
        _currentInput = _controller.text;
      });
    });
    // Initial callback with all items
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFiltered(widget.items);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    List<T> filtered;
    if (query.isEmpty) {
      filtered = widget.items;
    } else {
      filtered = widget.items
          .where((item) =>
              widget.labelSelector(item).toLowerCase().contains(query))
          .toList();
    }
    widget.onFiltered(filtered);
    print('Filtered list:');
    for (var item in filtered) {
      print(widget.labelSelector(item));
    }
  }

  String get _variant {
    if (widget.state == AppzSearchBarState.enabled &&
        widget.size == AppzSearchBarSize.small) {
      return 'enabled_small';
    } else if (widget.state == AppzSearchBarState.enabled &&
        widget.size == AppzSearchBarSize.large) {
      return 'enabled_large';
    } else if (widget.state == AppzSearchBarState.hovered &&
        widget.size == AppzSearchBarSize.small) {
      return 'hovered_small';
    } else {
      return 'hovered_large';
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppzSearchBarStyleConfig.instance;
    final hintText = widget.hintText ?? 'Search';
    final hintTextColor =
        (_isHovered && widget.state == AppzSearchBarState.hovered)
            ? config.getHoveredTextColor()
            : config.getTextColor();

    final showRecommendations = !widget.useWidget &&
        widget.recommendations != null &&
        _currentInput.isNotEmpty;

    // Filter recommendations based on input
    final filteredRecommendations = showRecommendations
        ? widget.recommendations!
            .where((rec) =>
                rec.toLowerCase().contains(_currentInput.toLowerCase()))
            .toList()
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Container(
            height: config.getHeight(_variant),
            width: widget.width ?? double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: config.getPaddingHorizontal(_variant),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: config.getBorderColor()),
              color: config.getBackgroundColor(),
              borderRadius:
                  BorderRadius.circular(config.getBorderRadius(_variant)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  config.searchIconAsset,
                  width: config.getIconSize(_variant),
                  height: config.getIconSize(_variant),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: (config.getHeight(_variant) -
                                      (config.getInputTextStyle().fontSize ??
                                          14)) /
                                  2 -
                              2),
                      hintText: _isFocused ? '' : hintText,
                      hintStyle: config.getInputTextStyle().copyWith(
                            color: hintTextColor,
                          ),
                      border: InputBorder.none,
                    ),
                    style: config.getInputTextStyle(),
                  ),
                ),
                if (widget.showTrailingIcon) ...[
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    config.microphoneIconAsset,
                    width: config.getIconSize(_variant),
                    height: config.getIconSize(_variant),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (widget.useWidget && widget.categoriesWidget != null)
          Expanded(child: widget.categoriesWidget!)
        else if (showRecommendations)
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecommendations.length,
              itemBuilder: (context, index) {
                final rec = filteredRecommendations[index];
                return ListTile(
                  title: Text(rec),
                  onTap: () {
                    _controller.text = rec;
                    _onSearchChanged();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
