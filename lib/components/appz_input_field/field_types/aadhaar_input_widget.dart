import 'package:apz_flutter_components/components/appz_input_field/appz_input_field_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../appz_input_field_enums.dart';
import '../appz_input_style_config.dart';

class AadhaarInputWidget extends StatefulWidget {
  final AppzStateStyle currentStyle;
  final TextEditingController mainController;
  final FocusNode? mainFocusNode;
  final bool isEnabled;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final AppzInputValidationType validationType;
  final FormFieldValidator<String>? validator;

  const AadhaarInputWidget({
    super.key,
    required this.currentStyle,
    required this.mainController,
    this.mainFocusNode,
    required this.isEnabled,
    this.hintText,
    this.onChanged,
    required this.validationType,
    this.validator,
  });

  @override
  State<AadhaarInputWidget> createState() => _AadhaarInputWidgetState();
}

class _AadhaarInputWidgetState extends State<AadhaarInputWidget> {
  static const int _numSegments = 3;
  static const int _segmentLength = 4;

  late List<TextEditingController> _segmentControllers;
  late List<FocusNode> _segmentFocusNodes;
  String? _errorMessage;
  bool _showError = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _initializeSegments();
    _populateSegmentsFromMainController();

    widget.mainController.addListener(_populateSegmentsFromMainController);
    widget.mainFocusNode?.addListener(_handleMainFocus);
  }

  void _initializeSegments() {
    _segmentControllers = List.generate(_numSegments, (_) => TextEditingController());
    _segmentFocusNodes = List.generate(_numSegments, (_) => FocusNode());

    for (int i = 0; i < _numSegments; i++) {
      _segmentControllers[i].addListener(() => _onSegmentChanged(i));
      _segmentFocusNodes[i].addListener(() {
        if (!_segmentFocusNodes[i].hasFocus) {
          _validate(_segmentControllers.map((c) => c.text).join(), onBlur: true);
        }
        if (_segmentFocusNodes[i].hasFocus) {
          _segmentControllers[i].selection = TextSelection(baseOffset: 0, extentOffset: _segmentControllers[i].text.length);
        }
      });
    }
  }

  void _handleMainFocus() {
    if (widget.mainFocusNode != null && widget.mainFocusNode!.hasFocus && widget.isEnabled) {
      for (int i = 0; i < _numSegments; i++) {
        if (_segmentControllers[i].text.length < _segmentLength) {
          FocusScope.of(context).requestFocus(_segmentFocusNodes[i]);
          return;
        }
      }
      FocusScope.of(context).requestFocus(_segmentFocusNodes[0]);
    }
  }

  void _populateSegmentsFromMainController() {
    final fullText = widget.mainController.text.replaceAll(' ', '');
    if (fullText.length > 12) return;

    for (int i = 0; i < _numSegments; i++) {
      final start = i * _segmentLength;
      final end = start + _segmentLength;
      String segmentValue = fullText.length > start ? fullText.substring(start, fullText.length < end ? fullText.length : end) : '';

      if (_segmentControllers[i].text != segmentValue) {
        _segmentControllers[i].value = TextEditingValue(
          text: segmentValue,
          selection: TextSelection.collapsed(offset: segmentValue.length),
        );
      }
    }
  }

  void _onSegmentChanged(int segmentIndex) {
    String combinedValue = _segmentControllers.map((c) => c.text).join();
    if (widget.mainController.text != combinedValue) {
      widget.mainController.text = combinedValue;
    }

    if (!widget.isEnabled) return;

    final currentValue = _segmentControllers[segmentIndex].text;
    if (currentValue.length == _segmentLength) {
      if (segmentIndex < _numSegments - 1) {
        FocusScope.of(context).requestFocus(_segmentFocusNodes[segmentIndex + 1]);
      } else {
        _segmentFocusNodes[segmentIndex].unfocus();
      }
    }

    // clear error if valid
    if (combinedValue.length == 12 && RegExp(r'^\d{12}\$').hasMatch(combinedValue)) {
      setState(() {
        _showError = false;
        _errorMessage = null;
      });
    }
  }

  void _validate(String value, {bool onBlur = false, bool onSubmit = false}) {
    String? error;
    final isEmpty = value.isEmpty;

    if (onSubmit && widget.validationType == AppzInputValidationType.mandatory && isEmpty) {
      error = 'This field is required.';
    } else if (!isEmpty && !RegExp(r'^\d{12}\$').hasMatch(value)) {
      error = 'Aadhaar must be 12 digits.';
    } else if (!isEmpty && widget.validator != null) {
      error = widget.validator!(value);
    }

    setState(() {
      _submitted = _submitted || onSubmit;
      _showError = error != null && (onBlur || onSubmit);
      _errorMessage = error;
    });
  }

  void _handleBackspace(int segmentIndex) {
    if (!widget.isEnabled) return;
    if (segmentIndex > 0 && _segmentControllers[segmentIndex].text.isEmpty) {
      FocusScope.of(context).requestFocus(_segmentFocusNodes[segmentIndex - 1]);
    }
  }

  @override
  void dispose() {
    widget.mainController.removeListener(_populateSegmentsFromMainController);
    widget.mainFocusNode?.removeListener(_handleMainFocus);
    for (var controller in _segmentControllers) {
      controller.dispose();
    }
    for (var focusNode in _segmentFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> segmentWidgets = [];
    for (int i = 0; i < _numSegments; i++) {
      segmentWidgets.add(
        Expanded(
          child: TextField(
            controller: _segmentControllers[i],
            focusNode: _segmentFocusNodes[i],
            enabled: widget.isEnabled,
            textAlign: TextAlign.center,
            maxLength: _segmentLength,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              color: widget.isEnabled ? widget.currentStyle.textColor : widget.currentStyle.textColor.withOpacity(0.5),
              fontFamily: widget.currentStyle.fontFamily,
              fontSize: widget.currentStyle.fontSize,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.symmetric(vertical: widget.currentStyle.paddingVertical / 1.5),
              filled: true,
              fillColor: widget.currentStyle.backgroundColor,
              border: _getSegmentInputBorder(i),
              enabledBorder: _getSegmentInputBorder(i),
              focusedBorder: _getSegmentInputBorder(i, isFocused: true),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                _handleBackspace(i);
              }
            },
          ),
        ),
      );
      if (i < _numSegments - 1) {
        segmentWidgets.add(const SizedBox(width: 8));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          focusNode: widget.mainFocusNode,
          skipTraversal: true,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.currentStyle.paddingHorizontal / 2,
              vertical: widget.currentStyle.paddingVertical / 2,
            ),
            child: Row(children: segmentWidgets),
          ),
        ),
        if (_showError && _errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: AppzStyleConfig.instance.getStyleForState(AppzFieldState.error).textColor,
                fontSize: widget.currentStyle.labelFontSize * 0.9,
                fontFamily: widget.currentStyle.fontFamily,
              ),
            ),
          ),
      ],
    );
  }

  InputBorder _getSegmentInputBorder(int segmentIndex, {bool isFocused = false}) {
    AppzFieldState fieldState = !widget.isEnabled
        ? AppzFieldState.disabled
        : _showError
            ? AppzFieldState.error
            : isFocused
                ? AppzFieldState.focused
                : AppzFieldState.defaultState;

    final styleToUse = AppzStyleConfig.instance.getStyleForState(fieldState);

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.currentStyle.borderRadius / 1.5),
      borderSide: BorderSide(
        color: styleToUse.borderColor,
        width: styleToUse.borderWidth,
      ),
    );
  }

  void triggerSubmitValidation() {
    _validate(widget.mainController.text, onSubmit: true);
  }
}
