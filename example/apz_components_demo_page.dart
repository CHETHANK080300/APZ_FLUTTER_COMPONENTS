import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_field.dart';
import 'package:apz_flutter_components/components/appz_dropdown_field/appz_dropdown_field.dart';
import 'package:apz_flutter_components/components/apz_button/appz_button.dart';
import 'package:apz_flutter_components/components/appz_progress_bar/appz_progress_bar.dart';
import 'package:apz_flutter_components/components/apz_file_upload/apz_file_upload.dart';
import 'package:apz_flutter_components/apz_date_picker_field.dart';
import 'package:apz_flutter_components/apz_phone_input_with_dropdown.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_field_enums.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_field_theme.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_style_config.dart';
import 'package:apz_flutter_components/components/appz_dropdown_field/dropdown_style_config.dart';
import 'package:apz_flutter_components/components/apz_button/button_style_config.dart';
import 'package:apz_flutter_components/components/appz_progress_bar/progress_bar_style_config.dart';
import 'package:apz_flutter_components/common/ui_config_resolver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:apz_flutter_components/components/appz_category/appz_category.dart';
import 'package:apz_flutter_components/components/appz_category/appz_category_style_config.dart';
import 'package:apz_flutter_components/components/appz_category/model/category_model.dart';

class ApzComponentsDemoPage extends StatefulWidget {
  const ApzComponentsDemoPage({super.key});

  @override
  State<ApzComponentsDemoPage> createState() => _ApzComponentsDemoPageState();
}

class _ApzComponentsDemoPageState extends State<ApzComponentsDemoPage> {
  bool _loading = true;
  String? _error;
  final _inputController = TextEditingController();
  final _dropdownController = ValueNotifier<String?>(null);
  PlatformFile? _selectedFile;
  DateTime? _selectedDate;
  // ignore: unused_field
  String? _phoneValue;

  // Category demo state
  final ValueNotifier<List<CategoryItem>> _categoryItemsNotifier = ValueNotifier([
    CategoryItem(id: 'cat1', label: 'Books', iconAsset: 'assets/icons/book.png'),
    CategoryItem(id: 'cat2', label: 'Music', iconAsset: 'assets/icons/music.png'),
    CategoryItem(id: 'cat3', label: 'Movies', iconAsset: 'assets/icons/video-play.png'),
    CategoryItem(id: 'cat4', label: 'Games', iconAsset: 'assets/icons/game.png'),
  ]);
  final ValueNotifier<String?> _selectedCategoryIdNotifier = ValueNotifier('cat1');

  // Progress bar demo state
  double _progressValue = 65;

  void _changeProgress(double delta) {
    setState(() {
      _progressValue = (_progressValue + delta).clamp(0, 100);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    try {
      final resolver = await UIConfigResolver.loadMaster('assets/json/master_theme.json');
      final dropdownConfig = await resolver.loadAndResolve('assets/json/dropdown_ui_config.json');
      final inputConfig = await resolver.loadAndResolve('assets/json/input_ui_config.json');
      final progressBarConfig = await resolver.loadAndResolve('assets/json/progress_bar_ui_config.json');
      final buttonConfig = await resolver.loadAndResolve('assets/json/button_ui_config.json');
      final categoryConfig = await resolver.loadAndResolve('assets/json/category_ui_config.json');
      await DropdownStyleConfig.instance.loadFromResolved(dropdownConfig);
      await AppzStyleConfig.instance.loadFromResolved(inputConfig);
      await ProgressBarStyleConfig.instance.loadFromResolved(progressBarConfig);
      await ButtonStyleConfig.instance.loadFromResolved(buttonConfig);
      await AppzCategoryStyleConfig.instance.loadFromResolved(categoryConfig);
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

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
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error loading configs: $_error')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('APZ Components Demo (JSON-driven)')),
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
            _sectionCard(
              title: 'Dropdown Field',
              child: AppzDropdownField(
                label: 'Select Option',
                items: const ['Option 1', 'Option 2', 'Option 3'],
                selectedItem: _dropdownController.value,
                onChanged: (val) => setState(() => _dropdownController.value = val),
                controller: _dropdownController,
                isMandatory: true,
              ),
            ),
            _sectionCard(
              title: 'Progress Bars',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppzButton(
                        label: '-',
                        appearance: AppzButtonAppearance.secondary,
                        onPressed: () => _changeProgress(-10),
                      ),
                      const SizedBox(width: 16),
                      Text('${_progressValue.toInt()}%', style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 16),
                      AppzButton(
                        label: '+',
                        appearance: AppzButtonAppearance.primary,
                        onPressed: () => _changeProgress(10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('No Label'),
                  AppzProgressBar(
                    percentage: _progressValue,
                    labelPosition: ProgressBarLabelPosition.none,
                  ),
                  const SizedBox(height: 16),
                  const Text('Right Label'),
                  AppzProgressBar(
                    percentage: _progressValue,
                    labelPosition: ProgressBarLabelPosition.right,
                    
                  ),
                  const SizedBox(height: 16),
                  const Text('Bottom Label'),
                  AppzProgressBar(
                    percentage: _progressValue,
                    labelPosition: ProgressBarLabelPosition.bottom,
                    
                  ),
                  const SizedBox(height: 16),
                  const Text('Top Floating Label'),
                  AppzProgressBar(
                    percentage: _progressValue,
                    labelPosition: ProgressBarLabelPosition.topFloating,
                    
                  ),
                  const SizedBox(height: 16),
                  const Text('Bottom Floating Label'),
                  AppzProgressBar(
                    percentage: _progressValue,
                    labelPosition: ProgressBarLabelPosition.bottomFloating,
                    
                  ),
                ],
              ),
            ),
            _sectionCard(
              title: 'Input Fields',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Default'),
                  AppzInputField(
                    label: 'Full Name',
                    hintText: 'Please enter your name here',
                    controller: _inputController,
                    fieldType: AppzFieldType.defaultType,
                  ),
                  const SizedBox(height: 12),
                  const Text('Disabled'),
                  AppzInputField(
                    label: 'Disabled Name',
                    hintText: 'This field is disabled',
                    // controller: _inputController,
                    fieldType: AppzFieldType.defaultType,
                    initialFieldState: AppzFieldState.disabled,
                  ),
                  const SizedBox(height: 12),
                  const Text('Mobile Number'),
                  AppzInputField(
                    label: 'Mobile Number',
                    hintText: 'Enter 10-digit number',
                    fieldType: AppzFieldType.mobile,
                    validationType: AppzInputValidationType.mandatory,
                  ),
                  const SizedBox(height: 12),
                  const Text('Aadhaar Number'),
                  AppzInputField(
                    label: 'Aadhaar Number',
                    hintText: 'Enter 12-digit Aadhaar number',
                    fieldType: AppzFieldType.aadhaar,
                    validationType: AppzInputValidationType.mandatory,
                  ),
                  const SizedBox(height: 12),
                  const Text('MPIN'),
                  AppzInputField(
                    label: 'Enter MPIN',
                    hintText: '●●●●',
                    fieldType: AppzFieldType.mpin,
                    obscureText: false,
                    mpinLength: 6,
                    validationType: AppzInputValidationType.mandatory,
                  ),
                  const SizedBox(height: 12),
                  const Text('Text Description'),
                  AppzInputField(
                    label: 'About You',
                    hintText: 'Enter a short description...',
                    fieldType: AppzFieldType.textDescription,
                  ),
                ],
              ),
            ),
            _sectionCard(
              title: 'File Upload',
              child: ApzUploadFileWidget(
                currentStyle: AppzStyleConfig.instance.getStyleForState(AppzFieldState.defaultState),
                isEnabled: true,
                labelText: 'Upload Document',
                hintText: 'Click to upload the document',
                allowedExtensionsDescription: 'SVG, PNG, JPG or PDF',
                allowedExtensions: const ['pdf', 'svg', 'png', 'jpg'],
                onFileSelected: (file) => setState(() => _selectedFile = file),
                validationType: AppzInputValidationType.mandatory,
                selectedFile: _selectedFile,
                maxSizeInKB: 2048,
              ),
            ),
            _sectionCard(
              title: 'Date Picker',
              child: ApzDatePickerField(
                label: 'Select Date',
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
                isMandatory: true,
              ),
            ),
            _sectionCard(
              title: 'Phone Input with Dropdown',
              child: ApzPhoneInputWithDropdown(
                label: 'Phone Number',
                initialPhoneCode: '91',
                isMandatory: true,
                onChanged: (val) => setState(() => _phoneValue = val),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 