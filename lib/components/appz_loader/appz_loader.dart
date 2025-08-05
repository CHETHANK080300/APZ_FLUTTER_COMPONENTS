import 'package:flutter/material.dart';
import '../appz_text/appz_text.dart';
import 'loader_style_config.dart';

class AppzLoader extends StatefulWidget {
  final String? assetPath;
  final String? imageUrl;
  final double? height;
  final double? width;
  final Widget? label;

  const AppzLoader({
    Key? key,
    this.assetPath,
    this.imageUrl,
    this.height,
    this.width,
    this.label,
  }) : super(key: key);

  @override
  State<AppzLoader> createState() => _AppzLoaderState();
}

class _AppzLoaderState extends State<AppzLoader> {
  bool _configLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    await LoaderStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }

    final config = LoaderStyleConfig.instance;
    final double resolvedHeight = widget.height ?? config.size('defaultHeight');
    final double resolvedWidth = widget.width ?? config.size('defaultWidth');

    Widget gifWidget;

    if (widget.assetPath != null) {
      gifWidget = SizedBox(
        height: resolvedHeight,
        width: resolvedWidth,
        child: Image.asset(
          widget.assetPath!,
          fit: BoxFit.fill,
        ),
      );
    } else if (widget.imageUrl != null) {
      gifWidget = SizedBox(
        height: resolvedHeight,
        width: resolvedWidth,
        child: Image.network(
          widget.imageUrl!,
          fit: BoxFit.fill,
        ),
      );
    } else {
      gifWidget = SizedBox(height: resolvedHeight, width: resolvedWidth);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        gifWidget,
        if (widget.label != null) ...[
          const SizedBox(height: 2),
          widget.label!,
        ]
      ],
    );
  }
} 