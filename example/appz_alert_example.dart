import 'package:flutter/material.dart';
import '../lib/components/appz_alert/appz_alert.dart';

class AppzAlertExample extends StatelessWidget {
  const AppzAlertExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppzAlert Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4 Types with 2 Buttons and Icon Section
            const Text(
              'Alert Types with 2 Buttons and Icon',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Success Alert with Both Buttons
            const Text('Success Alert with Both Buttons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.success,
              title: 'Account Created',
              description: 'Your account has been created successfully. You can now access all features.',
              headerIconPath: 'assets/icons/tick-circle.svg',
              primaryButtonText: 'Get Started',
              secondaryButtonText: 'Skip Tutorial',
              onPrimaryButtonTap: () {
                // Handle get started
              },
              onSecondaryButtonTap: () {
                // Handle skip tutorial
              },
            ),
            const SizedBox(height: 24),
            
            // Warning Alert with Both Buttons
            const Text('Warning Alert with Both Buttons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.warning,
              title: 'Unsaved Changes',
              description: 'You have unsaved changes. Do you want to continue?',
              headerIconPath: 'assets/icons/close-circle-1.svg',
              primaryButtonText: 'Save',
              secondaryButtonText: 'Discard',
              onPrimaryButtonTap: () {
                // Handle save
              },
              onSecondaryButtonTap: () {
                // Handle discard
              },
            ),
            const SizedBox(height: 24),
            
            // Error Alert with Both Buttons
            const Text('Error Alert with Both Buttons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.error,
              title: 'Upload Failed',
              description: 'Failed to upload your file. The file may be too large or corrupted.',
              primaryButtonText: 'Try Again',
              secondaryButtonText: 'Contact Support',
              onPrimaryButtonTap: () {
                // Handle try again
              },
              onSecondaryButtonTap: () {
                // Handle contact support
              },
            ),
            const SizedBox(height: 24),
            
            // Info Alert with Both Buttons
            const Text('Info Alert with Both Buttons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.info,
              title: 'System Maintenance',
              description: 'Scheduled maintenance will begin in 30 minutes. Some features may be temporarily unavailable.',
              primaryButtonText: 'Acknowledge',
              secondaryButtonText: 'Remind Later',
              onPrimaryButtonTap: () {
                // Handle acknowledge
              },
              onSecondaryButtonTap: () {
                // Handle remind later
              },
            ),
            const SizedBox(height: 32),

            // Header Icon Examples Section
            const Text(
              'Header Icon Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Default Header Icon
            const Text('Default Header Icon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.success,
              title: 'Default Header Icon',
              description: 'This alert uses the default header icon from configuration.',
              primaryButtonText: 'OK',
              onPrimaryButtonTap: () {
                // Handle OK
              },
            ),
            const SizedBox(height: 24),
            
            // Custom Header Icon
            const Text('Custom Header Icon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.warning,
              title: 'Custom Header Icon',
              description: 'This alert uses a custom header icon (close-circle-1.svg).',
              headerIconPath: 'assets/icons/close-circle-1.svg',
              primaryButtonText: 'OK',
              onPrimaryButtonTap: () {
                // Handle OK
              },
            ),
            const SizedBox(height: 24),
            
            // Custom Header Icon with Different Icon
            const Text('Custom Header Icon (Different)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.info,
              title: 'Custom Header Icon',
              description: 'This alert uses a different custom header icon (info-circle.svg).',
              headerIconPath: 'assets/icons/info-circle.svg',
              primaryButtonText: 'OK',
              onPrimaryButtonTap: () {
                // Handle OK
              },
            ),
            const SizedBox(height: 32),

            // Variants Section
            const Text(
              'Alert Variants',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Basic Alerts (with icon)
            const Text('Basic Alerts (with icon)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            
            // Basic Success Alert
            const Text('Basic Success Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.success,
              title: 'Success!',
              description: 'Your action was completed successfully.',
            ),
            const SizedBox(height: 16),
            
            // Basic Warning Alert
            const Text('Basic Warning Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.warning,
              title: 'Warning',
              description: 'Please review your input before proceeding.',
            ),
            const SizedBox(height: 16),
            
            // Basic Error Alert
            const Text('Basic Error Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.error,
              title: 'Error Occurred',
              description: 'Something went wrong. Please try again.',
            ),
            const SizedBox(height: 16),
            
            // Basic Info Alert
            const Text('Basic Info Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.info,
              title: 'Information',
              description: 'This is an informational message.',
            ),
            const SizedBox(height: 24),
            
            // Single Button Alerts
            const Text('Single Button Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            
            // Success Alert with Primary Button
            const Text('Success Alert with Primary Button', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.success,
              title: 'Payment Successful',
              description: 'Your payment has been processed successfully.',
              primaryButtonText: 'View Receipt',
              onPrimaryButtonTap: () {
                // Handle view receipt
              },
            ),
            const SizedBox(height: 16),
            
            // Warning Alert with Primary Button
            const Text('Warning Alert with Primary Button', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.warning,
              title: 'Low Battery',
              description: 'Your device battery is running low. Consider charging soon.',
              primaryButtonText: 'Dismiss',
              onPrimaryButtonTap: () {
                // Handle dismiss
              },
            ),
            const SizedBox(height: 16),
            
            // Error Alert with Primary Button
            const Text('Error Alert with Primary Button', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.error,
              title: 'Connection Failed',
              description: 'Unable to connect to the server. Please check your internet connection.',
              primaryButtonText: 'Retry',
              onPrimaryButtonTap: () {
                // Handle retry
              },
            ),
            const SizedBox(height: 16),
            
            // Info Alert with Primary Button
            const Text('Info Alert with Primary Button', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppzAlert(
              type: AppzAlertType.info,
              title: 'New Feature Available',
              description: 'We\'ve added new features to improve your experience.',
              primaryButtonText: 'Learn More',
              onPrimaryButtonTap: () {
                // Handle learn more
              },
            ),
            const SizedBox(height: 32), // Add bottom padding for scrolling
          ],
        ),
      ),
    );
  }
} 