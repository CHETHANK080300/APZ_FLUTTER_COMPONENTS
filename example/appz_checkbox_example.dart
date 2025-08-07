import 'package:flutter/material.dart';
import '../lib/components/appz_checkbox/appz_checkbox.dart';
import '../lib/components/appz_text/appz_text.dart';

class AppzCheckboxExample extends StatefulWidget {
  const AppzCheckboxExample({super.key});

  @override
  State<AppzCheckboxExample> createState() => _AppzCheckboxExampleState();
}

class _AppzCheckboxExampleState extends State<AppzCheckboxExample> {
  // Controllers for examples
  final AppzCheckboxController _singleController = AppzCheckboxController();
  final AppzCheckboxController _groupController = AppzCheckboxController();
  final AppzCheckboxController _groupController2 =
      AppzCheckboxController(); // Separate controller for second example

  // ValueNotifier for group checkbox example
  final ValueNotifier<List<int>> _groupValueNotifier =
      ValueNotifier<List<int>>([]);

  // Group items for checkbox examples
  final List<CheckboxItem> _preferencesGroupItems = [
    CheckboxItem(label: 'Email notifications', value: "yes"),
    CheckboxItem(label: 'Push notifications', value: "yes"),
    CheckboxItem(label: 'SMS notifications', value: "no"),
    CheckboxItem(label: 'Email notifications', value: "yes"),
    CheckboxItem(label: 'Push notifications', value: "yes"),
    CheckboxItem(label: 'SMS notifications', value: "no"),
    CheckboxItem(label: 'Email notifications', value: "yes"),
    CheckboxItem(label: 'Push notifications', value: "yes"),
    CheckboxItem(label: 'SMS notifications', value: "no"),
  ];
  final List<CheckboxItem> _preferencesGroupItems2 = [
    CheckboxItem(label: 'item1', value: "no"),
    CheckboxItem(label: 'item2', value: "no"),
    CheckboxItem(label: 'item3', value: "no"),
  ];

  @override
  void initState() {
    super.initState();
    // Controllers will auto-initialize based on groupItems
    // No manual initialization needed!
  }

  @override
  void dispose() {
    _singleController.dispose();
    _groupController.dispose();
    _groupController2.dispose();
    _groupValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppzCheckbox Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AppzCheckbox Component Examples',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // Single Checkbox Examples
            const Text(
              'Single Checkbox Examples',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Example 1: Using value property
            AppzCheckbox(
              value: "yes", // Initial state
              label: 'Single checkbox using value property',
              //subtitle: 'This shows the value property pattern',
            ),

            const SizedBox(height: 16),

            // Example 2: Using controller
            AppzCheckbox(
              controller: _singleController,
              label: 'Single checkbox using controller',
              subtitle: 'This shows the controller pattern',
            ),

            const SizedBox(height: 32),

            // Group Checkbox Examples
            const Text(
              'Group Checkbox Examples',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Example 2: Using controller
            AppzCheckbox(
              label: 'Group with controller',
              variant: CheckboxVariant.group,
              controller: _groupController2,
              groupItems: _preferencesGroupItems2,
            ),

            const SizedBox(height: 32),

            // Controller and onTap Examples
            const Text(
              'Controller and onTap Examples',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Example 1: Single checkbox with onTap
            AppzCheckbox(
              controller: _singleController,
              label: 'Single checkbox with onTap callback',
              subtitle: 'Tap to see real-time value updates',
              onTap: () {
                // Get the current value before it gets toggled
                final currentValue = _singleController.value;
                final newValue = currentValue == "yes" ? "no" : "yes";

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Checkbox changing from $currentValue to $newValue'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Example 2: Group checkbox with subtitle only
            AppzCheckbox(
              label: 'This shows the onTap callback pattern',
              variant: CheckboxVariant.group,
              controller: _groupController,
              groupItems: _preferencesGroupItems,
              onTap: () {
                // Show the updated items after toggle (delayed)
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    final updatedIndices = _groupController.selectedIndices;
                    final updatedItems = updatedIndices
                        .map((i) => _preferencesGroupItems[i].label)
                        .toList();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Now selected: ${updatedItems.join(", ")}'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                });
              },
            ),

            const SizedBox(height: 32),

            // Real-time Value Display
            const Text(
              'Real-time Value Display',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Display current values with real-time updates
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Values (Updates in real-time):',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    ListenableBuilder(
                      listenable: _singleController,
                      builder: (context, child) {
                        return Text(
                            'Single checkbox value: ${_singleController.value}');
                      },
                    ),
                    ListenableBuilder(
                      listenable: _groupController,
                      builder: (context, child) {
                        final selectedItems = _groupController.selectedIndices
                            .map((i) => _preferencesGroupItems[i].label)
                            .toList();
                        return Text(
                            'Group selected items: ${selectedItems.join(", ")}');
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Controller Actions
            const Text(
              'Controller Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Single checkbox actions
            const Text('Single Checkbox Actions:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _singleController.toggle(),
                  child: const Text('Toggle'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _singleController.setValue("yes"),
                  child: const Text('Set Yes'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _singleController.setValue("no"),
                  child: const Text('Set No'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Group checkbox actions
            const Text('Group Checkbox Actions:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _groupController.toggleIndex(0),
                  child: const Text('Toggle Index 0'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _groupController.setSelectedIndices([0, 1]),
                  child: const Text('Select 0,1'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _groupController.setSelectedIndices([]),
                  child: const Text('Clear All'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Enable/Disable actions
            const Text('Enable/Disable Actions:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      _singleController.setEnabled(!_singleController.enabled),
                  child: Text(_singleController.enabled
                      ? 'Disable Single'
                      : 'Enable Single'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      _groupController.setEnabled(!_groupController.enabled),
                  child: Text(_groupController.enabled
                      ? 'Disable Group'
                      : 'Enable Group'),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
