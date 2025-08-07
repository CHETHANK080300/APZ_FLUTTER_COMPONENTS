import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_modal_header/appz_modal_header.dart';

class AppzModalHeaderExample extends StatefulWidget {
  const AppzModalHeaderExample({super.key});

  @override
  State<AppzModalHeaderExample> createState() => _AppzModalHeaderExampleState();
}

class _AppzModalHeaderExampleState extends State<AppzModalHeaderExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modal Header Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modal Header Component Examples',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Basic Modal Header
            const Text(
              'Basic Modal Header',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            AppzModalHeader(
              title: 'Basic Modal Title',
              onClose: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Close button tapped!')),
                );
              },
            ),
            const SizedBox(height: 30),
            
            
            // Modal Header without Close Button
            const Text(
              'Modal Header without Close Button',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            AppzModalHeader(
              title: 'No Close Button',
            ),
            const SizedBox(height: 30),
            
            // Modal Header with Long Title
            const Text(
              'Modal Header with Long Title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            AppzModalHeader(
              title: 'This is a very long modal header title that should wrap properly',
              onClose: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Long title close button tapped!')),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
} 