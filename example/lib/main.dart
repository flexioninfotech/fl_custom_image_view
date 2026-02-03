import 'package:flutter/material.dart';
import 'package:fl_custom_image_view/custom_image_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Image View Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Image View'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Network Image',
            CustomImageView(
              imagePath: 'https://picsum.photos/400/200',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(12),
            ),
          ),
          _buildSection(
            'Network Image with Placeholder',
            const CustomImageView(
              imagePath: 'https://picsum.photos/400/150',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              usePlaceholder: true,
            ),
          ),
          _buildSection(
            'Circular Avatar (Network)',
            CustomImageView(
              imagePath: 'https://picsum.photos/100',
              height: 80,
              width: 80,
              radius: BorderRadius.circular(40),
              fit: BoxFit.cover,
            ),
          ),
          _buildSection(
            'With Border',
            CustomImageView(
              imagePath: 'https://picsum.photos/200/150',
              height: 150,
              width: 200,
              border: Border.all(color: Colors.blue, width: 3),
              radius: BorderRadius.circular(8),
            ),
          ),
          _buildSection(
            'With Tap Handler',
            CustomImageView(
              imagePath: 'https://picsum.photos/300/100',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image tapped!')),
              ),
            ),
          ),
          _buildSection(
            'Error Widget (Invalid URL)',
            CustomImageView(
              imagePath: 'https://invalid-url-that-will-fail.com/image.jpg',
              height: 120,
              width: double.infinity,
              errorWidget: Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
