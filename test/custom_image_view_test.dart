import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_custom_image_view/custom_image_view.dart';

void main() {
  group('ImageTypeExtension', () {
    test('detects network image from https URL', () {
      expect('https://example.com/image.png'.imageType, ImageType.network);
    });

    test('detects network image from http URL', () {
      expect('http://example.com/image.jpg'.imageType, ImageType.network);
    });

    test('detects SVG from path', () {
      expect('assets/icons/icon.svg'.imageType, ImageType.svg);
    });

    test('detects Lottie from json extension', () {
      expect('assets/animations/loader.json'.imageType, ImageType.lottie);
    });

    test('detects file from /data path', () {
      expect('/data/user/0/photo.jpg'.imageType, ImageType.file);
    });

    test('detects file from /storage path', () {
      expect('/storage/emulated/0/DCIM/photo.jpg'.imageType, ImageType.file);
    });

    test('detects PNG/asset for other paths', () {
      expect('assets/images/logo.png'.imageType, ImageType.png);
    });
  });

  group('CustomImageView', () {
    testWidgets('renders SizedBox.shrink when imagePath is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomImageView(),
          ),
        ),
      );

      expect(find.byType(CustomImageView), findsOneWidget);
    });

    testWidgets('renders with network image path', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomImageView(
              imagePath: 'https://example.com/image.png',
              height: 100,
              width: 100,
            ),
          ),
        ),
      );

      expect(find.byType(CustomImageView), findsOneWidget);
    });
  });
}
