import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import 'rating_stars.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
    this.enableHero = true,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 184,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: enableHero
                      ? Hero(
                          tag: 'product-${product.id}',
                          child: _AdaptiveImage(
                            path: product.imageAssets.first,
                            height: 110,
                            width: double.infinity,
                          ),
                        )
                      : _AdaptiveImage(
                          path: product.imageAssets.first,
                          height: 110,
                          width: double.infinity,
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                RatingStars(rating: product.rating, starSize: 13),
                const Spacer(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: '\$${product.price.toStringAsFixed(2)}\n',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: const Color(0xFF15803D),
                                fontWeight: FontWeight.w800,
                              ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: '\$${product.originalPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF64748B),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: const Color(0xFF15803D),
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap: onAdd,
                        borderRadius: BorderRadius.circular(100),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            CupertinoIcons.cart_badge_plus,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdaptiveImage extends StatelessWidget {
  const _AdaptiveImage({
    required this.path,
    required this.height,
    required this.width,
  });

  final String path;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isRemote = path.startsWith('http://') || path.startsWith('https://');
    return isRemote
        ? Image.network(
            path,
            fit: BoxFit.cover,
            width: width,
            height: height,
            errorBuilder: (_, __, ___) => _fallback(),
          )
        : Image.asset(
            path,
            fit: BoxFit.cover,
            width: width,
            height: height,
            errorBuilder: (_, __, ___) => _fallback(),
          );
  }

  Widget _fallback() {
    return Container(
      height: height,
      width: width,
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.photo),
    );
  }
}
