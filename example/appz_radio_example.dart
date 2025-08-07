import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_radio/appz_radio_group.dart';

class AppzRadioExample extends StatefulWidget {
  const AppzRadioExample({Key? key}) : super(key: key);

  @override
  State<AppzRadioExample> createState() => _AppzRadioExampleState();
}

class _AppzRadioExampleState extends State<AppzRadioExample> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzRadioGroup Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppzRadioItem(
              label: 'Select an option',
              options: const ['Option 1', 'Option 2', 'Option 3'],
              defaultValue: 'Option 1',
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const SizedBox(height: 16),
            AppzRadioItem(
              label: 'Another selection (disabled)',
              options: const ['Option A', 'Option B', 'Option C'],
              defaultValue: 'Option B',
              isDisabled: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            if (_selectedValue != null)
              Text('Selected value: $_selectedValue'),
          ],
        ),
      ),
    );
  }
} 