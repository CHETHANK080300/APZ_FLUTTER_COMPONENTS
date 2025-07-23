import 'package:apz_flutter_components/components/appz_dropdown_field/dropdown_style_config.dart';
import 'package:flutter/material.dart';

enum LabelPosition { vertical, horizontal }

class AppzDropdownField extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;
  final LabelPosition labelPosition;
  final bool enabled;
  final bool isMandatory;
  final String? errorText;
  final bool showFilledStyle;
  final ValueNotifier<String?>? controller;

  const AppzDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.labelPosition = LabelPosition.vertical,
    this.enabled = true,
    this.isMandatory = false,
    this.errorText,
    this.showFilledStyle = false,
    this.controller,
  });

  @override
  State<AppzDropdownField> createState() => _AppzDropdownFieldState();
}

class _AppzDropdownFieldState extends State<AppzDropdownField> {
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _dropdownKey = GlobalKey();
  bool _isOpen = false;
  bool _isHovered = false;
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    widget.controller?.value = _selectedItem;
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _insertOverlay();
    }
  }

  void _insertOverlay() {
    final RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + (DropdownStyleConfig.instance.defaultStyle.paddingVertical ?? 8) / 2),
              child: SizedBox(
                width: size.width,
                child: Material(
                  color: Colors.transparent,
                  elevation: DropdownStyleConfig.instance.defaultStyle.elevation ?? 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      DropdownStyleConfig.instance.defaultStyle.borderRadius,
                    ),
                    child: Container(
                      color: DropdownStyleConfig.instance.defaultStyle.backgroundColor,
                      constraints: BoxConstraints(
                        maxHeight: DropdownStyleConfig.instance.defaultStyle.dropdownMaxHeight ?? 220,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final isSelected = item == _selectedItem;
                          bool isHovered = false;

                          return StatefulBuilder(
                            builder: (context, setHoverState) {
                              return MouseRegion(
                                onEnter: (_) => setHoverState(() => isHovered = true),
                                onExit: (_) => setHoverState(() => isHovered = false),
                                child: InkWell(
                                  onTap: () {
                                    setState(() => _selectedItem = item);
                                    widget.controller?.value = item;
                                    widget.onChanged(item);
                                    _removeOverlay();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: DropdownStyleConfig.instance.defaultStyle.paddingVertical ?? 10,
                                      horizontal: DropdownStyleConfig.instance.defaultStyle.paddingHorizontal ?? 12,
                                    ),
                                    color: isSelected
                                        ? DropdownStyleConfig.instance.selected.itemBackgroundColor
                                        : isHovered
                                            ? DropdownStyleConfig.instance.hover.itemBackgroundColor
                                            : DropdownStyleConfig.instance.defaultStyle.backgroundColor,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: DropdownStyleConfig.instance.defaultStyle.fontSize ?? 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? DropdownStyleConfig.instance.selected.textColor
                                            : DropdownStyleConfig.instance.defaultStyle.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry.remove();
    setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      color: _getLabelColor(),
      fontSize: DropdownStyleConfig.instance.defaultStyle.labelFontSize,
    );

    final label = RichText(
      text: TextSpan(
        text: widget.label,
        style: labelStyle,
        children: widget.isMandatory
            ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
            : [],
      ),
    );

    final dropdownField = FormField<String>(
      validator: (value) {
        if (widget.isMandatory && (_selectedItem == null || _selectedItem!.isEmpty)) {
          return 'Please select ${widget.label.toLowerCase()}';
        }
        return null;
      },
      builder: (field) {
        final showError = field.hasError || widget.errorText != null;
        final errorText = field.errorText ?? widget.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onTap: widget.enabled ? _toggleDropdown : null,
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: Container(
                    key: _dropdownKey,
                    height: DropdownStyleConfig.instance.defaultStyle.paddingVertical != null ? DropdownStyleConfig.instance.defaultStyle.paddingVertical! * 2 + 20 : 44,
                    padding: EdgeInsets.symmetric(
                      vertical: DropdownStyleConfig.instance.defaultStyle.paddingVertical ?? 12,
                      horizontal: DropdownStyleConfig.instance.defaultStyle.paddingHorizontal ?? 16,
                    ),
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(showError),
                      borderRadius: BorderRadius.circular(
                        DropdownStyleConfig.instance.defaultStyle.borderRadius,
                      ),
                      border: Border.all(
                        color: _getBorderColor(showError),
                        width: DropdownStyleConfig.instance.focused.borderWidth ?? 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedItem ?? 'Please select',
                          style: TextStyle(
                            color: _getTextColor(showError),
                            fontSize: DropdownStyleConfig.instance.defaultStyle.fontSize,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (showError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  errorText!,
                  style: TextStyle(
                    color: DropdownStyleConfig.instance.error.textColor,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );

    final content = <Widget>[
      label,
      SizedBox(height: DropdownStyleConfig.instance.defaultStyle.gap ?? 8),
      dropdownField,
    ];

    return Padding(
      padding: const EdgeInsets.all(0),
      child: widget.labelPosition == LabelPosition.vertical
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: content)
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                label,
                SizedBox(width: DropdownStyleConfig.instance.defaultStyle.gap ?? 8),
                Expanded(child: dropdownField),
              ],
            ),
    );
  }

  Color _getBackgroundColor(bool showError) {
    if (!widget.enabled) return DropdownStyleConfig.instance.disabled.backgroundColor;
    if (_isOpen) return DropdownStyleConfig.instance.focused.backgroundColor;
    if (_selectedItem != null && widget.showFilledStyle) {
      return DropdownStyleConfig.instance.filled.backgroundColor;
    }
    return DropdownStyleConfig.instance.defaultStyle.backgroundColor;
  }

  Color _getBorderColor(bool showError) {
    if (showError) return DropdownStyleConfig.instance.error.borderColor;
    if (!widget.enabled) return DropdownStyleConfig.instance.disabled.borderColor;
    if (_isOpen) return DropdownStyleConfig.instance.focused.borderColor;
    return DropdownStyleConfig.instance.defaultStyle.borderColor;
  }

  Color _getTextColor(bool showError) {
    if (showError) return DropdownStyleConfig.instance.error.textColor;
    if (!widget.enabled) return DropdownStyleConfig.instance.disabled.textColor;
    if (_isOpen) return DropdownStyleConfig.instance.focused.textColor;
    if (_selectedItem != null && widget.showFilledStyle) {
      return DropdownStyleConfig.instance.filled.textColor;
    }
    return DropdownStyleConfig.instance.defaultStyle.textColor;
  }

  Color _getLabelColor() {
    if (widget.errorText != null) return DropdownStyleConfig.instance.error.labelColor;
    if (!widget.enabled) return DropdownStyleConfig.instance.disabled.labelColor;
    return DropdownStyleConfig.instance.defaultStyle.labelColor;
  }
}