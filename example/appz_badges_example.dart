import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_badges/appz_badges.dart';

class AppzBadgesExample extends StatelessWidget {
  const AppzBadgesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appz Badges Example'),
        backgroundColor: Colors.grey[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Badges Component Examples',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // X-Small Badges Row
            const Text(
              'X-Small Badges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.defaultState,
                  label: 'Default',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.success,
                  label: 'Success',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.error,
                  label: 'Error',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.warning,
                  label: 'Warning',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.info,
                  label: 'Info',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Small Badges Row
            const Text(
              'Small Badges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                AppzBadges(
                  size: AppzBadgeSize.small,
                  state: AppzBadgeState.defaultState,
                  label: 'Default',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.small,
                  state: AppzBadgeState.success,
                  label: 'Success',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.small,
                  state: AppzBadgeState.error,
                  label: 'Error',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.small,
                  state: AppzBadgeState.warning,
                  label: 'Warning',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.small,
                  state: AppzBadgeState.info,
                  label: 'Info',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Large Badges Row
            const Text(
              'Large Badges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.defaultState,
                  label: 'Default',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.success,
                  label: 'Success',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.error,
                  label: 'Error',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.warning,
                  label: 'Warning',
                ),
                const SizedBox(width: 16),
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.info,
                  label: 'Info',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Usage Examples
            const Text(
              'Usage Examples',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Status indicators
            const Text(
              'Status Indicators:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.success,
                  label: 'Active',
                ),
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.error,
                  label: 'Inactive',
                ),
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.warning,
                  label: 'Pending',
                ),
                AppzBadges(
                  size: AppzBadgeSize.xSmall,
                  state: AppzBadgeState.info,
                  label: 'Processing',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Categories
            const Text(
              'Categories:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.defaultState,
                  label: 'Technology',
                ),
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.defaultState,
                  label: 'Design',
                ),
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.defaultState,
                  label: 'Marketing',
                ),
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.defaultState,
                  label: 'Finance',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Priority levels
            const Text(
              'Priority Levels:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppzBadges(
                  size: AppzBadgeSize.small,
                  state: AppzBadgeState.error,
                  label: 'High',
                ),
                AppzBadges(
                  size: AppzBadgeSize.large,
                  state: AppzBadgeState.warning,
                  label: 'Medium',
                ),
                AppzBadges(
                  size: AppzBadgeSize.small,
                  state: AppzBadgeState.success,
                  label: 'Low',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
