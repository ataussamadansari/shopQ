import 'package:flutter/material.dart';
import 'package:shopq/app/global_widgets/category_card.dart';

import '../../../../data/models/home/section_item.dart';
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

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SectionTitle(title: title, subtitle: subtitle),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var index = 0; index < categories.length; index++)
                  CategoryCard(categoryItem: categories[index]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
