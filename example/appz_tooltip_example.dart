
import 'package:flutter/material.dart';
import '../lib/components/appz_tooltip/appz_tooltip.dart';
import '../lib/components/apz_button/appz_button.dart';


class AppzTooltipExample extends StatelessWidget {
  const AppzTooltipExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          AppzTooltip(
            message: 'Tooltip below the button',
            type: AppzTooltipType.withoutSupportingMsg,
            position: AppzTooltipPosition.down,
            child: AppzButton(
              label: 'Tooltip bottom (Simple)',
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 32),
          AppzTooltip(
            message: 'Tooltip top the button',
            type: AppzTooltipType.withSupportingMsg,
            supportingText: 'Supporting text for tooltip top.',
            position: AppzTooltipPosition.top,
            child: AppzButton(
              label: 'Tooltip top (Supporting)',
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 32),
          AppzTooltip(
            message: 'Tooltip to the left',
            type: AppzTooltipType.withoutSupportingMsg,
            onLinkTap: () => print('Left link tapped!'),
            position: AppzTooltipPosition.left,
            child: AppzButton(
              label: 'Tooltip Left (Link)',
              onPressed: () {},
            ),
          ),
        
          const SizedBox(height: 32),
          AppzTooltip(
            message: 'Tooltip to the right',
            type: AppzTooltipType.withSupportingMsg,
            supportingText: 'Supporting text for tooltip right.',
            linkText: 'Details',
            onLinkTap: () => print('Right link tapped!'),
            position: AppzTooltipPosition.right,
            child: AppzButton(
              label: 'Tooltip Right (Supporting + Link)',
              onPressed: () {},
            ),
          ),
                const SizedBox(height: 32),
            AppzTooltip(
            message: 'Tooltip shown on click!(down)',
            type: AppzTooltipType.withSupportingMsg,
            supportingText: 'Supporting text for tooltip down.',
            linkText: 'Details',
            position: AppzTooltipPosition.down,
            triggerType: AppzTooltipTriggerType.click,
            child: Image.asset(
              'assets/icons/warning-2.png',
              width: 36,
              height: 36,
            ),
          ),
          
          const SizedBox(height: 32),
          // Example: Tooltip on click with an icon
          AppzTooltip(
            message: 'Tooltip shown on click!(left)',
            type: AppzTooltipType.withoutSupportingMsg,
            position: AppzTooltipPosition.left,
            triggerType: AppzTooltipTriggerType.click,
            child: Image.asset(
              'assets/icons/warning-2.png',
              width: 36,
              height: 36,
            ),
          ),
      
        
          const SizedBox(height: 32),
            AppzTooltip(
            message: 'Tooltip shown on click(top)',
            type: AppzTooltipType.withoutSupportingMsg,
            position: AppzTooltipPosition.top,
            triggerType: AppzTooltipTriggerType.click,
            child: Image.asset(
              'assets/icons/warning-2.png',
              width: 36,
              height: 36,
            ),
          ),
      
          const SizedBox(height: 32),
            AppzTooltip(
            message: 'Tooltip shown on click!(right)',
            type: AppzTooltipType.withSupportingMsg,
            supportingText: 'Supporting text for tooltip right.',
            linkText: 'Details',
            position: AppzTooltipPosition.right,
            triggerType: AppzTooltipTriggerType.click,
            child: Image.asset(
              'assets/icons/warning-2.png',
              width: 36,
              height: 36,
            ),
          ),
       
         
      
      
        ],
      ),
    );
  }
}
