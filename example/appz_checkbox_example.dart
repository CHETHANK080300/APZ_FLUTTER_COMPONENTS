import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_checkbox/appz_checkbox.dart';

class AppzCheckboxExample extends StatefulWidget {
  const AppzCheckboxExample({Key? key}) : super(key: key);

  @override
  State<AppzCheckboxExample> createState() => _AppzCheckboxExampleState();
}

class _AppzCheckboxExampleState extends State<AppzCheckboxExample> {
  bool checked1 = false;
  bool checked2 = true;
  bool checked3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzCheckbox Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Default (unchecked, medium)'),
            AppzCheckbox(
              isChecked: checked1,
              title: 'Accept Terms',
              subtitle: 'You must accept to continue',
              onChanged: (val) => setState(() => checked1 = val),
            ),
            const SizedBox(height: 16),
            const Text('Checked (large)'),
            AppzCheckbox(
              isChecked: checked2,
              size: AppzCheckboxSize.large,
              title: 'Subscribe to newsletter',
              onChanged: (val) => setState(() => checked2 = val),
            ),
            const SizedBox(height: 16),
            const Text('Disabled (small)'),
            AppzCheckbox(
              isChecked: false,
              isDisabled: true,
              size: AppzCheckboxSize.small,
              title: 'Disabled Option',
              subtitle: 'This cannot be changed',
            ),
            const SizedBox(height: 16),
            const Text('With error'),
            AppzCheckbox(
              isChecked: checked3,
              showError: true,
              title: 'Must be checked',
              onChanged: (val) => setState(() => checked3 = val),
            ),
          ],
        ),
      ),
    );
  }
} 