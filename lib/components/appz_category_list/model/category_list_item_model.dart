class CategoryListItem {
  final String id;
  final String title;
  final String? subtitle;
  final String iconAsset;
  final bool isBookmarked;

  CategoryListItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.iconAsset,
    this.isBookmarked = false,
  });

  factory CategoryListItem.fromJson(Map<String, dynamic> json) {
    return CategoryListItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      iconAsset: json['iconAsset'],
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
} 