import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/home/section_item.dart';
import '../../../data/models/home/section_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarH = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        final color = controller.activeColor;
        final isLoading = controller.isLoading.value;
        final hasError =
            controller.errorMessage.value.isNotEmpty &&
            controller.sections.isEmpty;
        final sections = controller.sections.toList();
        final tabs = controller.tabs.toList();
        final selectedTab = controller.selectedTabIndex.value;
        final pinCode = controller.pinCode;
        final userName = controller.userName;

        return NotificationListener<ScrollNotification>(
          onNotification: (n) {
            controller.onScrollChanged(n.metrics.pixels);
            return false;
          },
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // App bar — draws behind status bar, pads itself
              /*SliverToBoxAdapter(
                child: _AppBar(
                  color: color,
                  userName: userName,
                  pinCode: pinCode,
                  statusBarHeight: statusBarH,
                  onCart: controller.goToCart,
                  onProfile: controller.goToProfile,
                ),
              ),*/
              _AppBar(
                color: color,
                userName: userName,
                pinCode: pinCode,
                statusBarHeight: statusBarH,
                onCart: controller.goToCart,
                onProfile: controller.goToProfile,
                tabs: tabs,
                selectedTab: selectedTab,
                onTabSelected: controller.onTabSelected,
                topPadding: statusBarH,
              ),

              // Sticky header — Now FLOATS (hides on scroll down, shows on scroll up)
              /*SliverPersistentHeader(
                pinned: true, // Changed to false for Flipkart behavior
                floating: true, // Reappears on scroll up
                delegate: _StickyHeaderDelegate(
                  color: color,
                  tabs: tabs,
                  selectedTab: selectedTab,
                  onTabSelected: controller.onTabSelected,
                  topPadding: statusBarH,
                ),
              ),*/
              if (isLoading)
                SliverToBoxAdapter(child: _HomeShimmer())
              else if (hasError)
                SliverToBoxAdapter(
                  child: _ErrorView(
                    message: controller.errorMessage.value,
                    onRetry: controller.loadHome,
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _SectionWidget(
                      section: sections[i],
                      controller: controller,
                    ),
                    childCount: sections.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      }),
    );
  }
}

class _AppBar extends StatelessWidget {
  final Color color;
  final String userName;
  final String pinCode;
  final double statusBarHeight;
  final VoidCallback onCart;
  final VoidCallback onProfile;

  final List tabs;
  final int selectedTab;
  final void Function(int) onTabSelected;
  final double topPadding;

  const _AppBar({
    required this.color,
    required this.userName,
    required this.pinCode,
    required this.statusBarHeight,
    required this.onCart,
    required this.onProfile,

    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
    required this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: color,
      pinned: true,
      floating: true,
      title: Text("ShopQ", style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed(Routes.cart);
          },
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            Get.toNamed(Routes.profile);
          },
          icon: Icon(Icons.person, color: Colors.white),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(127),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SearchBar(
                readOnly: true,
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                elevation: WidgetStatePropertyAll(0),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12),
                ),
                leading: Icon(Icons.search),
                trailing: [Icon(Icons.mic)],
                hintText: "Search Here...",
              ),
            ),

            SizedBox(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (_, i) {
                  final tab = tabs[i];
                  final isSel = selectedTab == i;
                  return GestureDetector(
                    onTap: () => onTabSelected(i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _tabIcon(tab.icon ?? ''),
                            size: 22,
                            color: isSel ? Colors.white : Colors.white70,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tab.label ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSel
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSel ? Colors.white : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isSel)
                            Container(
                              height: 2.5,
                              width: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    /*return Container(
      color: color,
      // padding: EdgeInsets.fromLTRB(16, statusBarHeight + 10, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName.isNotEmpty ? 'Hey, $userName 👋' : 'ShopQ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white70,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      pinCode.isNotEmpty ? 'PIN: $pinCode' : 'Set location',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _iconBtn(
            Icons.shopping_cart_outlined,
            onCart,
            margin: const EdgeInsets.only(right: 8),
          ),
          _iconBtn(Icons.person_outline_rounded, onProfile),
        ],
      ),
    );*/
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, {EdgeInsets? margin}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  IconData _tabIcon(String key) {
    switch (key) {
      case 'tag':
        return Icons.local_offer_rounded;
      case 'leaf':
        return Icons.eco_rounded;
      case 'rice':
        return Icons.rice_bowl_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  STICKY HEADER  — pure data-in, no Obx inside delegate
// ─────────────────────────────────────────────────────────────────────────────
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Color color;
  final List tabs;
  final int selectedTab;
  final void Function(int) onTabSelected;
  final double topPadding;

  const _StickyHeaderDelegate({
    required this.color,
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
    required this.topPadding,
  });

  static const double _searchH = 46;
  static const double _tabsH = 62;
  static const double _topPad = 8;
  static const double _gap = 6;
  static const double _contentH = _topPad + _searchH + _gap + _tabsH + 6;

  // Extent should include topPadding to cover status bar area when floating
  @override
  double get maxExtent => _contentH + topPadding;

  @override
  double get minExtent => _contentH + topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // When floating (overlapsContent is true), we show the status bar padding.
    // This prevents the search bar from going inside the status bar icons.
    final effectiveTopPadding = overlapsContent ? topPadding : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.fromLTRB(16, effectiveTopPadding + _topPad, 16, 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search bar
          GestureDetector(
            onTap: () => Get.toNamed(Routes.productList),
            child: Container(
              height: _searchH,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search products...',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.tune_rounded,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          const SizedBox(height: _gap),
          // Tabs
          SizedBox(
            height: _tabsH,
            child: tabs.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    itemBuilder: (_, i) {
                      final tab = tabs[i];
                      final isSel = selectedTab == i;
                      return GestureDetector(
                        onTap: () => onTabSelected(i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _tabIcon(tab.icon ?? ''),
                                size: 22,
                                color: isSel ? Colors.white : Colors.white70,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tab.label ?? '',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSel
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSel ? Colors.white : Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (isSel)
                                Container(
                                  height: 2.5,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _tabIcon(String key) {
    switch (key) {
      case 'tag':
        return Icons.local_offer_rounded;
      case 'leaf':
        return Icons.eco_rounded;
      case 'rice':
        return Icons.rice_bowl_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate old) =>
      old.color != color ||
      old.selectedTab != selectedTab ||
      old.topPadding != topPadding ||
      old.tabs.length != tabs.length;
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECTION DISPATCHER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionWidget extends StatelessWidget {
  final SectionModel section;
  final HomeController controller;

  const _SectionWidget({required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
    switch (section.type) {
      case 'banner_slider':
        return _BannerSlider(section: section, controller: controller);
      case 'category_chips':
        // return _CategoryChips(section: section, controller: controller);
        return _CategoryGrid(section: section, controller: controller);
      case 'category_grid':
        return _CategoryGrid(section: section, controller: controller);
      case 'product_carousel':
        return _ProductCarousel(section: section, controller: controller);
      case 'offer_strip':
        return _OfferStrip(section: section);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BANNER SLIDER
// ─────────────────────────────────────────────────────────────────────────────
class _BannerSlider extends StatefulWidget {
  final SectionModel section;
  final HomeController controller;

  const _BannerSlider({required this.section, required this.controller});

  @override
  State<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<_BannerSlider> {
  late final PageController _pageCtrl;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(viewportFraction: 1.0);
    _scheduleNext();
  }

  void _scheduleNext() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      final items = widget.section.items ?? [];
      if (items.length <= 1) return;
      final next = (_current + 1) % items.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _scheduleNext();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.section.items ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: items.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) {
                final banner = items[i];
                final url = widget.controller.resolveImageUrl(
                  banner.imageUrl ?? banner.image,
                );
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade100,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      url.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) =>
                                  _fallback(banner.title),
                            )
                          : _fallback(banner.title),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.45),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.65],
                          ),
                        ),
                      ),
                      if (banner.title != null)
                        Positioned(
                          left: 16,
                          top: 0,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.title!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
            children: List.generate(
              items.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback(String? title) => Container(
    color: AppColors.primary.withValues(alpha: 0.1),
    alignment: Alignment.center,
    child: Text(
      title ?? '',
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  CATEGORY CHIPS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
//  CATEGORY GRID
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryGrid extends StatelessWidget {
  final SectionModel section;
  final HomeController controller;

  const _CategoryGrid({required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = section.items ?? [];
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _SectionHeader(title: section.title ?? 'Categories', showViewAll: true),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final cat = items[i];
            final url = controller.resolveImageUrl(
              cat.featuredImage ?? cat.image,
            );
            return GestureDetector(
              onTap: () => controller.goToCategory(cat),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: url.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => _shimmerBox(),
                                errorWidget: (_, __, ___) => const Icon(
                                  Icons.category_outlined,
                                  color: Colors.grey,
                                ),
                              )
                            : const Icon(
                                Icons.category_outlined,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 5),
                  Text(
                    cat.name ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PRODUCT CAROUSEL
// ─────────────────────────────────────────────────────────────────────────────
class _ProductCarousel extends StatelessWidget {
  final SectionModel section;
  final HomeController controller;

  const _ProductCarousel({required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = section.items ?? [];
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _SectionHeader(
          title: section.title ?? 'Products',
          subtitle: section.subtitle,
          showViewAll: true,
          onViewAll: () => controller.goToProductList(),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            itemBuilder: (_, i) =>
                _ProductCard(product: items[i], controller: controller),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PRODUCT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final SectionItem product;
  final HomeController controller;

  const _ProductCard({required this.product, required this.controller});

  @override
  Widget build(BuildContext context) {
    final url = controller.resolveImageUrl(product.image);
    final price = product.price ?? 0.0;
    final mrp = product.mrp ?? price;
    final disc = product.discountPercent ?? 0;
    final inStock = product.inStock ?? true;

    return GestureDetector(
      onTap: () {
        if (product.slug != null) controller.goToProductDetail(product.slug!);
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: SizedBox.expand(
                      child: url.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => _productFallback(),
                            )
                          : _productFallback(),
                    ),
                  ),
                  if (disc > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '$disc%\nOFF',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  if (!inStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.38),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /*Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                width: double.infinity,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'ADD',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ), */
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Text(
                product.title ?? product.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  Text(
                    '₹${price % 1 == 0 ? price.toInt() : price}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  if (mrp > price) ...[
                    const SizedBox(width: 5),
                    Text(
                      '₹${mrp % 1 == 0 ? mrp.toInt() : mrp}',
                      style: const TextStyle(
                        fontSize: 10,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productFallback() => Container(
    color: const Color(0xFFF5F5F5),
    child: const Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 40),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  OFFER STRIP
// ─────────────────────────────────────────────────────────────────────────────
class _OfferStrip extends StatelessWidget {
  final SectionModel section;

  const _OfferStrip({required this.section});

  @override
  Widget build(BuildContext context) {
    final color = section.offer?.themeColor != null
        ? _hexColor(section.offer!.themeColor!)
        : const Color(0xFFFACC15);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: color.withValues(alpha: 0.9),
                  ),
                ),
                if (section.subtitle != null)
                  Text(
                    section.subtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      color: color.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
          if (section.offer?.cta != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                section.offer!.cta!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return const Color(0xFFFACC15);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showViewAll;
  final VoidCallback? onViewAll;

  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.showViewAll = false,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAll,
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHIMMER + ERROR
// ─────────────────────────────────────────────────────────────────────────────
class _HomeShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(height: 16, width: 140, color: Colors.white),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 6,
              itemBuilder: (_, __) => Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(height: 16, width: 180, color: Colors.white),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 4,
              itemBuilder: (_, __) => Container(
                width: 158,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _shimmerBox() => Shimmer.fromColors(
  baseColor: Colors.grey.shade200,
  highlightColor: Colors.grey.shade100,
  child: Container(color: Colors.white),
);
