import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_toggle/appz_toggle.dart';

class AppzToggleExample extends StatefulWidget {
  const AppzToggleExample({Key? key}) : super(key: key);

  @override
  State<AppzToggleExample> createState() => _AppzToggleExampleState();
}

class _AppzToggleExampleState extends State<AppzToggleExample> {
  final AppzToggleController _controller = AppzToggleController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appz Toggle Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Single Toggle with Controller',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            AppzToggleSwitch(
              label: 'Controlled Toggle',
              subtitle: 'This shows the controller pattern',
              controller: _controller,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _controller.toggle()),
                  child: const Text('Toggle'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _controller.setValue(true)),
                  child: const Text('Set On'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _controller.setValue(false)),
                  child: const Text('Set Off'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => setState(
                      () => _controller.setEnabled(!_controller.enabled)),
                  child: Text(_controller.enabled ? 'Disable' : 'Enable'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return Text(
                  'Current value: ${_controller.isToggled ? 'On' : 'Off'} | Enabled: ${_controller.enabled ? 'Yes' : 'No'}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text('Primary Appearance'),
            const SizedBox(height: 8),
            AppzToggleSwitch(
              label: 'Label',
              // subtitle: 'Subtitle',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text('Secondary Appearance'),
            const SizedBox(height: 8),
            AppzToggleSwitch(
              label: 'Label',
              subtitle: 'Subtitle',
              appearance: AppzToggleAppearance.secondary,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text('Tertiary Appearance'),
            const SizedBox(height: 8),
            AppzToggleSwitch(
              label: 'Label',
              subtitle: 'Subtitle',
              appearance: AppzToggleAppearance.tertiary,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
