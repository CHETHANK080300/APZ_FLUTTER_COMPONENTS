import 'package:apz_flutter_components/common/ui_config_resolver.dart';
import 'package:apz_flutter_components/components/apz_tabs/apz_tab.dart';
import 'package:apz_flutter_components/components/apz_tabs/apz_tab_style_config.dart';
import 'package:apz_flutter_components/components/apz_tabs/apz_tab_enums.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final resolver = await UIConfigResolver.loadMaster('assets/json/master_theme.json');
  final tabConfig = await resolver.loadAndResolve('assets/json/tabs_ui_config.json');
  await TabStyleConfig.instance.loadFromResolved(tabConfig);
  runApp(const TabBarTest());
}

class TabBarTest extends StatelessWidget {
  const TabBarTest({super.key});

  static const List<String> _tabs = [
    'Personal Info',
    'Contact Details',
    'Address',
    'Identity Proof',
    'Income Details',
    'Nominee Info',
    'KYC Verification',
    'Upload Documents',
    'Review & Submit',
    'Declaration',
    'Acknowledgement',
    'Summary',
    'Finish',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('AppzTabBar - All Use-Cases')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _demo(
              title: '1. Horizontal • Scrollable (Overflow in width)',
              onTab: (index) => print("Selected: $index"),
            ),
            _demo(
              title: '2. Horizontal • Wrapped (non-scrollable)',
              isScrollable: SelectionMode.disabled,
              onTab: (index) => print("Selected: $index"),
            ),
            _demo(
              title: '3. Vertical • Scrollable (Overflow in height)',
              direction: TabBarDirection.vertical,
              onTab: (index) => print("Selected: $index"),
            ),
            _demo(
              title: '4. Vertical • Wrapped (non-scrollable)',
              direction: TabBarDirection.vertical,
              isScrollable: SelectionMode.disabled,
              onTab: (index) => print("Selected: $index"),
            ),
            _demo(
              title: '5. Disabled (no taps allowed)',
              isEnabled: SelectionMode.disabled,
              onTab: (index) => print("Selected: $index"),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _demo({
    required String title,
    TabBarDirection? direction,
    SelectionMode? isScrollable,
    SelectionMode? isEnabled,
    required ValueChanged<int> onTab,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        AppzTabBar(
          tabs: _tabs,
          selectedIndex: 0,
          onTabChanged: onTab,
          tabDirection: direction, // Optional, defaults to TabBarDirection.horizontal
          isScrollable: isScrollable, // Optional, defaults to SelectionMode.enabled
          isEnabled: isEnabled, // Optional, defaults to SelectionMode.enabled
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}