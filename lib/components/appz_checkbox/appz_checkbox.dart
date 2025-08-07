import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'appz_checkbox_style_config.dart';
import '../appz_image/appz_assets.dart';
import '../appz_text/appz_text.dart';
import '../appz_text/appz_text_style_config.dart';

enum CheckboxAlignment { left, right }

enum CheckboxVariant { single, group }

class CheckboxItem {
  final String label;
  final String value; // "yes" or "no"

  const CheckboxItem({
    required this.label,
    required this.value,
  });
}

/// Controller for managing AppzCheckbox state and behavior
class AppzCheckboxController extends ChangeNotifier {
  String _value = "no";
  List<int> _selectedIndices = [];
  bool _enabled = true;

  /// Current value for single checkbox ("yes" or "no")
  String get value => _value;

  /// Selected indices for group checkbox
  List<int> get selectedIndices => List.unmodifiable(_selectedIndices);

  /// Whether the checkbox is enabled
  bool get enabled => _enabled;

  /// Set the value for single checkbox
  void setValue(String value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  /// Toggle the value for single checkbox
  void toggle() {
    setValue(_value == "yes" ? "no" : "yes");
  }

  /// Set selected indices for group checkbox
  void setSelectedIndices(List<int> indices) {
    if (!listEquals(_selectedIndices, indices)) {
      _selectedIndices = List.from(indices);
      notifyListeners();
    }
  }

  /// Toggle selection for a specific index in group checkbox
  void toggleIndex(int index) {
    final newIndices = List<int>.from(_selectedIndices);
    if (newIndices.contains(index)) {
      newIndices.remove(index);
    } else {
      newIndices.add(index);
    }
    setSelectedIndices(newIndices);
  }

  /// Set enabled state
  void setEnabled(bool enabled) {
    if (_enabled != enabled) {
      _enabled = enabled;
      notifyListeners();
    }
  }

  /// Reset controller to initial state
  void reset() {
    _value = "no";
    _selectedIndices = [];
    _enabled = true;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AppzCheckbox extends StatefulWidget {
  final String? value; // Initial value for single checkboxes ("yes" or "no")
  final ValueNotifier<String>? valueNotifier; // "yes" or "no"
  final String? label;
  final String? subtitle;
  final CheckboxAlignment alignment;
  final CheckboxVariant variant;
  final bool enabled;
  final List<CheckboxItem>? groupItems;
  final ValueNotifier<List<int>>?
      selectedIndicesNotifier; // For multi selection
  final AppzCheckboxController? controller; // Controller for managing state
  final VoidCallback? onTap; // Callback when checkbox is tapped

  const AppzCheckbox({
    super.key,
    this.value,
    this.valueNotifier,
    this.label,
    this.subtitle,
    this.alignment = CheckboxAlignment.left,
    this.variant = CheckboxVariant.single,
    this.enabled = true,
    this.groupItems,
    this.selectedIndicesNotifier,
    this.controller,
    this.onTap,
  }) : assert(
            (variant == CheckboxVariant.group &&
                    (selectedIndicesNotifier != null || controller != null)) ||
                (variant == CheckboxVariant.single &&
                    (valueNotifier != null ||
                        value != null ||
                        controller != null)),
            'For single variant: either valueNotifier, value, or controller must be provided. For group variant: either selectedIndicesNotifier or controller must be provided.');

  @override
  State<AppzCheckbox> createState() => _AppzCheckboxState();
}

class _AppzCheckboxState extends State<AppzCheckbox> {
  bool _isLoaded = false;
  ValueNotifier<String>?
      _localValueNotifier; // For single checkboxes when only 'value' is provided

  @override
  void initState() {
    super.initState();
    _loadConfigs();

    // Initialize selectedIndicesNotifier for group checkboxes
    if (widget.variant == CheckboxVariant.group && widget.groupItems != null) {
      if (widget.selectedIndicesNotifier != null) {
        final initialSelectedIndices = <int>[];
        for (int i = 0; i < widget.groupItems!.length; i++) {
          if (widget.groupItems![i].value == "yes") {
            initialSelectedIndices.add(i);
          }
        }
        widget.selectedIndicesNotifier!.value = initialSelectedIndices;
      } else if (widget.controller != null) {
        // Initialize controller with selected indices based on groupItems
        final initialSelectedIndices = <int>[];
        for (int i = 0; i < widget.groupItems!.length; i++) {
          if (widget.groupItems![i].value == "yes") {
            initialSelectedIndices.add(i);
          }
        }
        widget.controller!.setSelectedIndices(initialSelectedIndices);
      }
    }

    // Initialize local ValueNotifier for single checkboxes when only 'value' is provided
    if (widget.variant == CheckboxVariant.single &&
        widget.valueNotifier == null &&
        widget.value != null &&
        widget.controller == null) {
      _localValueNotifier = ValueNotifier<String>(widget.value!);
    }

    // Initialize controller if provided
    if (widget.controller != null) {
      widget.controller!.addListener(_onControllerChanged);
    }
  }

  Future<void> _loadConfigs() async {
    await Future.wait([
      AppzCheckboxStyleConfig.instance.load(),
      AppzTextStyleConfig.instance.load(),
    ]);
    if (mounted) {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _localValueNotifier?.dispose();
    if (widget.controller != null) {
      widget.controller!.removeListener(_onControllerChanged);
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const SizedBox.shrink();
    }
    // For single checkboxes, hide if label is missing
    if (widget.variant == CheckboxVariant.single &&
        (widget.label == null || widget.label!.trim().isEmpty)) {
      return const SizedBox.shrink();
    }

    if (widget.variant == CheckboxVariant.group) {
      return _buildCheckboxGroup();
    }

    // For single checkboxes, use controller if provided, otherwise use valueNotifier or local one
    // Note: If only 'value' is provided, the checkbox will be interactive and state will persist
    final valueNotifier = widget.controller != null
        ? ValueNotifier<String>(widget.controller!.value)
        : widget.valueNotifier ??
            _localValueNotifier ??
            ValueNotifier<String>("no");

    return ValueListenableBuilder<String>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        final config = AppzCheckboxStyleConfig.instance;

        final double boxWidth = config.getWidth();
        final double boxHeight = config.getHeight();
        final double borderRadius = config.getBorderRadius();
        final double borderWidth = config.getBorderWidth();
        final double iconSize = config.getIconSize();

        final Color activeBackgroundColor = config.getActiveBackgroundColor();
        final Color inactiveBorderColor = config.getInactiveBorderColor();
        final Color checkmarkColor = config.getCheckmarkColor();

        final double containerHeight = config.getContainerHeight();
        final double containerWidth = config.getContainerWidth();

        final double offsetX = (containerWidth - boxWidth) / 2;
        final double offsetY = (containerHeight - boxHeight) / 2;

        // Use controller's enabled state if available, otherwise use widget's enabled
        final bool isEnabled = widget.controller?.enabled ?? widget.enabled;

        Widget checkboxWidget = GestureDetector(
          onTap: isEnabled
              ? () {
                  // Call onTap callback if provided
                  widget.onTap?.call();

                  // Update value based on controller or valueNotifier
                  if (widget.controller != null) {
                    widget.controller!.toggle();
                  } else {
                    valueNotifier.value = value == "yes" ? "no" : "yes";
                  }
                }
              : null,
          child: SizedBox(
            width: containerWidth,
            height: containerHeight,
            child: Stack(
              children: [
                Positioned(
                  left: offsetX,
                  top: offsetY,
                  child: Container(
                    width: boxWidth,
                    height: boxHeight,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: value == "yes" && isEnabled
                          ? activeBackgroundColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: value == "yes"
                          ? null
                          : Border.all(
                              width: borderWidth,
                              color: isEnabled
                                  ? inactiveBorderColor
                                  : inactiveBorderColor.withValues(alpha: 0.5),
                            ),
                    ),
                    child: value == "yes" && isEnabled
                        ? Center(
                            child: SvgPicture.asset(
                              AppzIcons.check,
                              width: iconSize,
                              height: iconSize,
                              colorFilter: ColorFilter.mode(
                                checkmarkColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );

        Widget? textContent;
        if (widget.label != null &&
            widget.label!.trim().isNotEmpty &&
            widget.subtitle != null &&
            widget.subtitle!.trim().isNotEmpty) {
          // Both label and subtitle present: render as usual
          textContent = Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppzText(
                  widget.label!,
                  category: 'input',
                  fontWeight: 'regular',
                  color: isEnabled
                      ? config.getLabelColor()
                      : config.getDisabledLabelColor(),
                ),
                SizedBox(height: config.getSubtitleSpacing()),
                AppzText(
                  widget.subtitle!,
                  category: 'label',
                  fontWeight: 'regular',
                  color: isEnabled
                      ? config.getSubtitleColor()
                      : config.getDisabledSubtitleColor(),
                ),
              ],
            ),
          );
        } else if (widget.label != null &&
            widget.label!.trim().isNotEmpty &&
            (widget.subtitle == null || widget.subtitle!.trim().isEmpty)) {
          // Only label present: render with subtitle styling
          textContent = Expanded(
            child: AppzText(
              widget.label!,
              category: 'label',
              fontWeight: 'regular',
              color: isEnabled
                  ? config.getSubtitleColor()
                  : config.getDisabledSubtitleColor(),
            ),
          );
        } else {
          // Only subtitle or nothing: render nothing
          textContent = null;
        }

        if (widget.alignment == CheckboxAlignment.left) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              checkboxWidget,
              if (textContent != null) ...[
                SizedBox(width: config.getSpacing()),
                textContent,
              ],
            ],
          );
        } else {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (textContent != null) ...[
                textContent,
                SizedBox(width: config.getSpacing()),
              ],
              checkboxWidget,
            ],
          );
        }
      },
    );
  }

  Widget _buildCheckboxGroup() {
    final config = AppzCheckboxStyleConfig.instance;
    // Use controller's enabled state if available, otherwise use widget's enabled
    final bool isEnabled = widget.controller?.enabled ?? widget.enabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.trim().isNotEmpty)
          AppzText(
            widget.label!,
            category: 'label',
            fontWeight: 'regular',
            color: isEnabled
                ? config.getSubtitleColor()
                : config.getDisabledSubtitleColor(),
          ),
        if (widget.label != null && widget.label!.trim().isNotEmpty)
          const SizedBox(height: 12),
        _buildGroupCheckboxes(),
      ],
    );
  }

  Widget _buildGroupCheckboxes() {
    final config = AppzCheckboxStyleConfig.instance;
    if (widget.selectedIndicesNotifier != null || widget.controller != null) {
      final selectedIndicesNotifier = widget.controller != null
          ? ValueNotifier<List<int>>(widget.controller!.selectedIndices)
          : widget.selectedIndicesNotifier!;

      return ValueListenableBuilder<List<int>>(
        valueListenable: selectedIndicesNotifier,
        builder: (context, selectedIndices, child) {
          final items = widget.groupItems ?? [];

          return Wrap(
            spacing:
                config.getGroupSpacing(), // Horizontal spacing between items
            runSpacing:
                config.getGroupRunSpacing(), // Vertical spacing between rows
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              // Always use selectedIndices as the source of truth
              final isSelected = selectedIndices.contains(index);
              return _buildSingleCheckbox(
                  item.label, isSelected, widget.enabled, index);
            }).toList(),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSingleCheckbox(
      String label, bool value, bool enabled, int index) {
    final config = AppzCheckboxStyleConfig.instance;
    // Use controller's enabled state if available, otherwise use the passed enabled parameter
    final bool isEnabled = widget.controller?.enabled ?? enabled;
    final double boxWidth = config.getWidth();
    final double boxHeight = config.getHeight();
    final double borderRadius = config.getBorderRadius();
    final double borderWidth = config.getBorderWidth();
    final double iconSize = config.getIconSize();
    final Color activeBackgroundColor = config.getActiveBackgroundColor();
    final Color inactiveBorderColor = config.getInactiveBorderColor();
    final Color checkmarkColor = config.getCheckmarkColor();
    final double containerHeight = config.getContainerHeight();
    final double containerWidth = config.getContainerWidth();
    final double offsetX = (containerWidth - boxWidth) / 2;
    final double offsetY = (containerHeight - boxHeight) / 2;

    Widget checkboxWidget = GestureDetector(
      onTap: isEnabled
          ? () {
              // Call onTap callback if provided
              widget.onTap?.call();

              // For group checkboxes, we need to handle individual item clicks
              if (widget.variant == CheckboxVariant.group) {
                if (widget.controller != null) {
                  // Use controller for group checkboxes
                  widget.controller!.toggleIndex(index);
                } else if (widget.selectedIndicesNotifier != null) {
                  // Multi-selection mode
                  final currentSelectedIndices =
                      List<int>.from(widget.selectedIndicesNotifier!.value);

                  // Toggle the clicked item
                  if (currentSelectedIndices.contains(index)) {
                    // Remove from selection
                    currentSelectedIndices.remove(index);
                  } else {
                    // Add to selection
                    currentSelectedIndices.add(index);
                  }

                  widget.selectedIndicesNotifier!.value =
                      currentSelectedIndices;
                }
              } else {
                // Single checkbox - handled by ValueNotifier in build method
              }
            }
          : null,
      child: SizedBox(
        width: containerWidth,
        height: containerHeight,
        child: Stack(
          children: [
            Positioned(
              left: offsetX,
              top: offsetY,
              child: Container(
                width: boxWidth,
                height: boxHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: value && isEnabled
                      ? activeBackgroundColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: value
                      ? null
                      : Border.all(
                          width: borderWidth,
                          color: isEnabled
                              ? inactiveBorderColor
                              : inactiveBorderColor.withValues(alpha: 0.5),
                        ),
                ),
                child: value && isEnabled
                    ? Center(
                        child: SvgPicture.asset(
                          AppzIcons.check,
                          width: iconSize,
                          height: iconSize,
                          colorFilter: ColorFilter.mode(
                            checkmarkColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        checkboxWidget,
        SizedBox(width: config.getSpacing()),
        Flexible(
          child: AppzText(
            label,
            category: 'input',
            fontWeight: 'regular',
            color: isEnabled
                ? config.getLabelColor()
                : config.getDisabledLabelColor(),
          ),
        ),
      ],
    );
  }
}
