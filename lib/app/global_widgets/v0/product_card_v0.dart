import 'package:flutter/material.dart';

import 'package:shopq/app/data/models/home/section_item.dart';

import '../product_card_tile.dart';

class ProductCard extends StatelessWidget {
  final SectionItem sectionItem;

  const ProductCard({super.key, required this.sectionItem});

  @override
  Widget build(BuildContext context) {
    final price = sectionItem.price ?? 0;
    final mrp = sectionItem.mrp ?? price;
    final discountPercent = sectionItem.discountPercent ?? 0;
    final isInStock = sectionItem.inStock ?? true;
    final textData = resolveProductCardText(
      sectionItem.title,
      fallbackMeta: sectionItem.sellerName,
    );

    return ProductCardTile(
      width: 132,
      imageUrl: sectionItem.image,
      title: textData.title,
      metaText: textData.metaText,
      price: price,
      mrp: mrp,
      discountPercent: discountPercent,
      isInStock: isInStock,
      fallbackAsset: "assets/images/img_1.png",
    );
  }
}
