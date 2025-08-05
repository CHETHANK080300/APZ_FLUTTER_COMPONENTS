import 'package:flutter/material.dart';
import '../lib/components/apz_menu/apz_menu.dart';
import '../lib/components/apz_button/appz_button.dart';

class ApzMenuExample extends StatefulWidget {
  const ApzMenuExample({super.key});

  @override
  State<ApzMenuExample> createState() => _ApzMenuExampleState();
}

class _ApzMenuExampleState extends State<ApzMenuExample> {
  bool _isMenuVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ApzMenu Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ApzMenu Component Demo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                AppzButton(
                  label: _isMenuVisible ? 'Hide Menu' : 'Show Menu',
                  appearance: AppzButtonAppearance.primary,
                  onPressed: () {
                    print('Button pressed, menu visibility: $_isMenuVisible');
                    setState(() {
                      _isMenuVisible = !_isMenuVisible;
                    });
                    print('Menu visibility changed to: $_isMenuVisible');
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Menu is ${_isMenuVisible ? 'visible' : 'hidden'}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  'Debug: Menu should appear in top-right corner',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (_isMenuVisible)
            Positioned(
              top: 80,
              right: 16,
              child: ApzMenu(
                items: [
                  MenuItem(
                    text: 'My performance',
                    onTap: () {
                      print('My performance tapped');
                      setState(() {
                        _isMenuVisible = false;
                      });
                    },
                    type: MenuItemType.regular,
                  ),
                  MenuItem(
                    text: 'Certifications',
                    onTap: () {
                      print('Certifications tapped');
                      setState(() {
                        _isMenuVisible = false;
                      });
                    },
                    type: MenuItemType.regular,
                  ),
                  MenuItem(
                    text: 'Training Hub',
                    onTap: () {
                      print('Training Hub tapped');
                      setState(() {
                        _isMenuVisible = false;
                      });
                    },
                    type: MenuItemType.regular,
                  ),
                  MenuItem(
                    text: 'Contacts',
                    onTap: () {
                      print('Contacts tapped');
                      setState(() {
                        _isMenuVisible = false;
                      });
                    },
                    type: MenuItemType.regular,
                  ),
                  MenuItem(
                    text: 'Settings',
                    onTap: () {
                      print('Settings tapped');
                      setState(() {
                        _isMenuVisible = false;
                      });
                    },
                    type: MenuItemType.regular,
                  ),
                  MenuItem(
                    text: 'Sign out',
                    onTap: () {
                      print('Sign out tapped');
                      setState(() {
                        _isMenuVisible = false;
                      });
                    },
                    type: MenuItemType.signout,
                  ),
                ],
                onClose: () {
                  print('Close button tapped');
                  setState(() {
                    _isMenuVisible = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
} 