import 'package:flutter/material.dart';
import 'apz_menu_style_config.dart';
import '../appz_image/appz_image.dart';
import '../appz_image/appz_assets.dart';
import '../appz_text/appz_text.dart';
import '../appz_text/appz_text_style_config.dart';

enum MenuItemType { regular, signout }

class MenuItem {
  final String text;
  final VoidCallback? onTap;
  final MenuItemType type;

  const MenuItem({
    required this.text,
    this.onTap,
    this.type = MenuItemType.regular,
  });
}

class ApzMenu extends StatefulWidget {
  final List<MenuItem> items;
  final VoidCallback? onClose;

  const ApzMenu({
    super.key,
    required this.items,
    this.onClose,
  });

  @override
  State<ApzMenu> createState() => _ApzMenuState();
}

class _ApzMenuState extends State<ApzMenu> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        ApzMenuStyleConfig.instance.load(),
        AppzTextStyleConfig.instance.load(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Show nothing while loading
        }
        
        final config = ApzMenuStyleConfig.instance;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Close button above menu
            GestureDetector(
              onTap: widget.onClose,
              child: Container(
                padding: EdgeInsets.all(config.getCloseButtonPadding()),
                decoration: BoxDecoration(
                  color: config.getCloseButtonBackgroundColor(),
                  borderRadius: BorderRadius.circular(config.getCloseButtonBorderRadius()),
                ),
                child: AppzImage(
                  assetName: AppzIcons.closeCircle1,
                  size: AppzImageSize.square(size: config.getCloseButtonIconSize()),
                ),
              ),
            ),
            const SizedBox(height: 16),
                         // Menu below close button
             Container(
               constraints: const BoxConstraints(maxWidth: 300),
               decoration: BoxDecoration(
                 color: config.getMenuBackgroundColor(),
                 borderRadius: BorderRadius.circular(config.getMenuBorderRadius()),
               ),
                             child: Padding(
                 padding: EdgeInsets.all(config.getMenuPadding()),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     // Menu items with spacing
                     ...widget.items.where((item) => item.type == MenuItemType.regular).map((item) => 
                       _buildMenuItem(item, config)
                     ).toList().asMap().entries.map((entry) {
                       final index = entry.key;
                       final item = entry.value;
                       return Column(
                         children: [
                           item,
                           if (index < widget.items.where((item) => item.type == MenuItemType.regular).length - 1)
                             SizedBox(height: config.getMenuItemSpacing()),
                         ],
                       );
                     }).toList(),
                     
                     // Spacing between regular items and signout
                     if (widget.items.any((item) => item.type == MenuItemType.signout) && 
                         widget.items.any((item) => item.type == MenuItemType.regular))
                       SizedBox(height: config.getMenuItemSpacing()), // Use same spacing as menu items (32px)
                     
                     // Signout item
                     ...widget.items.where((item) => item.type == MenuItemType.signout).map((item) => 
                       _buildSignoutItem(item, config)
                     ),
                   ],
                 ),
               ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(MenuItem item, ApzMenuStyleConfig config) {
    return Container(
      padding: EdgeInsets.only(
        top: config.getMenuItemPaddingTop(),
        bottom: config.getMenuItemPaddingBottom(),
      ),
      child: GestureDetector(
        onTap: item.onTap,
        child: AppzText(
          item.text,
          category: 'menuItem',
          fontWeight: 'regular',
          color: config.getMenuItemTextColor(),
        ),
      ),
    );
  }



  Widget _buildSignoutItem(MenuItem item, ApzMenuStyleConfig config) {
    return Container(
      height: config.getSignoutHeight(),
      width: config.getSignoutWidth(),
      padding: EdgeInsets.symmetric(
        horizontal: config.getSignoutPaddingHorizontal(),
        vertical: config.getSignoutPaddingTop(),
      ),
      decoration: BoxDecoration(
        color: config.getSignoutBackgroundColor(),
        border: Border.all(
          color: config.getSignoutBorderColor(),
          width: config.getSignoutBorderWidth(),
        ),
        borderRadius: BorderRadius.circular(config.getSignoutBorderRadius()),
      ),
      child: GestureDetector(
        onTap: item.onTap,
        child: Center(
          child: AppzText(
            item.text,
            category: 'menuItem',
            fontWeight: 'regular',
            color: config.getSignoutTextColor(),
          ),
        ),
      ),
    );
  }
} 