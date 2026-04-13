import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:shopq/app/routes/app_routes.dart';

import '../../../../data/models/home/section_item.dart';
import '../../../../global_widgets/app_network_image.dart';
import '../../../../global_widgets/section_title.dart';

class CategoryGridWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<SectionItem> categories;

  const CategoryGridWidget({
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

    return MultiSliver(
      children: [
        SliverToBoxAdapter(
          child: SectionTitle(title: title, subtitle: subtitle),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final cat = categories[index];

              return GestureDetector(
                onTap: () => Get.toNamed(Routes.category, arguments: cat),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: const Color(0xFFE8E3D7)),
                    boxShadow: const [
                      BoxShadow(
                        // color: Color(0x0A000000),
                        // blurRadius: 12,
                        // offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 64,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // color: _backgroundColorFor(index),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AppNetworkImage(
                          imageUrl: cat.featuredImage,
                          height: 48,
                          fit: BoxFit.contain,
                          fallbackAsset: "assets/images/img_3.png",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cat.name?.trim().isNotEmpty == true
                            ? cat.name!.trim()
                            : "Category",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1D1B),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: categories.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 12,
              mainAxisExtent: 122,
            ),
          ),
        ),
      ],
    );
  }

  Color _backgroundColorFor(int index) {
    const colors = [
      Color(0xFFFDEBCB),
      Color(0xFFDFF5DA),
      Color(0xFFFBE1E4),
      Color(0xFFE0F2F7),
    ];

    return colors[index % colors.length];
  }
}
