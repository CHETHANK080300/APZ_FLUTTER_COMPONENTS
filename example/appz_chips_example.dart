import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_chips/appz_chips.dart';
import 'package:apz_flutter_components/components/appz_text/appz_text.dart';

class AppzChipsExample extends StatefulWidget {
  const AppzChipsExample({Key? key}) : super(key: key);

  @override
  State<AppzChipsExample> createState() => _AppzChipsExampleState();
}

class _AppzChipsExampleState extends State<AppzChipsExample> {
  List<Map<String, String>> chipsList = [
    {'chipName': 'IRCTC', 'chipState': 'Active'},
    {'chipName': 'Loan', 'chipState': 'Default'},
    {'chipName': 'PAN', 'chipState': 'Disabled'},
    {'chipName': 'Aadhaar', 'chipState': 'Disabled'},
  ];

  List<Map<String, String>> chipsWithLeadingIcon = [
    {'chipName': 'Star', 'chipState': 'Active'},
    {'chipName': 'Heart', 'chipState': 'Default'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppzText(
            'Bookmarked',
            category: 'label',
            fontWeight: 'regular',
          ),
          const SizedBox(height: 24),
          AppzChips(
            chips: chipsList,
            trailingIcon: true,
            trailingIconPath: 'assets/icons/close-1.svg',
            onRemove: (index) {
              setState(() {
                chipsList.removeAt(index);
              });
            },
            onStateChange: (index, newState) {
              setState(() {
                chipsList[index]['chipState'] = newState;
              });
            },
          ),
          const SizedBox(height: 24),
          AppzText(
            'With Leading Icon',
            category: 'label',
            fontWeight: 'regular',
          ),
          const SizedBox(height: 24),
          AppzChips(
            chips: chipsWithLeadingIcon,
            leadingIcon: true,
            leadingIconPath: 'assets/icons/star.svg',
            trailingIcon: true,
            trailingIconPath: 'assets/icons/close-1.svg',
            onStateChange: (index, newState) {
              setState(() {
                chipsWithLeadingIcon[index]['chipState'] = newState;
              });
            },
          ),
        ],
      ),
    );
  }
}
