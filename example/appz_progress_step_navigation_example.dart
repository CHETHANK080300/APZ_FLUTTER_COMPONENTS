import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_progress_step/appz_progress_step.dart';
import 'package:apz_flutter_components/components/appz_progress_step/appz_progress_step_style_config.dart';
import 'package:apz_flutter_components/components/appz_text/appz_text.dart';

class AppzProgressStepNavigationExample extends StatefulWidget {
  const AppzProgressStepNavigationExample({Key? key}) : super(key: key);

  @override
  State<AppzProgressStepNavigationExample> createState() =>
      _AppzProgressStepNavigationExampleState();
}

class _AppzProgressStepNavigationExampleState
    extends State<AppzProgressStepNavigationExample> {
  final GlobalKey<AppzProgressStepsState> _stepperKey =
      GlobalKey<AppzProgressStepsState>();
  late Future<void> _loadTokensFuture;

  // Custom step labels - only 3 pages
  final List<String> _stepLabels = [
    'Personal Info',
    'Contact Details',
    'Confirmation'
  ];

  @override
  void initState() {
    super.initState();
    _loadTokensFuture = AppzProgressStepStyleConfig.instance.load();
  }

  // Simple navigation to step page
  void _navigateToStep(int stepIndex) {
    final currentStep = _stepperKey.currentState?.currentStepIndex ?? 0;

    // Allow navigation to current step or completed steps
    if (stepIndex <= currentStep ||
        _stepperKey.currentState?.isStepCompleted(stepIndex) == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimpleStepPage(
            stepIndex: stepIndex,
            stepTitle: _stepLabels[stepIndex],
            onComplete: () {
              _stepperKey.currentState?.markStepAsCompleted(stepIndex);
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppzText(
            'Complete step ${currentStep + 1} first',
            category: 'paragraph',
            fontWeight: 'medium',
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Complete current step and go to next
  void _completeAndNext() {
    final currentStep = _stepperKey.currentState?.currentStepIndex ?? 0;
    _stepperKey.currentState?.markStepAsCompleted(currentStep);

    if (currentStep < _stepLabels.length - 1) {
      _stepperKey.currentState?.nextStep();
      _navigateToStep(currentStep + 1);
    } else {
      _navigateToStep(currentStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppzText(
          'Progress Step Navigation',
          category: 'heading',
          fontWeight: 'bold',
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _loadTokensFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Progress Steps
                AppzProgressSteps(
                  key: _stepperKey,
                  stepLabels: _stepLabels,
                ),
                const SizedBox(height: 32),

                // Simple status
                AppzText(
                  'Current Step: ${_stepperKey.currentState?.currentStepIndex ?? 0}',
                  category: 'heading',
                  fontWeight: 'semibold',
                ),
                const SizedBox(height: 16),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _stepperKey.currentState?.previousStep(),
                      child: AppzText(
                        'Previous',
                        category: 'paragraph',
                        fontWeight: 'medium',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _completeAndNext(),
                      child: AppzText(
                        'Complete & Next',
                        category: 'paragraph',
                        fontWeight: 'medium',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _stepperKey.currentState?.nextStep(),
                      child: AppzText(
                        'Next',
                        category: 'paragraph',
                        fontWeight: 'medium',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Reset button
                ElevatedButton(
                  onPressed: () => _stepperKey.currentState?.resetSteps(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: AppzText(
                    'Reset',
                    category: 'paragraph',
                    fontWeight: 'medium',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Simple step page
class SimpleStepPage extends StatelessWidget {
  final int stepIndex;
  final String stepTitle;
  final VoidCallback onComplete;

  const SimpleStepPage({
    Key? key,
    required this.stepIndex,
    required this.stepTitle,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppzText(
          stepTitle,
          category: 'heading',
          fontWeight: 'bold',
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Step info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: AppzText(
                        '${stepIndex + 1}',
                        category: 'paragraph',
                        fontWeight: 'bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AppzText(
                    stepTitle,
                    category: 'heading',
                    fontWeight: 'semibold',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Simple content
            Expanded(
              child: Center(
                child: AppzText(
                  'This is step ${stepIndex + 1} content',
                  category: 'heading',
                  fontWeight: 'medium',
                ),
              ),
            ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: AppzText(
                      'Back',
                      category: 'paragraph',
                      fontWeight: 'medium',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: AppzText(
                      'Complete',
                      category: 'paragraph',
                      fontWeight: 'medium',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
