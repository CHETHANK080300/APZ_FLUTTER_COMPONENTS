import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_progress_step/appz_progress_step_style_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apz_flutter_components/components/appz_text/appz_text.dart';

// Callback function types for state changes
typedef OnStepChanged = void Function(int currentStep);
typedef OnStepCompleted = void Function(int completedStep);
typedef OnStepVisited = void Function(int visitedStep);

class AppzProgressSteps extends StatefulWidget {
  final List<String> stepLabels;
  final OnStepChanged? onStepChanged;
  final OnStepCompleted? onStepCompleted;
  final OnStepVisited? onStepVisited;

  const AppzProgressSteps({
    Key? key,
    required this.stepLabels,
    this.onStepChanged,
    this.onStepCompleted,
    this.onStepVisited,
  }) : super(key: key);

  @override
  AppzProgressStepsState createState() => AppzProgressStepsState();
}

class AppzProgressStepsState extends State<AppzProgressSteps> {
  int currentStep = 0;
  final Set<int> completedSteps = {};
  final Set<int> visitedSteps = {};
  final Set<int> dashedSteps = {};

  int get stepCount => widget.stepLabels.length;

  // Getter methods to expose current state
  int get currentStepIndex => currentStep;
  Set<int> get completedStepsSet => Set.from(completedSteps);
  Set<int> get visitedStepsSet => Set.from(visitedSteps);
  Set<int> get dashedStepsSet => Set.from(dashedSteps);

  // Helper methods to check step states
  bool isStepCompleted(int stepIndex) => completedSteps.contains(stepIndex);
  bool isStepVisited(int stepIndex) => visitedSteps.contains(stepIndex);
  bool isStepDashed(int stepIndex) => dashedSteps.contains(stepIndex);
  bool isStepCurrent(int stepIndex) => stepIndex == currentStep;

  // Get overall progress percentage
  double get progressPercentage => (completedSteps.length / stepCount) * 100;

  // Check if all steps are completed
  bool get isAllStepsCompleted => completedSteps.length == stepCount;

  // Get next available step
  int? get nextAvailableStep {
    for (int i = 0; i < stepCount; i++) {
      if (!completedSteps.contains(i)) {
        return i;
      }
    }
    return null; // All steps completed
  }

  void completeStep() {
    setState(() {
      completedSteps.add(currentStep);
      final completedStep = currentStep;

      if (currentStep < stepCount - 1) {
        visitedSteps.add(currentStep + 1);
        currentStep++;
      }

      // Trigger internal event handlers
      _handleStepCompleted(completedStep);
      _handleStepChanged(currentStep);

      // Trigger external callbacks
      widget.onStepCompleted?.call(completedStep);
      widget.onStepChanged?.call(currentStep);
    });
  }

  void nextStep() {
    setState(() {
      if (currentStep < stepCount - 1) {
        dashedSteps.add(currentStep);
        visitedSteps.add(currentStep + 1);
        final visitedStep = currentStep + 1;
        currentStep++;

        // Trigger internal event handlers
        _handleStepVisited(visitedStep);
        _handleStepChanged(currentStep);

        // Trigger external callbacks
        widget.onStepVisited?.call(visitedStep);
        widget.onStepChanged?.call(currentStep);
      }
    });
  }

  void previousStep() {
    setState(() {
      if (currentStep > 0) {
        if (!completedSteps.contains(currentStep)) {
          dashedSteps.add(currentStep);
        }
        currentStep--;

        // Trigger internal event handler
        _handleStepChanged(currentStep);

        // Trigger external callback
        widget.onStepChanged?.call(currentStep);
      }
    });
  }

  // Method to reset all steps
  void resetSteps() {
    setState(() {
      currentStep = 0;
      completedSteps.clear();
      visitedSteps.clear();
      dashedSteps.clear();

      // Trigger internal event handler
      _handleStepChanged(currentStep);

      // Trigger external callback
      widget.onStepChanged?.call(currentStep);
    });
  }

  // Method to mark a specific step as completed
  void markStepAsCompleted(int stepIndex) {
    if (stepIndex >= 0 && stepIndex < stepCount) {
      setState(() {
        completedSteps.add(stepIndex);

        // Trigger internal event handler
        _handleStepCompleted(stepIndex);

        // Trigger external callback
        widget.onStepCompleted?.call(stepIndex);
      });
    }
  }

  // Internal event handlers for state management
  void _handleStepChanged(int newStep) {
    // Internal logic for step change
    // This can be extended with additional internal state management
  }

  void _handleStepCompleted(int completedStep) {
    // Internal logic for step completion
    // This can be extended with additional internal state management
  }

  void _handleStepVisited(int visitedStep) {
    // Internal logic for step visit
    // This can be extended with additional internal state management
  }

  String _getStepIcon(int index) {
    final config = AppzProgressStepStyleConfig.instance;
    if (index == currentStep) {
      return config.getIconCurrent();
    } else if (completedSteps.contains(index)) {
      return config.getIconCompleted();
    } else if (dashedSteps.contains(index)) {
      return config.getIconNextDashed();
    } else if (visitedSteps.contains(index)) {
      return config.getIconNext();
    } else {
      return config.getIconNext();
    }
  }

  Color _getLabelColor(int index) {
    final config = AppzProgressStepStyleConfig.instance;
    if (index == currentStep) {
      return config
          .getActiveLabelColor(); // Current step always uses active color (black)
    } else if (completedSteps.contains(index)) {
      return config
          .getCompletedLabelColor(); // Completed steps use completed color
    } else if (visitedSteps.contains(index) || dashedSteps.contains(index)) {
      return config
          .getInactiveLabelColor(); // Visited/dashed steps use inactive color
    } else {
      return config.getInactiveLabelColor(); // Future steps use inactive color
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppzProgressStepStyleConfig.instance;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < widget.stepLabels.length; i++) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: config.getCircleSize(),
                      height: config.getCircleSize(),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        _getStepIcon(i),
                        width: config.getCircleSize(),
                        height: config.getCircleSize(),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: config.getStepSpacing()),
                    AppzText(
                      widget.stepLabels[i],
                      category: 'paragraph',
                      fontWeight: 'semibold',
                      color: _getLabelColor(i),
                    ),
                  ],
                ),
                if (i < widget.stepLabels.length - 1) ...[
                  SizedBox(height: 4.0),
                  Container(
                    width: config.getCircleSize(),
                    height: config.getConnectorLineHeight(),
                    alignment: Alignment.center,
                    child: Container(
                      width: config.getConnectorLineWidth(),
                      height: config.getConnectorLineHeight(),
                      decoration: BoxDecoration(
                        color: (completedSteps.contains(i + 1) ||
                                visitedSteps.contains(i + 1) ||
                                dashedSteps.contains(i + 1))
                            ? config.getConnectorCompletedColor()
                            : config.getConnectorInactiveColor(),
                        borderRadius: BorderRadius.circular(
                            config.getConnectorLineWidth() / 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.0),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
