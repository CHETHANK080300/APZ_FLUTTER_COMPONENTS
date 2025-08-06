import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_category/appz_category.dart';
import 'package:apz_flutter_components/components/appz_category/model/category_model.dart';
import 'package:apz_flutter_components/components/appz_category_list/appz_category_list.dart';
import 'package:apz_flutter_components/components/appz_category_list/model/category_list_item_model.dart';
import 'package:apz_flutter_components/components/appz_category_list/model/category_section.dart';
import 'package:apz_flutter_components/components/appz_category_list/appz_category_list_style_config.dart';

class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class AppzCategoryListExample extends StatefulWidget {
  const AppzCategoryListExample({Key? key}) : super(key: key);

  @override
  State<AppzCategoryListExample> createState() => _AppzCategoryListExampleState();
}

class _AppzCategoryListExampleState extends State<AppzCategoryListExample> {
  final categories = [
    CategoryItem(id: 'insurance', label: 'Insurance', iconAsset: 'assets/icons/umbrella.svg'),
    CategoryItem(id: 'healthcare', label: 'Healthcare', iconAsset: 'assets/icons/24-support.svg'),
    CategoryItem(id: 'financial', label: 'Financial', iconAsset: 'assets/icons/wallet-money.svg'),
    CategoryItem(id: 'travel', label: 'Travel', iconAsset: 'assets/icons/car.svg'),
    CategoryItem(id: 'education', label: 'Education', iconAsset: 'assets/icons/graduation-cap.svg'),
    CategoryItem(id: 'loans', label: 'Loans', iconAsset: 'assets/icons/rupee.svg'),
    CategoryItem(id: 'agriculture', label: 'Agriculture', iconAsset: 'assets/icons/tree.svg'),
  ];

  final Map<String, List<CategoryListItem>> categoryItems = {
    'insurance': [
      CategoryListItem(id: '1', title: 'Ayushman Bharat Registration (PMJAY)', iconAsset: 'assets/icons/PMJJY.svg', isBookmarked: false),
      CategoryListItem(id: '2', title: 'Insurance and Mediclaim Support', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
    ],
    'healthcare': [
      CategoryListItem(id: '3', title: 'eHealth Services (Electronic Health Records)', iconAsset: 'assets/icons/archive.svg', isBookmarked: false),
      CategoryListItem(id: '4', title: 'e-Vaccination Registration', iconAsset: 'assets/icons/activity.svg', isBookmarked: false),
      CategoryListItem(id: '5', title: 'Health Awareness Campaigns & Education', iconAsset: 'assets/icons/announcement-01.svg', isBookmarked: false),
      CategoryListItem(id: '6', title: 'Laboratory Testing and Health Check-ups', iconAsset: 'assets/icons/activity.svg', isBookmarked: false),
      CategoryListItem(id: '7', title: 'Nutrition and Wellness Programs', iconAsset: 'assets/icons/apple.svg', isBookmarked: false),
      CategoryListItem(id: '8', title: 'Online Health Consultation & Specialist Services', iconAsset: 'assets/icons/user.svg', isBookmarked: false),
      CategoryListItem(id: '31', title: 'Mental Health Support Services', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '32', title: 'Emergency Medical Services', iconAsset: 'assets/icons/Ambulance.svg', isBookmarked: false),
      CategoryListItem(id: '33', title: 'Maternal and Child Health Care', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '34', title: 'Dental Health Services', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '35', title: 'Vision Care and Eye Health', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '36', title: 'Physical Therapy and Rehabilitation', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '37', title: 'Chronic Disease Management', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '38', title: 'Preventive Health Screenings', iconAsset: 'assets/icons/activity.svg', isBookmarked: false),
      CategoryListItem(id: '39', title: 'Telemedicine Services', iconAsset: 'assets/icons/user.svg', isBookmarked: false),
      CategoryListItem(id: '40', title: 'Health Insurance Assistance', iconAsset: 'assets/icons/umbrella.svg', isBookmarked: false),
      CategoryListItem(id: '41', title: 'Medical Equipment and Supplies', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '42', title: 'Alternative Medicine Services', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '43', title: 'Senior Health Care Services', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '44', title: 'Pediatric Health Services', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '45', title: 'Women Health Services', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '46', title: 'Men Health Services', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '47', title: 'Occupational Health Services', iconAsset: 'assets/icons/24-support.svg', isBookmarked: false),
      CategoryListItem(id: '48', title: 'Public Health Programs', iconAsset: 'assets/icons/announcement-01.svg', isBookmarked: false),
      CategoryListItem(id: '49', title: 'Health Education and Training', iconAsset: 'assets/icons/graduation-cap.svg', isBookmarked: false),
      CategoryListItem(id: '50', title: 'Medical Research and Clinical Trials', iconAsset: 'assets/icons/activity.svg', isBookmarked: false),
    ],
    'financial': [
      CategoryListItem(id: '9', title: 'Financial Planning', iconAsset: 'assets/icons/wallet-money.svg', isBookmarked: false),
      CategoryListItem(id: '10', title: 'Tax Consultation', iconAsset: 'assets/icons/wallet-check.svg', isBookmarked: false),
    ],
    'travel': [
      CategoryListItem(id: '11', title: 'Travel Insurance', iconAsset: 'assets/icons/car.svg', isBookmarked: false),
    ],
    'education': [
      CategoryListItem(id: '12', title: 'Student Loans', iconAsset: 'assets/icons/graduation-cap.svg', isBookmarked: false),
    ],
    'loans': [
      CategoryListItem(id: '13', title: 'Personal Loan', iconAsset: 'assets/icons/rupee.svg', isBookmarked: false),
    ],
    'agriculture': [
      CategoryListItem(id: '14', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '15', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '16', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '17', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '18', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '19', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '20', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '21', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '22', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '23', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '24', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '25', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '26', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '27', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '28', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '29', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),
      CategoryListItem(id: '30', title: 'Crop Insurance', iconAsset: 'assets/icons/tree.svg', isBookmarked: false),

    ],
  };

  late ValueNotifier<List<CategoryItem>> itemsNotifier;
  late ValueNotifier<String?> selectedCategoryNotifier;
  String? selectedListItemId;
  List<CategoryListItem> currentListItems = [];

  bool _styleLoaded = false;

  @override
  void initState() {
    super.initState();
    itemsNotifier = ValueNotifier(categories);
    selectedCategoryNotifier = ValueNotifier(categories.first.id);
    currentListItems = categoryItems[categories.first.id] ?? [];
    AppzCategoryListStyleConfig.instance.load().then((_) {
      setState(() {
        _styleLoaded = true;
      });
    });
  }

  void _onCategoryTap(CategoryItem item) {
    setState(() {
      selectedCategoryNotifier.value = item.id;
      currentListItems = categoryItems[item.id] ?? [];
      selectedListItemId = currentListItems.isNotEmpty ? currentListItems.first.id : null;
    });
  }

  void _onListItemTap(CategoryListItem item) {
    setState(() {
      selectedListItemId = item.id;
    });
  }

  void _onBookmarkTap(CategoryListItem item) {
    setState(() {
      currentListItems = currentListItems.map((e) =>
        e.id == item.id ? CategoryListItem(
          id: e.id,
          title: e.title,
          subtitle: e.subtitle,
          iconAsset: e.iconAsset,
          isBookmarked: !e.isBookmarked,
        ) : e
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_styleLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Example: For healthcare, split items into two sections
    final isHealthcare = selectedCategoryNotifier.value == 'healthcare';
    final healthcareItems = categoryItems['healthcare'] ?? [];
    final section1 = healthcareItems.take(3).toList();
    final section2 = healthcareItems.skip(3).toList();
    
    // Create sections for healthcare
    final healthcareSections = [
      CategorySection('Primary Healthcare', section1),
      CategorySection('Specialist Services', section2),
    ];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Contrasting background for card
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Left: Category selector (fixed width, full height)
              Container(
                width: constraints.maxWidth < 600 ? 80 : 100,
                height: constraints.maxHeight,
                color: Colors.white,
                child: AppzCategory(
                  itemsNotifier: itemsNotifier,
                  selectedIdNotifier: selectedCategoryNotifier,
                  direction: Axis.vertical,
                  onItemTap: _onCategoryTap,
                ),
              ),
              // Right: List for selected category (fills remaining space, full height)
              Expanded(
                child: isHealthcare
                    ? AppzCategoryList(
                        sections: healthcareSections,
                        selectedId: selectedListItemId,
                        onItemTap: _onListItemTap,
                        onBookmarkTap: _onBookmarkTap,
                      )
                    : AppzCategoryList(
                        items: currentListItems,
                        selectedId: selectedListItemId,
                        onItemTap: _onListItemTap,
                        onBookmarkTap: _onBookmarkTap,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
} 