import 'package:flutter/material.dart';
import 'dart:convert';

enum ToggleSwitchSize { small, large }

class DynamicToggleSwitch extends StatefulWidget {
  final bool isOn;
  final bool isDisabled;
  final ToggleSwitchSize size;
  final String? text;
  final String? configPath;
  final String? masterPath;
  final Function(bool)? onChanged;

  const DynamicToggleSwitch({
    Key? key,
    this.isOn = false,
    this.isDisabled = false,
    this.size = ToggleSwitchSize.large,
    this.text,
    this.configPath,
    this.masterPath,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DynamicToggleSwitch> createState() => _DynamicToggleSwitchState();
}

class _DynamicToggleSwitchState extends State<DynamicToggleSwitch> with SingleTickerProviderStateMixin {
  Map<String, dynamic> _config = {};
  Map<String, dynamic> _master = {};
  late AnimationController _animationController;
  late Animation<double> _thumbPosition;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: widget.isOn ? 1.0 : 0.0,
    );
    _thumbPosition = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadConfigs();
  }

  @override
  void didUpdateWidget(DynamicToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOn != widget.isOn) {
      if (widget.isOn) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  Future<void> _loadConfigs() async {
    try {
      final String configString = await DefaultAssetBundle.of(context)
          .loadString(widget.configPath ?? 'assets/toggle_switch_ui_config.json');
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

  String _getCurrentState() {
    if (widget.isDisabled) return 'disabled';
    return widget.isOn ? 'on' : 'off';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _config.isEmpty || _master.isEmpty) {
      return const SizedBox.shrink();
    }
    final toggleConfig = _config['toggleSwitch'];
    final sizeKey = widget.size == ToggleSwitchSize.small ? 'small' : 'large';
    final sizes = toggleConfig['sizes'][sizeKey];
    final colors = toggleConfig['colors'][_getCurrentState()];
    final textConfig = toggleConfig['text'];

    final double width = _resolveDouble(sizes['width']);
    final double height = _resolveDouble(sizes['height']);
    final double thumbSize = _resolveDouble(sizes['thumbSize']);
    final double padding = _resolveDouble(sizes['padding']);
    final double trackRadius = height / 2;
    final double thumbPositionOn = width - thumbSize - padding;
    final double thumbPositionOff = padding;

    return GestureDetector(
      onTap: widget.isDisabled
          ? null
          : () {
              widget.onChanged?.call(!widget.isOn);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _thumbPosition,
            builder: (context, child) {
              return Container(
                width: width,
                height: height,
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: _resolveColor(colors['backgroundColor']),
                  borderRadius: BorderRadius.circular(trackRadius),
                  border: Border.all(
                    color: _resolveColor(colors['borderColor']),
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      left: thumbPositionOff + (thumbPositionOn - thumbPositionOff) * _thumbPosition.value,
                      child: Container(
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          color: _resolveColor(colors['thumbColor']),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (widget.text != null) ...[
            SizedBox(width: _resolveDouble(textConfig['spacing'][sizeKey])),
            Text(
              widget.text!,
              style: TextStyle(
                fontFamily: _resolveString(textConfig['fontFamily']),
                fontSize: _resolveDouble(textConfig['fontSizes'][sizeKey]),
                color: _resolveColor(colors['textColor']),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}