import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_progress_step/appz_progress_step.dart';
import 'package:apz_flutter_components/components/appz_progress_step/appz_progress_step_style_config.dart';

class AppzProgressStepExample extends StatefulWidget {
  const AppzProgressStepExample({Key? key}) : super(key: key);

  @override
  State<AppzProgressStepExample> createState() =>
      _AppzProgressStepExampleState();
}

class _AppzProgressStepExampleState extends State<AppzProgressStepExample> {
  final GlobalKey<AppzProgressStepsState> _stepperKey =
      GlobalKey<AppzProgressStepsState>();
  late Future<void> _loadTokensFuture;
  bool _useCustomLabels = false;

  // Custom step labels example
  final List<String> _customStepLabels = [
    'Personal Info',
    'Contact Details',
    'Address',
    'Preferences',
    'Confirmation'
  ];

  @override
  void initState() {
    super.initState();
    _loadTokensFuture = AppzProgressStepStyleConfig.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Step Example')),
      body: FutureBuilder<void>(
        future: _loadTokensFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // Get step labels - either custom or from config
          final stepLabels = _useCustomLabels
              ? _customStepLabels
              : AppzProgressStepStyleConfig.instance.stepsFromSupportingTokens;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle for step labels
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Step Labels: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => _useCustomLabels = false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              !_useCustomLabels ? Colors.blue : Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Default'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => _useCustomLabels = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _useCustomLabels ? Colors.blue : Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Custom'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Progress Steps Widget
                AppzProgressSteps(
                  key: _stepperKey,
                  stepLabels: stepLabels,
                ),
                const SizedBox(height: 32),

                // Navigation Buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _stepperKey.currentState?.previousStep(),
                      child: const Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () => _stepperKey.currentState?.completeStep(),
                      child: const Text('Completed'),
                    ),
                    ElevatedButton(
                      onPressed: () => _stepperKey.currentState?.nextStep(),
                      child: const Text('Next'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Additional Control Buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _stepperKey.currentState?.resetSteps(),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 32), // Extra padding at bottom for scroll safety
              ],
            ),
          );
        },
      ),
    );
  }
}
