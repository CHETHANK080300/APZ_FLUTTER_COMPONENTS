import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/apz_list_content/apz_list_content.dart';

class ApzListContentExample extends StatelessWidget {
  const ApzListContentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ApzListContent Example'),
        backgroundColor: Colors.grey[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ApzListContent Component Examples',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            
            // Side by Side Layout Examples
            const Text(
              'Side by Side Layout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApzListContent(
                    type: ListContentType.sideBySide,
                    label: 'Name',
                    value: 'John Doe',
                  ),
                  const SizedBox(height: 12),
                  ApzListContent(
                    type: ListContentType.sideBySide,
                    label: 'Email',
                    value: 'john.doe@example.com',
                  ),
                  const SizedBox(height: 12),
                  ApzListContent(
                    type: ListContentType.sideBySide,
                    label: 'Phone',
                    value: '+1 (555) 123-4567',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Two Line Layout Examples
            const Text(
              'Two Line Layout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApzListContent(
                    type: ListContentType.twoLine,
                    label: 'Full Name',
                    value: 'John Michael Doe',
                  ),
                  const SizedBox(height: 16),
                  ApzListContent(
                    type: ListContentType.twoLine,
                    label: 'Address',
                    value: '123 Main Street, Apt 4B, New York, NY 10001',
                  ),
                  const SizedBox(height: 16),
                  ApzListContent(
                    type: ListContentType.twoLine,
                    label: 'Job Title',
                    value: 'Senior Software Engineer',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Label Only Examples
            const Text(
              'Label Only Layout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApzListContent(
                    type: ListContentType.labelOnly,
                    label: 'Personal Information',
                  ),
                  const SizedBox(height: 8),
                  ApzListContent(
                    type: ListContentType.labelOnly,
                    label: 'Contact Details',
                  ),
                  const SizedBox(height: 8),
                  ApzListContent(
                    type: ListContentType.labelOnly,
                    label: 'Work Experience',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Value Only Examples
            const Text(
              'Value Only Layout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApzListContent(
                    type: ListContentType.valueOnly,
                    value: 'Important Notice: This is a critical message',
                  ),
                  const SizedBox(height: 12),
                  ApzListContent(
                    type: ListContentType.valueOnly,
                    value: 'Status: Active',
                  ),
                  const SizedBox(height: 12),
                  ApzListContent(
                    type: ListContentType.valueOnly,
                    value: 'Last Updated: 2024-01-15',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Mixed Layout Examples
            const Text(
              'Mixed Layout Examples',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  ApzListContent(
                    type: ListContentType.labelOnly,
                    label: 'User Profile',
                  ),
                  const SizedBox(height: 16),
                  
                  // Side by side for basic info
                  ApzListContent(
                    type: ListContentType.sideBySide,
                    label: 'Username',
                    value: 'johndoe123',
                  ),
                  const SizedBox(height: 8),
                  ApzListContent(
                    type: ListContentType.sideBySide,
                    label: 'Member Since',
                    value: 'January 2020',
                  ),
                  const SizedBox(height: 16),
                  
                  // Two line for detailed info
                  ApzListContent(
                    type: ListContentType.twoLine,
                    label: 'Bio',
                    value: 'Passionate software engineer with 5+ years of experience in mobile app development.',
                  ),
                  const SizedBox(height: 12),
                  ApzListContent(
                    type: ListContentType.twoLine,
                    label: 'Skills',
                    value: 'Flutter, Dart, React Native, TypeScript, Node.js',
                  ),
                  const SizedBox(height: 16),
                  
                  // Value only for status
                  ApzListContent(
                    type: ListContentType.valueOnly,
                    value: 'Profile Status: Verified ✓',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 