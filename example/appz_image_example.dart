import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_image/appz_image.dart';
import 'package:apz_flutter_components/components/appz_image/appz_assets.dart';

class AppzImageExamplePage extends StatelessWidget {
  const AppzImageExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzImage Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Icons (using appearance-specific defaults - square only with 2px padding):'),
            const SizedBox(height: 8),
            Row(
              children: [
                AppzImage(
                  assetName: AppzIcons.arrow,
                  size: AppzImageSize.square(), 
                ),
                const SizedBox(width: 16),
                AppzImage(
                  assetName: AppzIcons.user,
                  size: AppzImageSize.square(), 
                ),
                const SizedBox(width: 16),
                AppzImage(
                  assetName: AppzIcons.home,
                  size: AppzImageSize.square(), 
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('Icons (with custom dimensions - corner radius ignored, uses JSON value):'),
            const SizedBox(height: 8),
            Row(
              children: [
                AppzImage(
                  assetName: AppzIcons.arrow,
                  size: AppzImageSize.square(size: 32),
                ),
                const SizedBox(width: 16),
                AppzImage(
                  assetName: AppzIcons.user,
                  size: AppzImageSize.square(size: 48),
                ),
                const SizedBox(width: 16),
                AppzImage(
                  assetName: AppzIcons.home,
                  size: AppzImageSize.square(size: 64),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('Images (using appearance-specific defaults):'),
            const SizedBox(height: 8),
            Row(
              children: [
                AppzImage(
                  assetName: 'assets/images/head1.jpg',
                  size: AppzImageSize.circular(), 
                ),
                const SizedBox(width: 16),
                AppzImage(
                  assetName: 'assets/images/head1.jpg',
                  size: AppzImageSize.square(), 
                ),
                const SizedBox(width: 16),
                AppzImage(
                  assetName: 'assets/images/Logo=black logo.png',
                  size: AppzImageSize.rectangle(), 
                ),
              ],
            ),
          
            const SizedBox(height: 24),
            const Text('Images (with custom dimensions):'),
            const SizedBox(height: 8),
            Row(
              children: [
                AppzImage(
                  assetName: 'assets/images/head1.jpg',
                  size: AppzImageSize.circular(size: 80, cornerRadius: 40),
                ),
                const SizedBox(width: 16),
                AppzImage(
                  assetName: 'assets/images/head1.jpg',
                  size: AppzImageSize.square(size: 50, cornerRadius: 12), 
                ),
                const SizedBox(width: 16),
                AppzImage(
                  assetName: 'assets/images/Logo=black logo.png',
                  size: AppzImageSize.rectangle(
                    width: 100,
                    height: 50,
                    cornerRadius: 0.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
