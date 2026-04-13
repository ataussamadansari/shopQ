class ProductDetailModel {
  final int id;
  final String title;
  final String slug;
  final String? description;
  final double price;
  final double mrp;
  final int stock;
  final bool availableInPincode;
  final List<String> images;
  final Map<String, dynamic>? brand;
  final Map<String, dynamic>? category;
  final Map<String, dynamic>? seller;
  final List<ProductVariant> variants;
  final dynamic specs;

  ProductDetailModel({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    required this.price,
    required this.mrp,
    required this.stock,
    required this.availableInPincode,
    required this.images,
    this.brand,
    this.category,
    this.seller,
    required this.variants,
    this.specs,
  });

  int get discountPercent =>
      mrp > 0 ? ((mrp - price) / mrp * 100).round().clamp(0, 100) : 0;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      availableInPincode: json['available_in_pincode'] ?? true,
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      brand: json['brand'],
      category: json['category'],
      seller: json['seller'],
      variants:
          (json['variants'] as List?)
              ?.map((e) => ProductVariant.fromJson(e))
              .toList() ??
          [],
      specs: json['specs'],
    );
  }
}

class ProductVariant {
  final int id;
  final String? sku;
  final double price;
  final double mrp;
  final int stock;
  final String? color;
  final String? size;
  final String? image;

  ProductVariant({
    required this.id,
    this.sku,
    required this.price,
    required this.mrp,
    required this.stock,
    this.color,
    this.size,
    this.image,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    id: json['id'],
    sku: json['sku'],
    price: (json['price'] as num).toDouble(),
    mrp: (json['mrp'] as num).toDouble(),
    stock: json['stock'] ?? 0,
    color: json['color'],
    size: json['size'],
    image: json['image'],
  );
}
