/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. Top Address (Scrolls away)
            _buildTopAddress(),

            // 2. Search Bar (STAYS PINNED)
            _buildPinnedSearchBar(),

            // 3. Category Tabs (STAYS PINNED below search)
            _buildCategoryTabs(),

            // 4. Content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildRiceMelaBanner(),
                  _buildHorizontalProductList("Fruits & Vegetables", controller.fruits),
                  _buildHorizontalProductList("Handpicked for You", controller.milkProducts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildTopAddress() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.blue, size: 30),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Delivery In 24 Min", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("88V5+JRM Baherakhoot...", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.person_outline, color: Colors.blue)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedSearchBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      // This removes the back button space if you don't have a drawer
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for "Milk"',
            prefixIcon: const Icon(Icons.search, color: Colors.blue),
            suffixIcon: const Icon(Icons.mic_none),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      {'name': 'All', 'image': 'https://cdn-icons-png.flaticon.com/512/3081/3081840.png'},
      {'name': 'Rice', 'image': 'https://cdn-icons-png.flaticon.com/512/2619/2619588.png'},
      {'name': 'Kirana', 'image': 'https://cdn-icons-png.flaticon.com/512/3050/3050210.png'},
      {'name': 'Fresh', 'image': 'https://cdn-icons-png.flaticon.com/512/1625/1625099.png'},
      {'name': 'Body Care', 'image': 'https://cdn-icons-png.flaticon.com/512/1944/1944311.png'},
    ];

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 90.0,
        maxHeight: 90.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Obx(() {
                bool isSelected = controller.selectedCategoryIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.changeCategory(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        // Circular Image/Icon Background
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[50],
                            border: Border.all(
                                color: isSelected ? Colors.blue : Colors.transparent,
                                width: 1.5
                            ),
                          ),
                          child: Image.network(
                            categories[index]['image']!,
                            height: 30,
                            width: 30,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.category, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          categories[index]['name']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.blue : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRiceMelaBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text("RICE MELA", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 24)),
          const Text("Pasand ka har chawal sabse saste daamo mai", style: TextStyle(color: Colors.white, fontSize: 10)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _riceCategoryItem("Basmati"),
              _riceCategoryItem("Regular"),
              _riceCategoryItem("Arwa"),
            ],
          )
        ],
      ),
    );
  }

  Widget _riceCategoryItem(String label) {
    return Column(
      children: [
        CircleAvatar(radius: 25, backgroundColor: Colors.white, child: Icon(Icons.rice_bowl)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }

  // Updated to accept the specific list of products
  Widget _buildHorizontalProductList(String title, List<Product> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextButton(onPressed: () {}, child: const Text("View All >")),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            padding: const EdgeInsets.only(left: 16),
            itemBuilder: (context, index) => _productCard(items[index]),
          )),
        ),
      ],
    );
  }

  Widget _productCard(Product product) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder with "Discount" tag
          Stack(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.image, color: Colors.grey)),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  ),
                  child: const Text("30% OFF", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹${product.price.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: () => controller.addToCart(product.price),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text("ADD", style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Delegate for Sticky Category Bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.minHeight, required this.maxHeight, required this.child});
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override double get minExtent => minHeight;
  @override double get maxExtent => maxHeight;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);
  @override bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => true;
}*/
