import 'package:flutter/material.dart';
import '../lib/components/appz_footer/appz_footer.dart';

class AppzFooterExample extends StatelessWidget {
  const AppzFooterExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppzFooter Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Split Buttons Section
            const Text(
              'Split Buttons Footer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Split Buttons with both buttons
            const Text('Split Buttons (Both)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzFooter(
              variant: AppzFooterVariant.splitButtons,
              primaryButtonText: 'Save',
              secondaryButtonText: 'Cancel',
              onPrimaryButtonTap: () {
                // Handle save action
              },
              onSecondaryButtonTap: () {
                // Handle cancel action
              },
            ),
            const SizedBox(height: 24),
            
            // Split Buttons with only primary
            const Text('Split Buttons (Primary Only)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzFooter(
              variant: AppzFooterVariant.splitButtons,
              primaryButtonText: 'Continue',
              onPrimaryButtonTap: () {
                // Handle continue action
              },
            ),
            const SizedBox(height: 24),
            
            // Split Buttons with only secondary
            const Text('Split Buttons (Secondary Only)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzFooter(
              variant: AppzFooterVariant.splitButtons,
              secondaryButtonText: 'Back',
              onSecondaryButtonTap: () {
                // Handle back action
              },
            ),
            const SizedBox(height: 32),

            // Full Size Buttons Section
            const Text(
              'Full Size Buttons Footer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Full Size Buttons with both buttons
            const Text('Full Size Buttons (Both)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzFooter(
              variant: AppzFooterVariant.fullSizeButtons,
              primaryButtonText: 'Submit',
              secondaryButtonText: 'Reset',
              onPrimaryButtonTap: () {
                // Handle submit action
              },
              onSecondaryButtonTap: () {
                // Handle reset action
              },
            ),
            const SizedBox(height: 24),
            
            // Full Size Buttons with only primary
            const Text('Full Size Buttons (Primary Only)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzFooter(
              variant: AppzFooterVariant.fullSizeButtons,
              primaryButtonText: 'Confirm',
              onPrimaryButtonTap: () {
                // Handle confirm action
              },
            ),
            const SizedBox(height: 24),
            
            // Full Size Buttons with only secondary
            const Text('Full Size Buttons (Secondary Only)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzFooter(
              variant: AppzFooterVariant.fullSizeButtons,
              secondaryButtonText: 'Close',
              onSecondaryButtonTap: () {
                // Handle close action
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
} 