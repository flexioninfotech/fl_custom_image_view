# Custom Image View

A flexible Flutter widget for displaying images from multiple sources with caching, placeholders, and extensive customization options.

## Features

- **Multiple image sources**: Network URLs, assets, local files, SVG, and Lottie animations
- **Automatic type detection**: Infers image type from path (URL, extension, file path)
- **Network caching**: Built-in caching for network images via `flutter_cache_manager`
- **Shimmer placeholder**: Optional loading placeholder with shimmer effect
- **Error handling**: Customizable error widget when image fails to load
- **Highly customizable**: Size, fit, alignment, borders, radius, color blending, and more
- **Tap support**: Optional `onTap` callback for interactive images

## Installation

Add `fl_custom_image_view` to your `pubspec.yaml`:

```yaml
dependencies:
  fl_custom_image_view: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Network Image

```dart
import 'package:fl_custom_image_view/custom_image_view.dart';

CustomImageView(
  imagePath: 'https://example.com/photo.jpg',
  height: 200,
  width: double.infinity,
  fit: BoxFit.cover,
)
```

### Asset Image

```dart
CustomImageView(
  imagePath: 'assets/images/logo.png',
  height: 100,
  width: 100,
)
```

### SVG Image

```dart
CustomImageView(
  imagePath: 'assets/icons/icon.svg',
  height: 24,
  width: 24,
  color: Colors.blue,
)
```

### Rounded Corners

```dart
CustomImageView(
  imagePath: 'https://example.com/avatar.jpg',
  height: 80,
  width: 80,
  radius: BorderRadius.circular(40),
  fit: BoxFit.cover,
)
```

### With Border

```dart
CustomImageView(
  imagePath: 'assets/images/product.png',
  height: 150,
  width: 150,
  border: Border.all(color: Colors.grey, width: 2),
  radius: BorderRadius.circular(8),
)
```

### With Tap Handler

```dart
CustomImageView(
  imagePath: 'https://example.com/image.jpg',
  height: 200,
  width: double.infinity,
  onTap: () => print('Image tapped!'),
)
```

### Custom Error Widget

```dart
CustomImageView(
  imagePath: 'https://invalid-url.com/image.jpg',
  height: 200,
  errorWidget: Container(
    color: Colors.grey[200],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, size: 48),
        SizedBox(height: 8),
        Text('Failed to load'),
      ],
    ),
  ),
)
```

### Lottie Animation

```dart
CustomImageView(
  imagePath: 'assets/animations/loading.json',
  height: 100,
  width: 100,
)
```

### Local File

```dart
CustomImageView(
  imagePath: '/storage/emulated/0/DCIM/photo.jpg',
  height: 300,
  width: double.infinity,
  fit: BoxFit.cover,
)
```

## API Reference

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `imagePath` | `String?` | `null` | Path or URL to the image. Required for display. |
| `height` | `double?` | `null` | Height of the image. |
| `width` | `double?` | `null` | Width of the image. |
| `color` | `Color?` | `null` | Color tint (for SVG and some image types). |
| `fit` | `BoxFit?` | `BoxFit.cover` | How the image fits within its bounds. |
| `alignment` | `Alignment?` | `null` | Alignment of the widget. |
| `onTap` | `VoidCallback?` | `null` | Callback when image is tapped. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Margin around the image. |
| `radius` | `BorderRadius?` | `null` | Border radius for clipping. |
| `border` | `BoxBorder?` | `null` | Border around the image. |
| `colorBlendMode` | `BlendMode?` | `BlendMode.srcOver` | Blend mode for network images. |
| `usePlaceholder` | `bool` | `true` | Show shimmer placeholder while loading. |
| `fadeInDuration` | `Duration` | `300ms` | Fade-in animation duration. |
| `fadeOutDuration` | `Duration` | `300ms` | Fade-out animation duration. |
| `errorWidget` | `Widget?` | `null` | Custom widget when load fails. |

## Image Type Detection

The package automatically detects image type from the path:

| Pattern | Type | Example |
|---------|------|---------|
| `http://` or `https://` | Network | `https://example.com/img.png` |
| Ends with `.svg` | SVG | `assets/icon.svg` |
| Ends with `.json` | Lottie | `assets/animations/loader.json` |
| Starts with `/data` or `/storage` | File | `/storage/emulated/0/photo.jpg` |
| Other | Asset (PNG/JPG) | `assets/images/logo.png` |


## License

MIT License - see [LICENSE](LICENSE) for details.
