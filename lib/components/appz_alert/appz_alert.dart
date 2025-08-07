/*import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'alert_style_config.dart';
import '../appz_text/appz_text.dart';
import '../appz_image/appz_image.dart';
import '../apz_button/appz_button.dart';

enum AppzAlertMessageType { success, error, info, confirmation }

class AppzAlert extends StatelessWidget {
  final String title;
  final String message;
  final AppzAlertMessageType messageType;
  final List<String> buttons;
  final Function(String)? onButtonPressed;

  const AppzAlert({
    Key? key,
    required this.title,
    required this.message,
    required this.messageType,
    this.buttons = const ['Okay'],
    this.onButtonPressed,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required AppzAlertMessageType messageType,
    List<String> buttons = const ['Okay'],
    Function(String)? onButtonPressed,
    Alignment alignment = Alignment.center,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Align(
          alignment: alignment,
          child: AppzAlert(
            title: title,
            message: message,
            messageType: messageType,
            buttons: buttons,
            onButtonPressed: onButtonPressed,
          ),
        );
      },
    );
  }

  String _getIconPath() {
    switch (messageType) {
      case AppzAlertMessageType.success:
        return 'packages/apz_flutter_components/assets/icons/success-filled.svg';
      case AppzAlertMessageType.error:
        return 'packages/apz_flutter_components/assets/icons/error-filled.svg';
      case AppzAlertMessageType.info:
        return 'packages/apz_flutter_components/assets/icons/info.svg';
      case AppzAlertMessageType.confirmation:
        return 'packages/apz_flutter_components/assets/icons/info-circle.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AlertStyleConfig.instance;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: config.size('width'),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: config.getBackgroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.size('borderRadius')),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(config.size('contentPadding')),
              child: Column(
                children: [
                  AppzImage(
                    assetName: _getIconPath(),
                    size: AppzImageSize.square(size: config.size('iconSize')),
                  ),
                  SizedBox(height: config.size('iconSpacing')),
                  AppzText(
                    title,
                    category: 'heading',
                    fontWeight: 'bold',
                    color: config.getTitleColor(),
                  ),
                  SizedBox(height: config.size('iconSpacing')),
                  AppzText(
                    message,
                    category: 'paragraph',
                    fontWeight: 'regular',
                    color: config.getDescriptionColor(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(config.size('buttonContainerPadding')),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(buttons.length, (index) {
                  return Expanded(
                    child: AppzButton(
                      label: buttons[index],
                      appearance: index == 0
                          ? AppzButtonAppearance.primary
                          : AppzButtonAppearance.secondary,
                      size: AppzButtonSize.medium,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onButtonPressed?.call(buttons[index]);
                      },
                    ),
                  );
                }).expand((widget) => [
                  widget,
                  if (buttons.length > 1 && widget != (buttons.length -1))
                    SizedBox(width: config.size('buttonSpacing'))
                ]).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
} */
import 'package:flutter/material.dart';
import 'alert_style_config.dart';
import '../appz_text/appz_text.dart';
import '../appz_image/appz_image.dart';
import '../apz_button/appz_button.dart';

enum AppzAlertMessageType { success, error, info, warning }

class AppzAlert extends StatelessWidget {
  final String title;
  final String message;
  final AppzAlertMessageType messageType;
  final List<String> buttons;
  final Function(String)? onButtonPressed;
  final bool showCloseIcon;

  const AppzAlert({
    Key? key,
    required this.title,
    required this.message,
    required this.messageType,
    this.buttons = const ['Okay'],
    this.onButtonPressed,
    this.showCloseIcon = false,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required AppzAlertMessageType messageType,
    List<String> buttons = const ['Okay'],
    Function(String)? onButtonPressed,
    Alignment alignment = Alignment.center,
    bool showCloseIcon = false,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Align(
          alignment: alignment,
          child: AppzAlert(
            title: title,
            message: message,
            messageType: messageType,
            buttons: buttons,
            onButtonPressed: onButtonPressed,
            showCloseIcon: showCloseIcon,
          ),
        );
      },
    );
  }

  /*String _getIconPath(String iconName) {
    return 'packages/apz_flutter_components/assets/icons/$iconName.svg';
  }*/
  String _getIconPath() {
    switch (messageType) {
      case AppzAlertMessageType.success:
        return 'packages/apz_flutter_components/assets/icons/success-filled.svg';
      case AppzAlertMessageType.error:
        return 'packages/apz_flutter_components/assets/icons/error-filled.svg';
      case AppzAlertMessageType.info:
        return 'packages/apz_flutter_components/assets/icons/info-filled.svg';
      case AppzAlertMessageType.warning:
        return 'packages/apz_flutter_components/assets/icons/warning-filled.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AlertStyleConfig.instance;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: config.size('width'),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.size('borderRadius')),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                config.size('headerPaddingHorizontal'),
                config.size('headerPaddingVertical'),
                config.size('headerPaddingHorizontal'),
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppzText(
                      title,
                      category: 'heading',
                      fontWeight: 'bold',
                      color: config.getTitleColor(),
                    ),
                  ),
                  if (showCloseIcon)
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: AppzImage(
                        assetName: 'packages/apz_flutter_components/assets/icons/close-circle-1.svg',
                        size: AppzImageSize.square(size: config.size('closeIconSize')),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.all(config.size('contentPadding')),
              child: Row(
                children: [
                  AppzImage(
                    assetName: _getIconPath(),
                    size: AppzImageSize.square(size: config.size('iconSize')),
                  ),
                  SizedBox(width: config.size('iconSpacing')),
                  Expanded(
                    child: AppzText(
                      message,
                      category: 'paragraph',
                      fontWeight: 'regular',
                      color: config.getDescriptionColor(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(config.size('buttonContainerPadding')),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (buttons.length > 1)
                    Expanded(
                      child: AppzButton(
                        label: buttons[1],
                        appearance: AppzButtonAppearance.secondary,
                        size: AppzButtonSize.medium,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onButtonPressed?.call(buttons[1]);
                        },
                      ),
                    ),
                  if (buttons.length > 1)
                    SizedBox(width: config.size('buttonSpacing')),
                  Expanded(
                    child: AppzButton(
                      label: buttons[0],
                      appearance: AppzButtonAppearance.primary,
                      size: AppzButtonSize.medium,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onButtonPressed?.call(buttons[0]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 