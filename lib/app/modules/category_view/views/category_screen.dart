import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/themes/app_colors.dart';
import '../../../data/models/home/section_item.dart';
import '../../../global_widgets/product_card_slug.dart';
import '../../../routes/app_routes.dart';
import '../controllers/category_controller.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        title: _ReactiveTitle(controller: controller),
      ),
      body: SafeArea(
        top: false,
        child: Row(
          children: [
            SizedBox(
              width: 96,
              child: _MainCategoryList(controller: controller),
            ),
            Expanded(child: _RightPanel(controller: controller)),
          ],
        ),
      ),
    );
  }
}

class _ReactiveTitle extends StatelessWidget {
  final CategoryController controller;

  const _ReactiveTitle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        controller.appBarTitle,
        style: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _MainCategoryList extends StatelessWidget {
  final CategoryController controller;

  const _MainCategoryList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.mainCategories.toList();
      final selected = controller.selectedMain.value;

      return Container(
        color: const Color(0xFFF0F1F3),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: categories.length,
          itemBuilder: (_, index) {
            final item = categories[index];
            return _MainCatTile(
              item: item,
              isSelected: _isSameItem(selected, item),
              onTap: () => controller.selectMain(item),
            );
          },
        ),
      );
    });
  }

  bool _isSameItem(SectionItem? a, SectionItem b) {
    if (a == null) {
      return false;
    }

    if (a.id != null && b.id != null) {
      return a.id == b.id;
    }

    return a.slug == b.slug && a.name == b.name;
  }
}

class _RightPanel extends StatelessWidget {
  final CategoryController controller;

  const _RightPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final subCategories = controller.subCategories.toList();
      final selectedMain = controller.selectedMain.value;
      final selectedSub = controller.selectedSub.value;
      final products = controller.products.toList();
      final isLoading = controller.isLoading.value;
      final errorMessage = controller.errorMessage.value;

      return Container(
        color: const Color(0xFFF7F7F7),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedMain?.name ?? controller.appBarTitle,
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subCategories.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final subCategory in subCategories)
                          _SubCategoryChip(
                            label: subCategory.name ?? '',
                            isSelected: _isSameItem(selectedSub, subCategory),
                            onTap: () => controller.toggleSub(subCategory),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: isLoading && products.isEmpty
                  ? _buildShimmer()
                  : errorMessage.isNotEmpty && products.isEmpty
                  ? _StateView(message: errorMessage)
                  : products.isEmpty
                  ? const _StateView(message: 'No products found')
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.58,
                          ),
                      itemBuilder: (_, index) {
                        final product = products[index];
                        if ((product.slug ?? '').trim().isEmpty) {
                          return ProductCardSlug(product: product);
                        }

                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            Routes.productDetail,
                            arguments: {'slug': product.slug},
                          ),
                          child: ProductCardSlug(product: product),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  bool _isSameItem(SectionItem? a, SectionItem b) {
    if (a == null) {
      return false;
    }

    if (a.id != null && b.id != null) {
      return a.id == b.id;
    }

    return a.slug == b.slug && a.name == b.name;
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _SubCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubCategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? AppColors.primary : const Color(0xFF333333),
      ),
      selectedColor: AppColors.primary.withValues(alpha: 0.12),
      backgroundColor: const Color(0xFFF5F5F5),
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? AppColors.primary : const Color(0xFFDCDCDC),
        ),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }
}

class _StateView extends StatelessWidget {
  final String message;

  const _StateView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _MainCatTile extends StatelessWidget {
  final SectionItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _MainCatTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((item.featuredImage ?? '').trim().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: item.featuredImage!,
                  height: 44,
                  width: 44,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const _CategoryFallbackIcon(),
                ),
              )
            else
              const _CategoryFallbackIcon(),
            const SizedBox(height: 6),
            Text(
              item.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                height: 1.25,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFallbackIcon extends StatelessWidget {
  const _CategoryFallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.category_outlined, size: 24, color: Colors.grey),
    );
  }
}
