import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_category/appz_category.dart';
import 'package:apz_flutter_components/components/appz_category/model/category_model.dart';

class AppzCategoryExamplePage extends StatefulWidget {
  const AppzCategoryExamplePage({Key? key}) : super(key: key);

  @override
  State<AppzCategoryExamplePage> createState() => _AppzCategoryExamplePageState();
}

class _AppzCategoryExamplePageState extends State<AppzCategoryExamplePage> {
  final ValueNotifier<List<CategoryItem>> _categoryItemsNotifier = ValueNotifier([
    CategoryItem(id: 'cat1', label: 'Books', iconAsset: 'assets/icons/book.png'),
    CategoryItem(id: 'cat2', label: 'Music', iconAsset: 'assets/icons/music.png'),
    CategoryItem(id: 'cat3', label: 'Movies', iconAsset: 'assets/icons/video-play.png'),
    CategoryItem(id: 'cat4', label: 'Profile', iconAsset: 'assets/icons/profile.png'),
    CategoryItem(id: 'cat5', label: 'Games', iconAsset: 'assets/icons/game.png'),
    CategoryItem(id: 'cat6', label: 'ranking', iconAsset: 'assets/icons/ranking.png'),
    CategoryItem(id: 'cat7', label: 'receipt', iconAsset: 'assets/icons/receipt.png'),
    CategoryItem(id: 'cat8', label: 'record', iconAsset: 'assets/icons/record.png'),
    CategoryItem(id: 'cat9', label: 'scanner', iconAsset: 'assets/icons/scanner.png'),
    CategoryItem(id: 'cat10', label: 'Microphone', iconAsset: 'assets/icons/microphone.png'),
    CategoryItem(id: 'cat11', label: 'Shop', iconAsset: 'assets/icons/shopping-cart.png'),
    CategoryItem(id: 'cat12', label: 'Settings', iconAsset: 'assets/icons/settings.png'),
    CategoryItem(id: 'cat13', label: 'Share', iconAsset: 'assets/icons/share.png'),
    CategoryItem(id: 'cat14', label: 'Shopping', iconAsset: 'assets/icons/shopping-cart.png'),
    CategoryItem(id: 'cat15', label: 'Tax', iconAsset: 'assets/icons/Tax.png'),
    CategoryItem(id: 'cat16', label: 'Wallet', iconAsset: 'assets/icons/wallet.png'),
    CategoryItem(id: 'cat17', label: 'Ticket', iconAsset: 'assets/icons/ticket.png'),
    CategoryItem(id: 'cat18', label: 'Games', iconAsset: 'assets/icons/game.png'),
  ]);
  final ValueNotifier<String?> _selectedCategoryIdNotifier = ValueNotifier(null);

  Widget _sectionCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzCategory Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: 'Category (Horizontal)',
              child: AppzCategory(
                itemsNotifier: _categoryItemsNotifier,
                selectedIdNotifier: _selectedCategoryIdNotifier,
                direction: Axis.horizontal,
                onItemTap: (item) => setState(() => _selectedCategoryIdNotifier.value = item.id),
              ),
            ),
            _sectionCard(
              title: 'Category (Vertical)',
              child: AppzCategory(
                itemsNotifier: _categoryItemsNotifier,
                selectedIdNotifier: _selectedCategoryIdNotifier,
                direction: Axis.vertical,
                onItemTap: (item) => setState(() => _selectedCategoryIdNotifier.value = item.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 