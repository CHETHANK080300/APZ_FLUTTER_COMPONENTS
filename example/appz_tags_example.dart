import 'package:flutter/material.dart';
import '../lib/components/appz_tags/appz_tags.dart';
import '../lib/components/appz_image/appz_assets.dart';

class AppzTagsExample extends StatefulWidget {
  const AppzTagsExample({Key? key}) : super(key: key);

  @override
  State<AppzTagsExample> createState() => _AppzTagsExampleState();
}

class _AppzTagsExampleState extends State<AppzTagsExample> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppzTags Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rounded Tags',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rounded,
                  onTap: () => print('Default rounded tag tapped'),
                ),
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rounded,
                  trailingIconPath: AppzIcons.closeCircle1,
                  onTap: () => print('Default rounded tag with trailing icon tapped'),
                ),
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rounded,
                  leadingIconPath: AppzIcons.star,
                  onTap: () => print('Default rounded tag with leading icon tapped'),
                ),
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rounded,
                  leadingIconPath: AppzIcons.star,
                  trailingIconPath: AppzIcons.closeCircle1,
                  onTap: () => print('Default rounded tag with both icons tapped'),
                ),
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rounded,
                  leadingIconPath: AppzIcons.star,
                  trailingIconPath: AppzIcons.closeCircle1,
                  onTap: () => print('Default rounded tag with both icons tapped'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Rectangle Tags',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rectangle,
                  onTap: () => print('Default rectangle tag tapped'),
                ),
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rectangle,
                  trailingIconPath: AppzIcons.closeCircle1,
                  onTap: () => print('Default rectangle tag with trailing icon tapped'),
                ),
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rectangle,
                  leadingIconPath: AppzIcons.star,
                  onTap: () => print('Default rectangle tag with leading icon tapped'),
                ),
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rectangle,
                  leadingIconPath: AppzIcons.star,
                  trailingIconPath: AppzIcons.closeCircle1,
                  onTap: () => print('Default rectangle tag with both icons tapped'),
                ),
                AppzTags(
                  text: 'Text',
                  type: AppzTagType.rectangle,
                  leadingIconPath: AppzIcons.star,
                  trailingIconPath: AppzIcons.closeCircle1,
                  onTap: () => print('Default rectangle tag with both icons tapped'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
} 