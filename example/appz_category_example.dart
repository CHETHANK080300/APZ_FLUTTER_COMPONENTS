import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_category/appz_category.dart';
import 'package:apz_flutter_components/components/appz_category/model/category_model.dart';

class AppzCategoryExamplePage extends StatefulWidget {
  const AppzCategoryExamplePage({Key? key}) : super(key: key);

  @override
  State<AppzCategoryExamplePage> createState() =>
      _AppzCategoryExamplePageState();
}

class _AppzCategoryExamplePageState extends State<AppzCategoryExamplePage> {
  final ValueNotifier<List<CategoryItem>> _categoryItemsNotifier =
      ValueNotifier([
    CategoryItem(
        id: 'cat1', label: 'Books', iconAsset: 'assets/icons/book-square.svg'),
    CategoryItem(
        id: 'cat2', label: 'Music', iconAsset: 'assets/icons/music.svg'),
    CategoryItem(
        id: 'cat3', label: 'Movies', iconAsset: 'assets/icons/video-play.svg'),
    CategoryItem(
        id: 'cat4', label: 'Profile', iconAsset: 'assets/icons/profile.svg'),
    CategoryItem(
        id: 'cat5', label: 'Games', iconAsset: 'assets/icons/game.svg'),
    CategoryItem(
        id: 'cat6', label: 'ranking', iconAsset: 'assets/icons/ranking.svg'),
    CategoryItem(
        id: 'cat7', label: 'receipt', iconAsset: 'assets/icons/receipt.svg'),
    CategoryItem(
        id: 'cat8', label: 'record', iconAsset: 'assets/icons/record.svg'),
    CategoryItem(
        id: 'cat9', label: 'scanner', iconAsset: 'assets/icons/scanner.svg'),
    CategoryItem(
        id: 'cat10',
        label: 'Microphone',
        iconAsset: 'assets/icons/microphone.svg'),
    CategoryItem(
        id: 'cat11',
        label: 'Shop',
        iconAsset: 'assets/icons/shopping-cart.svg'),
    CategoryItem(
        id: 'cat12', label: 'Settings', iconAsset: 'assets/icons/settings.svg'),
    CategoryItem(
        id: 'cat13', label: 'Share', iconAsset: 'assets/icons/share.svg'),
    CategoryItem(
        id: 'cat14',
        label: 'Shopping',
        iconAsset: 'assets/icons/shopping-cart.svg'),
    CategoryItem(id: 'cat15', label: 'Tax', iconAsset: 'assets/icons/Tax.svg'),
    CategoryItem(
        id: 'cat16', label: 'Wallet', iconAsset: 'assets/icons/wallet.svg'),
    CategoryItem(
        id: 'cat17', label: 'Ticket', iconAsset: 'assets/icons/ticket.svg'),
    CategoryItem(
        id: 'cat18', label: 'Games', iconAsset: 'assets/icons/game.svg'),
  ]);
  final ValueNotifier<String?> _selectedCategoryIdNotifier =
      ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('AppzCategory Example')),
      body: ScrollConfiguration(
        behavior: NoScrollbarBehavior(),
        child: SingleChildScrollView(
         // padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppzCategory(
                itemsNotifier: _categoryItemsNotifier,
                selectedIdNotifier: _selectedCategoryIdNotifier,
                direction: Axis.horizontal,
                edgePadding: 8.0,
                onItemTap: (item) =>
                    setState(() => _selectedCategoryIdNotifier.value = item.id),
              ),
              const SizedBox(height: 32),
              AppzCategory(
                itemsNotifier: _categoryItemsNotifier,
                selectedIdNotifier: _selectedCategoryIdNotifier,
                direction: Axis.vertical,
                onItemTap: (item) =>
                    setState(() => _selectedCategoryIdNotifier.value = item.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
