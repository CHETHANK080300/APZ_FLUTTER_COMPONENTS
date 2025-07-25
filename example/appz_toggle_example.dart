import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_toggle/appz_toggle.dart';

class AppzToggleExample extends StatefulWidget {
  const AppzToggleExample({Key? key}) : super(key: key);

  @override
  State<AppzToggleExample> createState() => _AppzToggleExampleState();
}

class _AppzToggleExampleState extends State<AppzToggleExample> {
  bool on1 = false;
  bool on2 = true;
  bool on3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzToggle Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Default (off, large)'),
            AppzToggle(
              isOn: on1,
              text: 'Enable notifications',
              onChanged: (val) => setState(() => on1 = val),
            ),
            const SizedBox(height: 16),
            const Text('On (small)'),
            AppzToggle(
              isOn: on2,
              size: AppzToggleSize.small,
              text: 'Dark mode',
              onChanged: (val) => setState(() => on2 = val),
            ),
            const SizedBox(height: 16),
            const Text('Disabled (large)'),
            AppzToggle(
              isOn: false,
              isDisabled: true,
              size: AppzToggleSize.large,
              text: 'Disabled Option',
            ),
          ],
        ),
      ),
    );
  }
} 