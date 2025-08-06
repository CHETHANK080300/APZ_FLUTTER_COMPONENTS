import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_toggle_with_label/appz_toggle_with_label.dart';

class AppzToggleWithLabelExample extends StatefulWidget {
  const AppzToggleWithLabelExample({Key? key}) : super(key: key);

  @override
  State<AppzToggleWithLabelExample> createState() => _AppzToggleWithLabelExampleState();
}

class _AppzToggleWithLabelExampleState extends State<AppzToggleWithLabelExample> {
  bool value1 = false;
  bool value2 = true;
  bool value3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzToggleWithLabel Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Default (large)'),
            AppzToggleWithLabel(
              label: 'Receive newsletter?',
              value: value1,
              onChanged: (val) => setState(() => value1 = val),
              activeText: 'Yes',
              inactiveText: 'No',
            ),
            const SizedBox(height: 16),
            const Text('Small size, custom labels'),
            AppzToggleWithLabel(
              label: 'Enable feature?',
              value: value2,
              size: AppzToggleWithLabelSize.small,
              onChanged: (val) => setState(() => value2 = val),
              activeText: 'Active',
              inactiveText: 'Inactive',
            ),
            const SizedBox(height: 16),
            const Text('Disabled'),
            AppzToggleWithLabel(
              label: 'Disabled Option',
              value: value3,
              isDisabled: true,
              onChanged: (val) {},
            ),
          ],
        ),
      ),
    );
  }
} 