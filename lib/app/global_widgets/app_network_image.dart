import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String fallbackAsset;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fallbackAsset = "assets/images/img.png",
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = _hasImageUrl
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            width: width,
            height: height,
            fit: fit,
            placeholder: (_, __) => _ImageFallback(
              fallbackAsset: fallbackAsset,
              width: width,
              height: height,
              fit: fit,
            ),
            errorWidget: (_, __, ___) => _ImageFallback(
              fallbackAsset: fallbackAsset,
              width: width,
              height: height,
              fit: fit,
            ),
          )
        : _ImageFallback(
            fallbackAsset: fallbackAsset,
            width: width,
            height: height,
            fit: fit,
          );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  bool get _hasImageUrl => imageUrl != null && imageUrl!.trim().isNotEmpty;
}

class _ImageFallback extends StatelessWidget {
  final String fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;

  const _ImageFallback({
    required this.fallbackAsset,
    required this.width,
    required this.height,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF5F3EE),
      alignment: Alignment.center,
      child: Image.asset(fallbackAsset, width: width, height: height, fit: fit),
    );
  }
}
