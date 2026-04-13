import 'package:flutter/material.dart';

import 'package:shopq/app/data/models/category/sub_category.dart';

import 'product_card_tile.dart';

class ProductCardSlug extends StatelessWidget {
  final Products product;

  const ProductCardSlug({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final price = product.price ?? 0;
    final mrp = product.mrp ?? price;
    final discountPercent = product.discountPercent ?? 0;
    final isInStock = product.inStock ?? true;
    final textData = resolveProductCardText(
      product.title,
      fallbackMeta: product.sellerName,
    );

    return ProductCardTile(
      imageUrl: product.image,
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
