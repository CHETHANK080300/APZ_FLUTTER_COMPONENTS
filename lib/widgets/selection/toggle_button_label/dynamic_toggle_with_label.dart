import 'package:flutter/material.dart';
import 'dart:convert';

enum ToggleWithLabelSize { small, large }

class DynamicToggleWithLabel extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleWithLabelSize size;
  final String inactiveText;
  final String activeText;
  final bool isDisabled;
  final String? configPath;
  final String? masterPath;

  const DynamicToggleWithLabel({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.size = ToggleWithLabelSize.large,
    this.inactiveText = 'No',
    this.activeText = 'Yes',
    this.isDisabled = false,
    this.configPath,
    this.masterPath,
  }) : super(key: key);

  @override
  State<DynamicToggleWithLabel> createState() => _DynamicToggleWithLabelState();
}

class _DynamicToggleWithLabelState extends State<DynamicToggleWithLabel> {
  Map<String, dynamic> _config = {};
  Map<String, dynamic> _master = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    try {
      final String configString = await DefaultAssetBundle.of(context)
          .loadString(widget.configPath ?? 'assets/toggle_with_label_ui_config.json');
      final String masterString = await DefaultAssetBundle.of(context)
          .loadString(widget.masterPath ?? 'assets/master_json.json');
      final config = json.decode(configString) as Map<String, dynamic>;
      final master = json.decode(masterString) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _config = config;
          _master = master;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _config = {};
          _master = {};
          _loading = false;
        });
      }
    }
  }

  Color _resolveColor(dynamic token) {
    final value = _master[token] ?? token;
    if (value is String && value.startsWith('#')) {
      return Color(int.parse(value.replaceAll('#', '0xFF')));
    }
    return Colors.transparent;
  }

  double _resolveDouble(dynamic token) {
    final value = _master[token] ?? token;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  String _resolveString(dynamic token) {
    final value = _master[token] ?? token;
    if (value is String) return value;
    return '';
  }

  FontWeight _resolveFontWeight(dynamic token) {
    final value = _master[token] ?? token;
    if (value is int) {
      switch (value) {
        case 100:
          return FontWeight.w100;
        case 200:
          return FontWeight.w200;
        case 300:
          return FontWeight.w300;
        case 400:
          return FontWeight.w400;
        case 500:
          return FontWeight.w500;
        case 600:
          return FontWeight.w600;
        case 700:
          return FontWeight.w700;
        case 800:
          return FontWeight.w800;
        case 900:
          return FontWeight.w900;
        default:
          return FontWeight.normal;
      }
    }
    return FontWeight.normal;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _config.isEmpty || _master.isEmpty) {
      return const SizedBox.shrink();
    }
    final config = _config['toggleWithLabel'];
    final sizeKey = widget.size == ToggleWithLabelSize.small ? 'small' : 'large';
    final sizes = config['sizes'][sizeKey];
    final colors = config['colors'];
    final textConfig = config['text'];

    Widget buildToggleButton({required String text, required bool selected, required VoidCallback onTap, required bool disabled}) {
      final stateColors = disabled
          ? colors['disabled']
          : selected
              ? colors['selected']
              : colors['unselected'];
      return AnimatedContainer(
        duration: Duration(milliseconds: config['animation']['duration']),
        curve: Curves.easeInOut,
        width: _resolveDouble(sizes['width']) / 2 - 2,
        height: _resolveDouble(sizes['height']),
        decoration: BoxDecoration(
          color: _resolveColor(stateColors['backgroundColor']),
          borderRadius: BorderRadius.circular(_resolveDouble(sizes['borderRadius'])),
          border: Border.all(
            color: _resolveColor(stateColors['borderColor']),
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(_resolveDouble(sizes['borderRadius'])),
            onTap: disabled ? null : onTap,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: _resolveString(textConfig['fontFamily']),
                  fontWeight: _resolveFontWeight(textConfig['fontWeight']),
                  fontSize: _resolveDouble(sizes['fontSize']),
                  color: _resolveColor(stateColors['textColor']),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: _resolveString(textConfig['fontFamily']),
            fontWeight: _resolveFontWeight(textConfig['labelFontWeight']),
            fontSize: _resolveDouble(sizes['labelFontSize']),
            color: _resolveColor(colors['label']['textColor']),
          ),
        ),
        SizedBox(height: _resolveDouble(sizes['spacing'])),
        Container(
          width: _resolveDouble(sizes['width']),
          height: _resolveDouble(sizes['height']),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_resolveDouble(sizes['borderRadius'])),
            border: Border.all(
              color: _resolveColor(colors['unselected']['borderColor']),
              width: 1.0,
            ),
            color: _resolveColor(colors['unselected']['backgroundColor']),
          ),
          child: Row(
            children: [
              buildToggleButton(
                text: widget.inactiveText,
                selected: !widget.value,
                onTap: () => widget.onChanged(false),
                disabled: widget.isDisabled,
              ),
              buildToggleButton(
                text: widget.activeText,
                selected: widget.value,
                onTap: () => widget.onChanged(true),
                disabled: widget.isDisabled,
              ),
            ],
          ),
        ),
      ],
    );
  }
}