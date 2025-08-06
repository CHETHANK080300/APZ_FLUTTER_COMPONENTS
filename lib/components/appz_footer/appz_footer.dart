import 'package:flutter/material.dart';
import 'footer_style_config.dart';
import '../apz_button/appz_button.dart';

enum AppzFooterVariant {
  splitButtons,
  fullSizeButtons,
}

class AppzFooter extends StatefulWidget {
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryButtonTap;
  final VoidCallback? onSecondaryButtonTap;
  final AppzFooterVariant variant;

  const AppzFooter({
    Key? key,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryButtonTap,
    this.onSecondaryButtonTap,
    this.variant = AppzFooterVariant.splitButtons,
  }) : super(key: key);

  @override
  State<AppzFooter> createState() => _AppzFooterState();
}

class _AppzFooterState extends State<AppzFooter> {
  bool _configLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    await FooterStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }

    final config = FooterStyleConfig.instance;

    return Container(
      padding: EdgeInsets.all(config.getPadding()),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: config.getBackgroundColor(),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: config.getBorderWidth(),
            color: config.getBorderColor(),
          ),
          borderRadius: BorderRadius.circular(config.getBorderRadius()),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.variant == AppzFooterVariant.splitButtons) ...[
            Container(
              width: config.getWidth(),
              padding: EdgeInsets.all(config.getButtonContainerPadding()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.secondaryButtonText != null) ...[
                    Expanded(
                      child: AppzButton(
                        label: widget.secondaryButtonText!,
                        appearance: AppzButtonAppearance.secondary,
                        size: AppzButtonSize.medium,
                        onPressed: widget.onSecondaryButtonTap,
                      ),
                    ),
                    SizedBox(width: config.getButtonSpacing()),
                  ],
                  if (widget.primaryButtonText != null)
                    Expanded(
                      child: AppzButton(
                        label: widget.primaryButtonText!,
                        appearance: AppzButtonAppearance.primary,
                        size: AppzButtonSize.medium,
                        onPressed: widget.onPrimaryButtonTap,
                      ),
                    ),
                ],
              ),
            ),
          ] else if (widget.variant == AppzFooterVariant.fullSizeButtons) ...[
            Container(
              width: config.getWidth(),
              padding: EdgeInsets.all(config.getButtonContainerPadding()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.primaryButtonText != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: AppzButton(
                        label: widget.primaryButtonText!,
                        appearance: AppzButtonAppearance.primary,
                        size: AppzButtonSize.medium,
                        onPressed: widget.onPrimaryButtonTap,
                      ),
                    ),
                    SizedBox(height: config.getButtonSpacing()),
                  ],
                  if (widget.secondaryButtonText != null)
                    SizedBox(
                      width: double.infinity,
                      child: AppzButton(
                        label: widget.secondaryButtonText!,
                        appearance: AppzButtonAppearance.secondary,
                        size: AppzButtonSize.medium,
                        onPressed: widget.onSecondaryButtonTap,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
} 