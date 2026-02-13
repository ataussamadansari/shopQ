import 'package:flutter/widgets.dart';

class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.title,
    required this.icon,
  });

  final String id;
  final String title;
  final IconData icon;
}
