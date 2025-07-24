import 'package:apz_flutter_components/components/appz_search_bar/appz_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_category/appz_category.dart';
import 'package:apz_flutter_components/components/appz_category/model/category_model.dart';

class AppzSearchBarWithCategoryExample extends StatefulWidget {
  const AppzSearchBarWithCategoryExample({super.key});

  @override
  State<AppzSearchBarWithCategoryExample> createState() =>
      _AppzSearchBarWithCategoryExampleState();
}

class _AppzSearchBarWithCategoryExampleState
    extends State<AppzSearchBarWithCategoryExample> {
  final ValueNotifier<List<CategoryItem>> _filteredCategories =
      ValueNotifier<List<CategoryItem>>([]);
  final ValueNotifier<String?> _selectedIdNotifier =
      ValueNotifier<String?>(null);

  final List<CategoryItem> _allCategories = [
    CategoryItem(id: '1', label: 'Books', iconAsset: 'assets/icons/book-1.png'),
    CategoryItem(
        id: '2', label: 'Music', iconAsset: 'assets/icons/audio-square.png'),
    CategoryItem(id: '3', label: 'Movies', iconAsset: 'assets/icons/video.png'),
    CategoryItem(id: '4', label: 'Games', iconAsset: 'assets/icons/game.png'),
    CategoryItem(
        id: '5', label: 'Fitness', iconAsset: 'assets/icons/activity.png'),
    CategoryItem(id: '6', label: 'Food', iconAsset: 'assets/icons/cup.png'),
    CategoryItem(
        id: '7', label: 'Travel', iconAsset: 'assets/icons/airplane.png'),
    CategoryItem(
        id: '8', label: 'Tech', iconAsset: 'assets/icons/computing.png'),
  ];

  // New: recommendations for demo
  final List<String> _recommendations = [
    'Bookstore',
    'Music streaming',
    'Movie tickets',
    'Game consoles',
    'Fitness tracker',
    'Food delivery',
    'Travel insurance',
    'Tech news',
    'Dart',
    'Google',
    'Python',
    'Java',
    'C++',
    'C#',
    'Ruby',
    'PHP',
    'Flutter',
    'React',
    'Angular',
    'Vue',
    'Node.js',
    'Express',
    'MongoDB',
  ];

  // New: toggle for useWidget
  bool _useWidget = true;

  @override
  void dispose() {
    _filteredCategories.dispose();
    _selectedIdNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SearchBar + Category Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Show Categories'),
                Switch(
                  value: _useWidget,
                  onChanged: (val) {
                    setState(() {
                      _useWidget = val;
                    });
                  },
                ),
                Text(_useWidget ? 'Categories' : 'Recommendations'),
              ],
            ),
            // Wrap the search bar in Flexible to prevent overflow
            Flexible(
              child: AppzSearchBar<CategoryItem>(
                size: AppzSearchBarSize.large,
                // state: AppzSearchBarState.enabled,
                state: AppzSearchBarState.hovered,
                items: _allCategories,
                labelSelector: (item) => item.label,
                onFiltered: (filtered) => _filteredCategories.value = filtered,
                hintText: 'Search categories...',
                showTrailingIcon: true,
                useWidget: _useWidget,
                categoriesWidget: _useWidget
                    ? AppzCategory(
                        itemsNotifier: _filteredCategories,
                        selectedIdNotifier: _selectedIdNotifier,
                        direction: Axis.vertical,
                        onItemTap: (item) {},
                      )
                    : null,
                recommendations: !_useWidget ? _recommendations : null,
              ),
            ),
            // Only show the expanded AppzCategory if not using the widget in search bar
            if (!_useWidget) ...[
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Text(
                    'Recommendations are shown below the search bar.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
