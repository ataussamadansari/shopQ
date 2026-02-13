class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAssets,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.categoryId,
    required this.isFeatured,
    required this.isFlashSale,
    required this.inStock,
  });

  final String id;
  final String name;
  final String description;
  final List<String> imageAssets;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String categoryId;
  final bool isFeatured;
  final bool isFlashSale;
  final bool inStock;

  int get discountPercent {
    if (originalPrice <= 0) {
      return 0;
    }
    return (((originalPrice - price) / originalPrice) * 100).round();
  }
}
