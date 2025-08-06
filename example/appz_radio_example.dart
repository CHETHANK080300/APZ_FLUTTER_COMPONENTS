import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_radio/appz_radio.dart';

class AppzRadioExample extends StatefulWidget {
  const AppzRadioExample({Key? key}) : super(key: key);

  @override
  State<AppzRadioExample> createState() => _AppzRadioExampleState();
}

class _AppzRadioExampleState extends State<AppzRadioExample> {
  bool checked1 = false;
  bool checked2 = true;
  bool checked3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzRadio Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Default (unchecked, medium)'),
            AppzRadio(
              isChecked: checked1,
              title: 'Option 1',
              subtitle: 'This is option 1',
              onChanged: (val) => setState(() => checked1 = val),
            ),
            const SizedBox(height: 16),
            const Text('Checked (large)'),
            AppzRadio(
              isChecked: checked2,
              size: AppzRadioSize.large,
              title: 'Option 2',
              onChanged: (val) => setState(() => checked2 = val),
            ),
            const SizedBox(height: 16),
            const Text('Disabled (small)'),
            AppzRadio(
              isChecked: false,
              isDisabled: true,
              size: AppzRadioSize.small,
              title: 'Disabled Option',
              subtitle: 'This cannot be changed',
            ),
            const SizedBox(height: 16),
            const Text('With error'),
            AppzRadio(
              isChecked: checked3,
              showError: true,
              title: 'Must be selected',
              onChanged: (val) => setState(() => checked3 = val),
            ),
          ],
        ),
      ),
    );
  }
} 