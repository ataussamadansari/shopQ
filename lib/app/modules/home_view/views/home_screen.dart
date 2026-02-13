import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

// --- SCREEN ---
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() {
            // Mapping colors to categories to match images
            // 0: All (Blue), 1: Rice (Peach), 2: Kirana (Sky), 3: Fresh (Green), 4: Body Care (Yellow)
            List<Color> themeColors = [
              const Color(0xFF007DFE), // All - Blue
              const Color(0xFFE59C6C), // Rice - Peach/Brown
              const Color(0xFF7CB9E8), // Kirana - Sky Blue
              const Color(0xFF1B5E20), // Fresh - Dark Green
              const Color(0xFFFBC02D), // Body Care - Yellow
            ];
            // Safety check for index out of bounds
            int currentIndex = controller.selectedCategoryIndex.value;
            Color currentThemeColor =
                themeColors[currentIndex % themeColors.length];

            return Container(
              color: currentThemeColor, // HEADER + BANNER SHARED COLOR
              child: SafeArea(
                bottom: false,
                child: CustomScrollView(
                  slivers: [
                    _buildTopAddress(),
                    _buildPinnedSearchBar(),
                    _buildCategoryTabs(currentThemeColor),

                    // The Banner Section
                    SliverToBoxAdapter(child: _buildDynamicBanner()),

                    // White content area for products
                    // Inside the White Container of HomeScreen
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            // DYNAMIC LIST LOGIC
                            Obx(() {
                              String title = "Top Picks";
                              List<Product> currentList = controller.fruits;

                              if (controller.selectedCategoryIndex.value == 1) {
                                title = "Premium Rice Mall";
                                currentList = controller.riceList;
                              } else if (controller
                                      .selectedCategoryIndex
                                      .value ==
                                  3) {
                                title = "Daily Fresh Veggies";
                                currentList = controller.fruits;
                              }

                              return _buildHorizontalProductList(
                                title,
                                currentList,
                              );
                            }),

                            const SizedBox(height: 20),
                            _buildHorizontalProductList(
                              "Frequently Bought",
                              controller.milkProducts,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildTopAddress() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delivery In 24 Min",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "88V5+JRM Baherakhoot...",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.person_outline, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedSearchBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      // Transparent to show parent color
      automaticallyImplyLeading: false,
      title: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for "Milk"',
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            suffixIcon: Icon(Icons.mic_none, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(Color themeColor) {
    final categories = [
      {'name': 'All', 'icon': Icons.shopping_bag_outlined},
      {'name': 'Rice', 'icon': Icons.eco_outlined},
      {'name': 'Kirana', 'icon': Icons.agriculture_outlined},
      {'name': 'Fresh', 'icon': Icons.apple_outlined},
      {'name': 'Body Care', 'icon': Icons.spa_outlined},
    ];

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 100.0,
        maxHeight: 100.0,
        child: Container(
          color: themeColor, // Show shared background
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) => Obx(() {
              bool isSelected = controller.selectedCategoryIndex.value == index;
              return GestureDetector(
                onTap: () => controller.changeCategory(index),
                child: SizedBox(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          categories[index]['icon'] as IconData,
                          color: isSelected ? Colors.blue : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categories[index]['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          height: 3,
                          width: 40,
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 4),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicBanner() {
    int index = controller.selectedCategoryIndex.value;
    String title = "";
    String subTitle = "";

    switch (index) {
      case 1:
        title = "RICE MALL";
        subTitle = "Apki pasand ka har chawal";
        break;
      case 3:
        title = "DAILY FRESH";
        subTitle = "Your daily dose of fresh";
        break;
      default:
        title = "RICE MELA";
        subTitle = "Pasand ka har chawal saste daamo mai";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.w900,
              fontSize: 32,
            ),
          ),
          Text(
            subTitle,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 20),
          // Horizontal Rice Types
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _miniCard("Basmati Rice"),
                _miniCard("Usna Rice"),
                _miniCard("Arwa Rice"),
                _miniCard("Organic Rice"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniCard(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHorizontalProductList(String title, List<Product> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Text(
                "View All >",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            padding: const EdgeInsets.only(left: 16),
            itemBuilder: (context, index) => _productCard(items[index]),
          ),
        ),
      ],
    );
  }

  Widget _productCard(Product product) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain, // Important for product images
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.shopping_cart, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${product.price.toInt()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // _buildAddButton(product.price),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- HELPER DELEGATE ---
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight, maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(context, shrinkOffset, overlapsContent) =>
      SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_SliverAppBarDelegate old) => true;
}

class BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
