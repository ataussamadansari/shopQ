import 'package:flutter/material.dart';

class BannerItem {
  const BannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.accentColor,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageAsset;
  final Color accentColor;
}
