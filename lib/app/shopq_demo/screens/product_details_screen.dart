import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/micro_action_button.dart';
import '../widgets/rating_stars.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _imageController = PageController();
  int _activeImage = 0;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Product Details',
            actions: <Widget>[
              IconButton(
                onPressed: () => Navigator.pushNamed(context, RouteNames.cart),
                icon: const Icon(CupertinoIcons.cart_fill),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: <Widget>[
              SizedBox(
                height: 280,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      controller: _imageController,
                      itemCount: widget.product.imageAssets.length,
                      onPageChanged: (index) => setState(() => _activeImage = index),
                      itemBuilder: (context, index) {
                        final image = widget.product.imageAssets[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            color: Colors.white,
                            child: index == 0
                                ? Hero(
                                    tag: 'product-${widget.product.id}',
                                    child: _DetailImage(path: image),
                                  )
                                : _DetailImage(path: image),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 14,
                      child: Row(
                        children: List<Widget>.generate(
                          widget.product.imageAssets.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _activeImage == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _activeImage == index
                                  ? Theme.of(context).colorScheme.primary
                                  : const Color(0xFFCBD5E1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.product.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF15803D),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${widget.product.originalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF64748B),
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '${widget.product.discountPercent}% OFF',
                      style: const TextStyle(
                        color: Color(0xFF15803D),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              RatingStars(
                rating: widget.product.rating,
                reviewCount: widget.product.reviewCount,
                starSize: 16,
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Icon(
                    widget.product.inStock
                        ? CupertinoIcons.check_mark_circled_solid
                        : CupertinoIcons.xmark_circle_fill,
                    color: widget.product.inStock
                        ? const Color(0xFF15803D)
                        : const Color(0xFFDC2626),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.product.inStock ? 'In Stock' : 'Out of Stock',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Reviews',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              ...store.reviewsForProduct(widget.product.id).take(3).map(
                    (review) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            CupertinoIcons.chat_bubble_2_fill,
                            size: 16,
                            color: Color(0xFF1D4ED8),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(review)),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MicroActionButton(
                    label: 'Add to Cart',
                    icon: CupertinoIcons.cart_badge_plus,
                    filled: false,
                    onTap: () async {
                      final success = await store.addToCart(widget.product);
                      if (!context.mounted) {
                        return;
                      }
                      _showSnack(
                        context,
                        success
                            ? 'Added to cart'
                            : (store.lastErrorMessage ?? 'Unable to add item'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MicroActionButton(
                    label: 'Buy Now',
                    icon: CupertinoIcons.bolt_fill,
                    onTap: () async {
                      final success = await store.addToCart(widget.product);
                      if (!context.mounted) {
                        return;
                      }
                      if (!success) {
                        _showSnack(context, store.lastErrorMessage ?? 'Unable to proceed.');
                        return;
                      }
                      Navigator.pushNamed(context, RouteNames.checkout);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 850),
      ),
    );
  }
}

class _DetailImage extends StatelessWidget {
  const _DetailImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final isRemote = path.startsWith('http://') || path.startsWith('https://');
    return isRemote
        ? Image.network(
            path,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          )
        : Image.asset(
            path,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.photo),
    );
  }
}
