import 'package:flutter/material.dart';
import 'model/category_list_item_model.dart';
import 'model/category_section.dart';
import 'appz_category_list_style_config.dart';
import 'package:apz_flutter_components/components/appz_text/appz_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Custom ScrollBehavior to remove scrollbars
class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class AppzCategoryList extends StatefulWidget {
  // Single section parameters
  final List<CategoryListItem>? items;
  final String? selectedId;
  final Function(CategoryListItem) onItemTap;
  final Function(CategoryListItem)? onBookmarkTap;
  final String? title;

  // Multi-section parameters
  final List<CategorySection>? sections;

  const AppzCategoryList({
    Key? key,
    // Single section parameters
    this.items,
    this.selectedId,
    required this.onItemTap,
    this.onBookmarkTap,
    this.title,
    // Multi-section parameters
    this.sections,
  }) : assert(
         (sections != null) || (items != null),
         'Either provide sections for multi-mode or items+title for single mode'
       ),
       super(key: key);

  @override
  State<AppzCategoryList> createState() => _AppzCategoryListState();
}

class _AppzCategoryListState extends State<AppzCategoryList> {
  late CategoryListStateStyle style;

  @override
  void initState() {
    super.initState();
    style = AppzCategoryListStyleConfig.instance.defaultStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer container with token-driven styling
      padding: EdgeInsets.all(style.padding), // token-driven
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(style.borderRadius), // Only right side
          bottomRight: Radius.circular(style.borderRadius), // Only right side
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: Column(
              children: [
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    // Multi-section mode
    if (widget.sections != null) {
      return ScrollConfiguration(
        behavior: NoScrollbarBehavior(),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.sections!.length,
          itemBuilder: (context, sectionIndex) {
            final section = widget.sections![sectionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                Padding(
                  padding: EdgeInsets.fromLTRB(style.padding, sectionIndex == 0 ? 0 : style.padding, 0, style.padding * 0.75),
                  child: AppzText(
                    section.title,
                    category: 'subheader',
                    fontWeight: 'subheader',
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: style.padding,
                    right: 0.0,
                    top: 0.0,
                    bottom: sectionIndex == widget.sections!.length - 1 ? 0.0 : 0.0,
                  ),
                  itemCount: section.items.length,
                  separatorBuilder: (context, index) => SizedBox(height: style.padding),
                  itemBuilder: (context, index) {
                    final item = section.items[index];
                    return _buildListItem(item);
                  },
                ),
              ],
            );
          },
        ),
      );
    }

    // Single section mode (backward compatibility)
    return ScrollConfiguration(
      behavior: NoScrollbarBehavior(),
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: widget.title != null ? style.padding : 0.0,
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
        ),
        itemCount: widget.items?.length ?? 0,
        separatorBuilder: (context, index) => SizedBox(height: style.padding),
        itemBuilder: (context, index) {
          final item = widget.items![index];
          return _buildListItem(item);
        },
      ),
    );
  }

  Widget _buildListItem(CategoryListItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: style.iconSize + 16,
            height: style.iconSize + 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            child: Center(
              child: item.iconAsset.toLowerCase().endsWith('.svg')
                ? SvgPicture.asset(item.iconAsset, width: style.iconSize, height: style.iconSize, color: style.iconColor)
                : Image.asset(item.iconAsset, width: style.iconSize, height: style.iconSize, color: style.iconColor),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppzText(
                  item.title,
                  category: 'input',
                  fontWeight: 'medium',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                if (item.subtitle != null)
                  AppzText(
                    item.subtitle!,
                    category: 'input',
                    fontWeight: 'regular',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: widget.onBookmarkTap != null ? () => widget.onBookmarkTap!(item) : null,
            child: SvgPicture.asset(
              item.isBookmarked
                ? 'assets/icons/bookmark-selected.svg'
                : 'assets/icons/bookmark-unselected.svg',
              width: 24,
              height: 24,
              color: item.isBookmarked ? style.bookmarkColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String assetPath, bool isSelected) {
    if (assetPath.toLowerCase().endsWith('.svg')) {
      // If you use flutter_svg, import and use SvgPicture.asset
      // return SvgPicture.asset(assetPath, height: style.iconSize, width: style.iconSize, color: isSelected ? style.iconSelectedColor : style.iconColor);
      return SizedBox(
        height: style.iconSize,
        width: style.iconSize,
        child: Placeholder(), // Replace with SvgPicture.asset in real usage
      );
    } else {
      return Image.asset(
        assetPath,
        height: style.iconSize,
        width: style.iconSize,
        color: isSelected ? style.iconSelectedColor : style.iconColor,
      );
    }
  }
} 