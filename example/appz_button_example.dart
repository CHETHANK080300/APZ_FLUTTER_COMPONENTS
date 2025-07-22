import 'package:apz_flutter_components/components/apz_button/appz_button.dart';
import 'package:flutter/material.dart';

class AppzButtonExample extends StatelessWidget {
  const AppzButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppzButton Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Primary Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Small'),
            AppzButton(
              label: 'Primary Small',
              size: AppzButtonSize.small,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('Medium'),
            AppzButton(
              label: 'Primary Medium',
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('Large'),
            AppzButton(
              label: 'Primary Large',
              size: AppzButtonSize.large,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('With Leading Icon'),
            AppzButton(
              label: 'Icon',
              iconLeading: Icons.add,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('With Trailing Icon'),
            AppzButton(
              label: 'Icon',
              iconTrailing: Icons.arrow_forward,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('Disabled'),
            AppzButton(
              label: 'Disabled',
              disabled: true,
              onPressed: () {},
            ),
            const SizedBox(height: 32),
            const Text('Secondary Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            AppzButton(
              label: 'Secondary',
              appearance: AppzButtonAppearance.secondary,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('Tertiary Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            AppzButton(
              label: 'Tertiary',
              appearance: AppzButtonAppearance.tertiary,
              onPressed: () {},
            ),
             const SizedBox(height: 16),
            const Text('Tertiary with Icon'),
            AppzButton(
              label: 'Tertiary',
              appearance: AppzButtonAppearance.tertiary,
              iconLeading: Icons.link,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
