import 'package:flutter/material.dart';

import '../../../../data/models/home/section_item.dart';
import '../../../../global_widgets/product_card.dart';
import '../../../../global_widgets/section_title.dart';

class ProductCarouselWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<SectionItem> products;

  const ProductCarouselWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title, subtitle: subtitle),
          SizedBox(
            height: 190,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return ProductCard(sectionItem: products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
