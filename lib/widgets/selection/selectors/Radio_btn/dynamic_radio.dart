import 'package:flutter/material.dart';
import 'dart:convert';

class DynamicRadio extends StatefulWidget {
  final bool isChecked;
  final bool isDefault;
  final String? title;
  final String? subtitle;
  final String? configPath;
  final String? masterPath;
  final Function(bool)? onChanged;
  final bool isDisabled;
  final String size;
  final bool showError;

  const DynamicRadio({
    Key? key,
    this.isChecked = false,
    this.isDefault = false,
    this.title,
    this.subtitle,
    this.configPath,
    this.masterPath,
    this.onChanged,
    this.isDisabled = false,
    this.size = 'medium',
    this.showError = false,
  }) : super(key: key);

  @override
  State<DynamicRadio> createState() => _DynamicRadioState();
}

class _DynamicRadioState extends State<DynamicRadio> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Map<String, dynamic> _config = {};
  Map<String, dynamic> _master = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    try {
      final String configString = await DefaultAssetBundle.of(context)
          .loadString(widget.configPath ?? 'assets/radio_ui_config.json');
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
    if (widget.showError) return 'error';
    if (widget.isDisabled) return 'disabled';
    if (widget.isChecked) return 'selected';
    return 'unselected';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _config.isEmpty || _master.isEmpty) {
      return const SizedBox.shrink();
    }
    final radioConfig = _config['radio'];
    final sizes = radioConfig['sizes'][widget.size];
    final colors = radioConfig['colors'][_getCurrentState()];
    final textConfig = radioConfig['text'];

    return GestureDetector(
      // onTapDown: (_) => _animationController.forward(),
      // onTapUp: (_) => _animationController.reverse(),
      // onTapCancel: () => _animationController.reverse(),
      onTap: widget.isDisabled ? null : () {
        widget.onChanged?.call(!widget.isChecked);
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                // Radio button
                Container(
                  width: _resolveDouble(sizes['outerRadius']) * 2.0,
                  height: _resolveDouble(sizes['outerRadius']) * 2.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _resolveColor(colors['borderColor']),
                      width: _resolveDouble(sizes['borderWidth']),
                    ),
                  ),
                  child: Center(
                    child: widget.isChecked
                        ? Container(
                            width: _resolveDouble(sizes['innerRadius']) * 2.0,
                            height: _resolveDouble(sizes['innerRadius']) * 2.0,
                            decoration: BoxDecoration(
                              color: _resolveColor(colors['innerColor']),
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  ),
                ),
                // Text content
                if (widget.title != null || widget.subtitle != null) ...[
                  SizedBox(width: _resolveDouble(textConfig['spacing'][widget.size])),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null)
                          Text(
                            widget.title!,
                            style: TextStyle(
                              fontFamily: _resolveString(textConfig['fontFamily']),
                              fontSize: _resolveDouble(textConfig['fontSizes'][widget.size]),
                              color: _resolveColor(
                                widget.isDisabled
                                    ? textConfig['colors']['disabled']
                                    : widget.showError
                                        ? textConfig['colors']['error']
                                        : textConfig['colors']['default'],
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              fontFamily: _resolveString(textConfig['fontFamily']),
                              fontSize: _resolveDouble(textConfig['fontSizes'][widget.size]) - 2,
                              color: _resolveColor(
                                widget.isDisabled
                                    ? textConfig['colors']['disabled']
                                    : textConfig['colors']['default'],
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
} 