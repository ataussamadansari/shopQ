import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/product/product_detail_model.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final error = controller.errorMessage.value;
      final p = controller.product.value;
      final qty = controller.qty.value;
      final selectedImage = controller.selectedImageIndex.value;
      final selectedVariant = controller.selectedVariantId.value;
      final isAddingToCart = controller.isAddingToCart.value;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
          title: Text(
            p?.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: isLoading
            ? _buildShimmer()
            : error.isNotEmpty
            ? Center(child: Text(error))
            : p == null
            ? const SizedBox()
            : _buildBody(p, selectedImage, qty, selectedVariant),
        bottomNavigationBar: (!isLoading && p != null)
            ? _buildBottomBar(p.stock > 0, isAddingToCart)
            : null,
      );
    });
  }

  Widget _buildBody(
    ProductDetailModel p,
    int selectedImage,
    int qty,
    int? selectedVariant,
  ) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildImageGallery(p.images, selectedImage),
        _buildInfo(p, qty),
        if (p.variants.isNotEmpty) _buildVariants(p, selectedVariant),
        if (p.description != null && p.description!.isNotEmpty)
          _buildDescription(p.description!),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Image gallery ──────────────────────────────────────────────
  Widget _buildImageGallery(List<String> images, int selectedIndex) {
    if (images.isEmpty) {
      return Container(
        height: 280,
        color: const Color(0xFFF5F5F5),
        child: const Icon(Icons.image_outlined, size: 80, color: Colors.grey),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: controller.selectImage,
            itemBuilder: (_, i) {
              final url = _resolveUrl(images[i]);
              return CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (_, __, ___) => const Icon(
                  Icons.image_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        if (images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                width: selectedIndex == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: selectedIndex == i
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── Product info ───────────────────────────────────────────────
  Widget _buildInfo(ProductDetailModel p, int qty) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (p.brand != null)
            Text(
              p.brand!['name'] ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            p.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '₹${p.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 10),
              if (p.mrp > p.price) ...[
                Text(
                  '₹${p.mrp.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${p.discountPercent}% OFF',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                p.stock > 0 ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: p.stock > 0 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                p.stock > 0
                    ? 'In Stock (${p.stock} available)'
                    : 'Out of Stock',
                style: TextStyle(
                  fontSize: 13,
                  color: p.stock > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Text(
                'Quantity:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              _qtyBtn(Icons.remove, controller.decrementQty),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$qty',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _qtyBtn(Icons.add, controller.incrementQty),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  // ── Variants ───────────────────────────────────────────────────
  Widget _buildVariants(ProductDetailModel p, int? selectedVariant) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Variants',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: p.variants.map((v) {
              final isSelected = selectedVariant == v.id;
              return GestureDetector(
                onTap: () => controller.selectVariant(v.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    [
                      if (v.color != null) v.color!,
                      if (v.size != null) v.size!,
                    ].join(' / '),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Description ────────────────────────────────────────────────
  Widget _buildDescription(String desc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF555555),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom bar ─────────────────────────────────────────────────
  Widget _buildBottomBar(bool inStock, bool isAddingToCart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: inStock && !isAddingToCart ? controller.addToCart : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isAddingToCart
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                inStock ? 'Add to Cart' : 'Out of Stock',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // ── Shimmer ────────────────────────────────────────────────────
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(height: 280, color: Colors.white),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 80, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 22, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 22, width: 140, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── URL helper — replace localhost with production domain ──────
  String _resolveUrl(String url) {
    if (url.contains('localhost') || url.contains('127.0.0.1')) {
      // Replace local URL with production base
      return url
          .replaceAll('http://localhost:8000', 'https://shopq.aradhyatech.com')
          .replaceAll('http://127.0.0.1:8000', 'https://shopq.aradhyatech.com');
    }
    return url;
  }
}
