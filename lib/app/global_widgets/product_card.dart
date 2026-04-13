import 'package:flutter/material.dart';

import 'package:shopq/app/data/models/home/section_item.dart';

import '../core/utils/zig_zig_clipper.dart';

class ProductCard extends StatelessWidget {
  final SectionItem sectionItem;

  const ProductCard({super.key, required this.sectionItem});

  @override
  Widget build(BuildContext context) {
    final discount = sectionItem.discountPercent == 0
        ? null
        : sectionItem.discountPercent;

    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/logo.jpeg',
                  image: sectionItem.image.toString(),
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),

                if (discount != null)
                  Positioned(
                    child: ClipPath(
                      clipper: ZigZagClipper(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 5,
                        ),
                        color: Colors.red,
                        child: Text(
                          "$discount%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(
            sectionItem.title.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹ ${sectionItem.price}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹ ${sectionItem.mrp}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough, // cut price
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
