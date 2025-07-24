import 'package:apz_flutter_components/components/appz_text/appz_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildItems(items),
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
    return items.map((item) {
      final isSelected = widget.selectedIdNotifier.value == item.id;
      final isHovered = hoveredIds.contains(item.id);
      final style = styleCfg.defaultStyle;

      // Use hover background color for selected or hovered (if not selected)
      final backgroundColor = (isSelected || (isHovered && !isSelected))
          ? style.hoverBackgroundColor ?? style.backgroundColor
          : style.backgroundColor;

      final child = Container(
        height: style.cardHeight,
        padding: EdgeInsets.all(style.padding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: widget.direction == Axis.vertical
              ? BorderRadius.zero
              : BorderRadius.circular(style.borderRadius),
          border: Border.all(style: BorderStyle.none),
          boxShadow: widget.direction == Axis.vertical
              ? style.boxShadowVertical
              : style.boxShadowHorizontal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Replace Image.asset with a helper that supports SVG and PNG
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

      return MouseRegion(
        onEnter: (_) => setState(() => hoveredIds.add(item.id)),
        onExit: (_) => setState(() => hoveredIds.remove(item.id)),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal:
                widget.direction == Axis.horizontal ? style.itemSpacing / 2 : 0,
            vertical:
                widget.direction == Axis.horizontal ? style.itemSpacing / 2 : 0,
          ),
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
    }).toList();
  }
}

Widget _buildCategoryIcon(String assetPath, double size) {
  if (assetPath.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(assetPath, height: size, width: size);
  } else {
    return Image.asset(assetPath, height: size, width: size);
  }
}
