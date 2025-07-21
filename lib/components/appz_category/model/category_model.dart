class CategoryItem {
  final String id;
  final String label;
  final String iconAsset;

  CategoryItem({
    required this.id,
    required this.label,
    required this.iconAsset,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      label: json['label'],
      iconAsset: json['iconAsset'],
    );
  }
}
