import 'package:flutter/material.dart';

import 'package:shopq/app/data/models/home/section_item.dart';


class CategoryCard extends StatelessWidget {
  final SectionItem categoryItem;

  const CategoryCard({super.key, required this.categoryItem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.pink.shade50
            ),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/img_2.png',
              image: categoryItem.featuredImage.toString(),
              height: 70,
              width: 70,
              fit: BoxFit.contain,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/img_2.png',
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          Text(
            categoryItem.name.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5)),
          ),
        ],
      ),
    );
  }
}
