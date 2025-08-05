import 'category_list_item_model.dart';

class CategorySection {
  final String title;
  final List<CategoryListItem> items;

  const CategorySection(this.title, this.items);

  @override
  String toString() {
    return 'CategorySection(title: $title, items: ${items.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategorySection &&
        other.title == title &&
        other.items == items;
  }

  @override
  int get hashCode => title.hashCode ^ items.hashCode;
} 