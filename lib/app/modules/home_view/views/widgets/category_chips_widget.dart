import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopq/app/global_widgets/section_title.dart';
import 'package:shopq/app/routes/app_routes.dart';

import '../../../../data/models/home/section_item.dart';
import '../../../../global_widgets/app_network_image.dart';

class CategoryChipsWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<SectionItem> categories;

  const CategoryChipsWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title, subtitle: subtitle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 12.0;
                final width = constraints.maxWidth;
                final columns = width >= 520
                    ? 5
                    : width >= 380
                    ? 5
                    : 4;
                final itemWidth = (width - ((columns - 1) * spacing)) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: 16,
                  children: [
                    for (var index = 0; index < categories.length; index++)
                      _CategoryWrapItem(
                        category: categories[index],
                        width: itemWidth,
                        backgroundColor: _backgroundColorFor(index),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _backgroundColorFor(int index) {
    const colors = [
      Color(0xFFFCE7BF),
      Color(0xFFDDF4D6),
      Color(0xFFF9D9DB),
      Color(0xFFDDF0F8),
      Color(0xFFE9E0FF),
    ];

    return colors[index % colors.length];
  }
}

class _CategoryWrapItem extends StatelessWidget {
  final SectionItem category;
  final double width;
  final Color backgroundColor;

  const _CategoryWrapItem({
    required this.category,
    required this.width,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.category, arguments: category),
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
              height: 88,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withAlpha(120)),
              ),
              child: AppNetworkImage(
                imageUrl: category.featuredImage,
                fit: BoxFit.contain,
                fallbackAsset: "assets/images/img_2.png",
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name?.trim().isNotEmpty == true
                  ? category.name!.trim()
                  : "Category",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1B),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
