import 'package:apz_flutter_components/components/appz_progress_bar/appz_progress_bar.dart';
import 'package:flutter/material.dart';

class ExamplePg extends StatelessWidget {
  const ExamplePg({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Example'),
        ),
        body:  AppzProgressBar(percentage:50.0,labelPosition: ProgressBarLabelPosition.bottom)
        ),
    );
  }
}
