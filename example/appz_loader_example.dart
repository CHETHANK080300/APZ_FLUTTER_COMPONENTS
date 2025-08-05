import 'package:flutter/material.dart';
import '../lib/components/appz_loader/appz_loader.dart';
import '../lib/components/appz_text/appz_text.dart';

class AppzLoaderExample extends StatelessWidget {
  const AppzLoaderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzLoader Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppzLoader(
              assetPath: 'assets/loader/hourglass_loading.gif',
              height: 100,
              width: 100,
              label: AppzText(
                'Loading from asset...',
                category: 'label',
                fontWeight: 'bold',
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            AppzLoader(
              imageUrl: 'https://media.giphy.com/media/y1ZBcOGOOtlpC/giphy.gif',
              label: AppzText(
                'Loading from network...',
                category: 'label',
                fontWeight: 'regular',
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 