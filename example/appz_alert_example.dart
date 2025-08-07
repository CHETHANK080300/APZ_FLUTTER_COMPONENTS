import 'package:flutter/material.dart';
import '../lib/components/appz_alert/appz_alert.dart';
import '../lib/components/apz_button/appz_button.dart';

class AppzAlertExample extends StatelessWidget {
  const AppzAlertExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppzAlert Examples'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppzButton(
                label: 'Show Success Alert',
                onPressed: () {
                  AppzAlert.show(
                    context,
                    title: 'Success',
                    message: 'Application submitted successfully',
                    messageType: AppzAlertMessageType.success,
                    buttons: ['Done'],
                    onButtonPressed: (button) {
                      print('$button pressed');
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              AppzButton(
                label: 'Show Error Alert with Close Icon',
                onPressed: () {
                  AppzAlert.show(
                    context,
                    title: 'Error',
                    message: 'Something went wrong',
                    messageType: AppzAlertMessageType.error,
                    buttons: ['Try Again', 'Cancel'],
                    showCloseIcon: true,
                    onButtonPressed: (button) {
                      print('$button pressed');
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              AppzButton(
                label: 'Show Info Alert',
                onPressed: () {
                  AppzAlert.show(
                    context,
                    title: 'Info',
                    message: 'This is an informational message',
                    messageType: AppzAlertMessageType.info,
                  );
                },
              ),
              const SizedBox(height: 16),
              AppzButton(
                label: 'Show Confirmation Alert (Top)',
                onPressed: () {
                  AppzAlert.show(
                    context,
                    title: 'Confirmation',
                    message: 'Are you sure you want to proceed?',
                    messageType: AppzAlertMessageType.warning,
                    buttons: ['Confirm', 'Cancel'],
                    alignment: Alignment.topCenter,
                    onButtonPressed: (button) {
                      print('$button pressed');
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              AppzButton(
                label: 'Show Success Alert (Bottom)',
                onPressed: () {
                  AppzAlert.show(
                    context,
                    title: 'Success',
                    message: 'Application submitted successfully',
                    messageType: AppzAlertMessageType.success,
                    buttons: ['Done'],
                    alignment: Alignment.bottomCenter,
                    onButtonPressed: (button) {
                      print('$button pressed');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 