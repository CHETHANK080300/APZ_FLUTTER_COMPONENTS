import 'package:flutter/material.dart';
import '../lib/widgets/selection/selectors/checkbox/dynamic_checkbox.dart';

class DynamicCheckboxExample extends StatefulWidget {
  @override
  _DynamicCheckboxExampleState createState() => _DynamicCheckboxExampleState();
}

class _DynamicCheckboxExampleState extends State<DynamicCheckboxExample> {
  bool _isChecked1 = false;
  bool _isChecked2 = true;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;
  bool _isChecked6 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Checkbox Examples'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic checkbox with title
            _buildSectionTitle('Basic Checkbox with Title'),
            DynamicCheckbox(
              isChecked: _isChecked1,
              title: 'Accept terms and conditions',
              onChanged: (value) {
                setState(() {
                  _isChecked1 = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Checkbox with title and subtitle
            _buildSectionTitle('Checkbox with Title and Subtitle'),
            DynamicCheckbox(
              isChecked: _isChecked2,
              title: 'Receive marketing emails',
              subtitle: 'Get updates about new features and promotions',
              onChanged: (value) {
                setState(() {
                  _isChecked2 = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Different sizes
            _buildSectionTitle('Different Sizes'),
            Row(
              children: [
                Expanded(
                  child: DynamicCheckbox(
                    isChecked: _isChecked3,
                    title: 'Small',
                    size: 'small',
                    onChanged: (value) {
                      setState(() {
                        _isChecked3 = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DynamicCheckbox(
                    isChecked: _isChecked4,
                    title: 'Medium',
                    size: 'medium',
                    onChanged: (value) {
                      setState(() {
                        _isChecked4 = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DynamicCheckbox(
                    isChecked: _isChecked5,
                    title: 'Large',
                    size: 'large',
                    onChanged: (value) {
                      setState(() {
                        _isChecked5 = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Disabled state
            _buildSectionTitle('Disabled State'),
            DynamicCheckbox(
              isChecked: true,
              title: 'This option is disabled',
              subtitle: 'You cannot change this setting',
              isDisabled: true,
            ),
            const SizedBox(height: 20),

            // Error state
            _buildSectionTitle('Error State'),
            DynamicCheckbox(
              isChecked: _isChecked6,
              title: 'Required field',
              subtitle: 'This field is required',
              showError: true,
              onChanged: (value) {
                setState(() {
                  _isChecked6 = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Custom configuration example
            _buildSectionTitle('Custom Configuration'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Using custom JSON configuration:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You can create custom JSON files with different color schemes, sizes, and styling options.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Usage instructions
            _buildSectionTitle('Usage Instructions'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DynamicCheckbox Parameters:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  _buildParameterItem('isChecked', 'bool', 'Current checked state'),
                  _buildParameterItem('isDefault', 'bool', 'Default state (for styling)'),
                  _buildParameterItem('title', 'String?', 'Main label text'),
                  _buildParameterItem('subtitle', 'String?', 'Secondary description text'),
                  _buildParameterItem('configPath', 'String?', 'Path to custom JSON config'),
                  _buildParameterItem('onChanged', 'Function(bool)?', 'Callback when state changes'),
                  _buildParameterItem('isDisabled', 'bool', 'Disable interaction'),
                  _buildParameterItem('size', 'String', 'small/medium/large'),
                  _buildParameterItem('showError', 'bool', 'Show error styling'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParameterItem(String name, String type, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          children: [
            TextSpan(
              text: '$name: ',
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            ),
            TextSpan(
              text: type,
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const TextSpan(text: ' - '),
            TextSpan(text: description),
          ],
        ),
      ),
    );
  }
} 