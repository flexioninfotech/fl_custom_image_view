/// A flexible Flutter widget for displaying images from multiple sources:
/// network, assets, file, SVG, and Lottie animations.
///
/// Supports caching, placeholders, error handling, and extensive customization.
library custom_image_view;

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cache_manager;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

/// Image type enum for supported image formats.
enum ImageType { svg, png, network, file, lottie, unknown }

/// Extension to determine [ImageType] from a string path.
extension ImageTypeExtension on String {
  /// Returns the [ImageType] based on the path pattern.
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (endsWith('.json')) {
      return ImageType.lottie;
    } else if (startsWith('/data') || startsWith('/storage')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

/// A flexible image view widget that supports multiple image sources.
///
/// Displays images from:
/// - Network URLs (with caching)
/// - Asset paths (PNG, JPG, etc.)
/// - SVG files
/// - Local file paths
/// - Lottie JSON animations
///
/// Example:
/// ```dart
/// CustomImageView(
///   imagePath: 'https://example.com/image.png',
///   height: 200,
///   width: double.infinity,
///   fit: BoxFit.cover,
/// )
/// ```
class CustomImageView extends StatelessWidget {
  /// [imagePath] is required parameter for showing image.
  ///
  /// Supported formats:
  /// - `http://` or `https://` - Network images
  /// - `.svg` - SVG assets
  /// - `.json` - Lottie animations
  /// - `/data` or `/storage` - Local file paths
  /// - Other - Asset images (PNG, JPG, etc.)
  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final BlendMode? colorBlendMode;
  final bool usePlaceholder;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final Widget? errorWidget;

  const CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.colorBlendMode,
    this.usePlaceholder = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: _buildCircleImage()),
      ),
    );
  }

  Widget _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  Widget _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: color != null
                  ? ColorFilter.mode(color!, BlendMode.srcIn)
                  : null,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imagePath!,
            filterQuality: FilterQuality.low,
            memCacheWidth: width?.toInt(),
            memCacheHeight: height?.toInt(),
            color: color,
            repeat: ImageRepeat.noRepeat,
            placeholderFadeInDuration: fadeInDuration,
            fadeInDuration: fadeInDuration,
            fadeOutDuration: fadeOutDuration,
            colorBlendMode: colorBlendMode ?? BlendMode.srcOver,
            fadeOutCurve: Curves.easeOut,
            placeholder: usePlaceholder
                ? (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade50,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    )
                : null,
            cacheManager: _createSafeCacheManager(),
            errorWidget: (context, url, error) =>
                errorWidget ??
                Icon(Icons.error, size: height, color: Colors.grey),
          );
        case ImageType.lottie:
          return Lottie.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
          );
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            alignment: Alignment.center,
          );
      }
    }
    return const SizedBox.shrink();
  }
}

cache_manager.CacheManager _createSafeCacheManager() {
  try {
    return cache_manager.CacheManager(
      cache_manager.Config(
        'custom_image_view',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 1000,
        repo: cache_manager.JsonCacheInfoRepository(
          databaseName: 'custom_image_view',
        ),
        fileService: cache_manager.HttpFileService(),
      ),
    );
  } catch (e) {
    debugPrint('CacheManager init failed, clearing cache: $e');
    cache_manager
        .CacheManager(cache_manager.Config('custom_image_view'))
        .emptyCache();
    return cache_manager.CacheManager(
      cache_manager.Config(
        'custom_image_view_backup',
        stalePeriod: const Duration(days: 7),
      ),
    );
  }
}
