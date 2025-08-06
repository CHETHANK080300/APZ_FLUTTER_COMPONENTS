import 'package:apz_flutter_components/components/appz_text/appz_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'appz_category_style_config.dart';
import 'model/category_model.dart';

// Custom ScrollBehavior to remove scrollbars
class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class AppzCategory extends StatefulWidget {
  final ValueNotifier<List<CategoryItem>> itemsNotifier;
  final Axis direction;
  final ValueNotifier<String?> selectedIdNotifier;
  final Function(CategoryItem) onItemTap;
  final double edgePadding; // For horizontal layout

  const AppzCategory({
    super.key,
    required this.itemsNotifier,
    required this.selectedIdNotifier,
    required this.direction,
    required this.onItemTap,
    this.edgePadding = 0.0,
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
        if (widget.direction == Axis.horizontal) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _buildItems(items),
              ),
            ),
          );
        } else {
          // For vertical, use Flexible if in a Column, otherwise scroll
          return LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight,
                ),
                child: ScrollConfiguration(
                  behavior: NoScrollbarBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildItems(items),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  List<Widget> _buildItems(List<CategoryItem> items) {
    final selectedIndex = items.indexWhere((i) => i.id == widget.selectedIdNotifier.value);

    return List.generate(items.length, (index) {
      final item = items[index];
      final isSelected = widget.selectedIdNotifier.value == item.id;
      final isHovered = hoveredIds.contains(item.id);
      final style = styleCfg.defaultStyle;

      // Use hover background color for selected or hovered (if not selected)
      Color backgroundColor;
      if (widget.direction == Axis.vertical) {
        if (isSelected || isHovered) {
          backgroundColor = style.backgroundColor;
        } else {
          backgroundColor = style.hoverBackgroundColor ?? style.backgroundColor;
        }
      } else {
        // Existing logic for horizontal
        backgroundColor = (isSelected || (isHovered && !isSelected))
            ? style.hoverBackgroundColor ?? style.backgroundColor
            : style.backgroundColor;
      }

      // Border radius logic for vertical layout (only above/below selected)
      BorderRadius borderRadius = BorderRadius.zero;
      if (widget.direction == Axis.vertical) {
        final selectedIndex = items.indexWhere((i) => i.id == widget.selectedIdNotifier.value);
        final radius = Radius.circular(style.borderRadius);
        if (index == selectedIndex - 1) {
          // Item above selected
          borderRadius = BorderRadius.only(
            bottomRight: radius,
            topLeft: index == 0 ? radius : Radius.zero,
          );
        } else if (index == selectedIndex + 1) {
          // Item below selected
          borderRadius = BorderRadius.only(
            topRight: radius,
            bottomLeft: index == items.length - 1 ? radius : Radius.zero,
          );
        } else if (index == 0) {
          // Topmost item (not above selected)
          borderRadius = BorderRadius.only(topLeft: radius);
        } else if (index == items.length - 1) {
          // Bottommost item (not below selected)
          borderRadius = BorderRadius.only(bottomLeft: radius);
        } else {
          borderRadius = BorderRadius.zero;
        }
      } else {
        borderRadius = BorderRadius.circular(style.borderRadius);
      }

      final child = Container(
        height: style.cardHeight,
        padding: EdgeInsets.all(style.padding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.all(style: BorderStyle.none),
          boxShadow: widget.direction == Axis.vertical
              ? style.boxShadowVertical
              : style.boxShadowHorizontal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCategoryIcon(item.iconAsset, style.iconSize),
            SizedBox(height: style.spacing),
            AppzText(
              item.label,
              category: 'input',
              fontWeight: 'medium',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      );

      // Margin logic for horizontal layout (edgePadding)
      EdgeInsets itemMargin = EdgeInsets.symmetric(
        horizontal: widget.direction == Axis.horizontal ? style.itemSpacing / 2 : 0,
        vertical: widget.direction == Axis.horizontal ? style.itemSpacing / 2 : 0,
      );
      if (widget.direction == Axis.horizontal) {
        if (index == 0) {
          itemMargin = itemMargin.copyWith(left: widget.edgePadding);
        }
        if (index == items.length - 1) {
          itemMargin = itemMargin.copyWith(right: widget.edgePadding);
        }
      }

      return MouseRegion(
        onEnter: (_) => setState(() => hoveredIds.add(item.id)),
        onExit: (_) => setState(() => hoveredIds.remove(item.id)),
        child: Container(
          margin: itemMargin,
          padding: widget.direction == Axis.vertical
              ? EdgeInsets.zero
              : EdgeInsets.zero,
          height: style.cardHeight,
          width: widget.direction == Axis.vertical ? style.itemWidth : null,
          child: GestureDetector(
            onTap: () {
              widget.selectedIdNotifier.value = item.id;
              widget.onItemTap(item);
            },
            child: child,
          ),
        ),
      );
    });
  }
}

Widget _buildCategoryIcon(String assetPath, double size) {
  if (assetPath.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(assetPath, height: size, width: size);
  } else {
    return Image.asset(assetPath, height: size, width: size);
  }
}
