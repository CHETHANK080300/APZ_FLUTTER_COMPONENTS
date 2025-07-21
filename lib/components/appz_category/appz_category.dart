import 'package:flutter/material.dart';
import 'appz_category_style_config.dart';
import 'model/category_model.dart';

class AppzCategory extends StatefulWidget {
  final ValueNotifier<List<CategoryItem>> itemsNotifier;
  final Axis direction;
  final ValueNotifier<String?> selectedIdNotifier;
  final Function(CategoryItem) onItemTap;

  const AppzCategory({
    super.key,
    required this.itemsNotifier,
    required this.selectedIdNotifier,
    required this.direction,
    required this.onItemTap,
  });

  @override
  State<AppzCategory> createState() => _AppzCategoryState();
}

class _AppzCategoryState extends State<AppzCategory> {
  final hoveredIds = <String>{};
  late AppzCategoryStyleConfig styleCfg;

  @override
  void initState() {
    super.initState();
    styleCfg = AppzCategoryStyleConfig.instance;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CategoryItem>>(
      valueListenable: widget.itemsNotifier,
      builder: (_, items, __) {
        return SingleChildScrollView(
          scrollDirection: widget.direction,
          child: widget.direction == Axis.horizontal
              ? Row(children: _buildItems(items))
              : Column(children: _buildItems(items)),
        );
      },
    );
  }

  /*List<Widget> _buildItems(List<CategoryItem> items) {
    return items.map((item) {
      final isSelected = widget.selectedIdNotifier.value == item.id;
      final isHovered = hoveredIds.contains(item.id);

      final baseStyle = isSelected
          ? styleCfg.selectedStyle
          : styleCfg.defaultStyle;

      final backgroundColor = isHovered && !isSelected
          ? baseStyle.hoverBackgroundColor ?? baseStyle.backgroundColor
          : baseStyle.backgroundColor;

      final child = Container(
        width: widget.direction == Axis.horizontal ? baseStyle.itemWidth : null,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(baseStyle.borderRadius),
          border: Border.all(
            color: baseStyle.borderColor ?? Colors.transparent,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: baseStyle.elevation,
            ),
          ],
        ),
        child: widget.direction == Axis.horizontal
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(item.iconAsset, height: baseStyle.iconSize),
                  const SizedBox(height: 8),
                  Text(item.label, style: baseStyle.textStyle),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(item.iconAsset, height: baseStyle.iconSize),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: baseStyle.textStyle,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
      );

      return MouseRegion(
        onEnter: (_) => setState(() => hoveredIds.add(item.id)),
        onExit: (_) => setState(() => hoveredIds.remove(item.id)),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: widget.direction == Axis.horizontal
                ? baseStyle.itemSpacing / 2
                : 0,
            vertical: baseStyle.itemSpacing / 2,
          ),
          padding: widget.direction == Axis.vertical
              ? EdgeInsets.symmetric(horizontal: baseStyle.itemSpacing)
              : EdgeInsets.zero,
          width: widget.direction == Axis.vertical
              ? double.infinity
              : null,
          child: child,
        ),
      );
    }).toList();
  }*/
  List<Widget> _buildItems(List<CategoryItem> items) {
    return items.map((item) {
      final isSelected = widget.selectedIdNotifier.value == item.id;
      final isHovered = hoveredIds.contains(item.id);

      final style = isSelected
          ? styleCfg.selectedStyle
          : styleCfg.defaultStyle;

      // Handle hover background only if not selected
      final backgroundColor = isHovered && !isSelected
          ? style.hoverBackgroundColor ?? style.backgroundColor
          : style.backgroundColor;

      final borderColor = isSelected
          ? styleCfg.selectedStyle.borderColor ?? Colors.transparent
          : style.borderColor ?? Colors.transparent;

      final child = Container(
        width: widget.direction == Axis.horizontal ? style.itemWidth : null,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(style.borderRadius),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: style.elevation,
            ),
          ],
        ),
        child: widget.direction == Axis.horizontal
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(item.iconAsset, height: style.iconSize),
                  const SizedBox(height: 8),
                  Text(item.label, style: style.textStyle),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(item.iconAsset, height: style.iconSize),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: style.textStyle,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
      );

      return MouseRegion(
        onEnter: (_) => setState(() => hoveredIds.add(item.id)),
        onExit: (_) => setState(() => hoveredIds.remove(item.id)),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: widget.direction == Axis.horizontal
                ? style.itemSpacing / 2
                : 0,
            vertical: style.itemSpacing / 2,
          ),
          padding: widget.direction == Axis.vertical
              ? EdgeInsets.symmetric(horizontal: style.itemSpacing)
              : EdgeInsets.zero,
          width: widget.direction == Axis.vertical ? double.infinity : null,
          child: GestureDetector(
            onTap: () {
              widget.selectedIdNotifier.value = item.id;
              widget.onItemTap(item);
            },
            child: child,
          ),
        ),
      );
    }).toList();
  }
}
/*import 'package:flutter/material.dart';
import 'appz_category_style_config.dart';
import 'model/category_model.dart';

class AppzCategory extends StatefulWidget {
  final ValueNotifier<List<CategoryItem>> itemsNotifier;
  final Axis direction;
  final ValueNotifier<String?> selectedIdNotifier;
  final Function(CategoryItem) onItemTap;

  const AppzCategory({
    super.key,
    required this.itemsNotifier,
    required this.selectedIdNotifier,
    required this.direction,
    required this.onItemTap,
  });

  @override
  State<AppzCategory> createState() => _AppzCategoryState();
}

class _AppzCategoryState extends State<AppzCategory> {
  final hoveredIds = <String>{};
  late AppzCategoryStyleConfig styleCfg;

  @override
  void initState() {
    super.initState();
    styleCfg = AppzCategoryStyleConfig.instance;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CategoryItem>>(
      valueListenable: widget.itemsNotifier,
      builder: (_, items, __) {
        return SingleChildScrollView(
          scrollDirection: widget.direction,
          child: widget.direction == Axis.horizontal
              ? Row(children: _buildItems(items))
              : Column(children: _buildItems(items)),
        );
      },
    );
  }

  List<Widget> _buildItems(List<CategoryItem> items) {
    return items.map((item) {
      final isSelected = widget.selectedIdNotifier.value == item.id;
      final isHovered = hoveredIds.contains(item.id);

      final baseStyle = isSelected
          ? styleCfg.selectedStyle
          : styleCfg.defaultStyle;

      final backgroundColor = isHovered && !isSelected
          ? baseStyle.hoverBackgroundColor ?? baseStyle.backgroundColor
          : baseStyle.backgroundColor;

      return MouseRegion(
        onEnter: (_) => setState(() => hoveredIds.add(item.id)),
        onExit: (_) => setState(() => hoveredIds.remove(item.id)),
        child: GestureDetector(
          onTap: () {
            widget.selectedIdNotifier.value = item.id;
            widget.onItemTap(item);
          },
          child: Container(
            width: widget.direction == Axis.horizontal
                ? baseStyle.itemWidth
                : null, // auto width for vertical
            margin: EdgeInsets.symmetric(
              horizontal: baseStyle.itemSpacing / 2,
              vertical: baseStyle.itemSpacing / 2,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(baseStyle.borderRadius),
              border: Border.all(
                color: baseStyle.borderColor ?? Colors.transparent,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: baseStyle.elevation,
                ),
              ],
            ),
            child: widget.direction == Axis.horizontal
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(item.iconAsset, height: baseStyle.iconSize),
                      const SizedBox(height: 8),
                      Text(item.label, style: baseStyle.textStyle),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(item.iconAsset, height: baseStyle.iconSize),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          item.label,
                          style: baseStyle.textStyle,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    }).toList();
  }
}*/