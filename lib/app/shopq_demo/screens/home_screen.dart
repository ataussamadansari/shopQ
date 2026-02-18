import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/category_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.92);
    _startAutoBanner();
  }

  void _startAutoBanner() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final store = context.read<DemoStore>();
      if (!_bannerController.hasClients || store.banners.isEmpty) {
        return;
      }
      final next = (_bannerIndex + 1) % store.banners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _openProduct(Product product) {
    Navigator.pushNamed(
      context,
      RouteNames.productDetails,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        final featuredProducts = store.featuredProducts;
        final featuredProductIds = featuredProducts.map((product) => product.id).toSet();
        final flashSaleProducts = store.flashSaleProducts
            .where((product) => !featuredProductIds.contains(product.id))
            .toList(growable: false);

        return Scaffold(
          appBar: CustomAppBar(
            title: 'ShopQ',
            showBackButton: false,
            /*actions: <Widget>[
              IconButton(
                onPressed: () => Navigator.pushNamed(context, RouteNames.search),
                icon: const Icon(CupertinoIcons.search),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.pushNamed(context, RouteNames.cart),
                      icon: const Icon(CupertinoIcons.cart_fill),
                    ),
                    if (store.cartCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Color(0xFF15803D),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${store.cartCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],*/
          ),
          body: store.isHomeLoading
              ? const _HomeLoadingView()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, RouteNames.search),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(CupertinoIcons.search),
                            const SizedBox(width: 10),
                            Text(
                              'Search products, brands, categories...',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF64748B),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 168,
                      child: PageView.builder(
                        controller: _bannerController,
                        itemCount: store.banners.length,
                        onPageChanged: (index) => setState(() => _bannerIndex = index),
                        itemBuilder: (context, index) {
                          final banner = store.banners[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  banner.accentColor,
                                  banner.accentColor.withOpacity(0.75),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  right: -6,
                                  bottom: 0,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(24),
                                      topLeft: Radius.circular(60),
                                    ),
                                    child: _BannerImage(path: banner.imageAsset),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                                  child: SizedBox(
                                    width: 180,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          banner.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          banner.subtitle,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.92),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                        store.banners.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _bannerIndex == index ? 22 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _bannerIndex == index
                                ? Theme.of(context).colorScheme.primary
                                : const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SectionHeader(
                      title: 'Shop by Category',
                      actionText: 'See all',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: store.categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final category = store.categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () => Navigator.pushNamed(context, RouteNames.search),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    _SectionHeader(
                      title: 'Featured',
                      actionText: 'Explore',
                      onTap: () => Navigator.pushNamed(context, RouteNames.search),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: featuredProducts.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final product = featuredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () => _openProduct(product),
                            onAdd: () async {
                              final success = await store.addToCart(product);
                              if (!context.mounted) {
                                return;
                              }
                              _showSnack(
                                context,
                                success
                                    ? '${product.name} added to cart'
                                    : (store.lastErrorMessage ?? 'Unable to add item'),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionHeader(
                      title: 'Flash Sale',
                      actionText: 'View all',
                      onTap: () => Navigator.pushNamed(context, RouteNames.search),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: flashSaleProducts.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final product = flashSaleProducts[index];
                          return ProductCard(
                            product: product,
                            enableHero: false,
                            onTap: () => _openProduct(product),
                            onAdd: () async {
                              final success = await store.addToCart(product);
                              if (!context.mounted) {
                                return;
                              }
                              _showSnack(
                                context,
                                success
                                    ? '${product.name} added to cart'
                                    : (store.lastErrorMessage ?? 'Unable to add item'),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  final String title;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(actionText),
        ),
      ],
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: const <Widget>[
        LoadingShimmer(width: double.infinity, height: 52, borderRadius: 16),
        SizedBox(height: 16),
        LoadingShimmer(width: double.infinity, height: 168, borderRadius: 24),
        SizedBox(height: 16),
        LoadingShimmer(width: 140, height: 24),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(child: LoadingShimmer(width: 100, height: 108, borderRadius: 16)),
            SizedBox(width: 10),
            Expanded(child: LoadingShimmer(width: 100, height: 108, borderRadius: 16)),
            SizedBox(width: 10),
            Expanded(child: LoadingShimmer(width: 100, height: 108, borderRadius: 16)),
          ],
        ),
        SizedBox(height: 20),
        LoadingShimmer(width: 140, height: 24),
        SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: Row(
            children: <Widget>[
              Expanded(child: LoadingShimmer(width: 100, height: 230, borderRadius: 18)),
              SizedBox(width: 10),
              Expanded(child: LoadingShimmer(width: 100, height: 230, borderRadius: 18)),
            ],
          ),
        ),
      ],
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final isRemote = path.startsWith('http://') || path.startsWith('https://');
    return isRemote
        ? Image.network(
            path,
            width: 160,
            height: 168,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          )
        : Image.asset(
            path,
            width: 160,
            height: 168,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          );
  }

  Widget _fallback() {
    return Container(
      width: 160,
      height: 168,
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.photo),
    );
  }
}
