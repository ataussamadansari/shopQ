class ProductCardModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final double mrp;
  final int discountPercent;
  final int stock;
  final bool inStock;
  final String? image;
  final String? brand;
  final ProductSeller? seller;

  ProductCardModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.mrp,
    required this.discountPercent,
    required this.stock,
    required this.inStock,
    this.image,
    this.brand,
    this.seller,
  });

  factory ProductCardModel.fromJson(Map<String, dynamic> json) {
    return ProductCardModel(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: (json['price'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
      discountPercent: json['discount_percent'] ?? 0,
      stock: json['stock'] ?? 0,
      inStock: json['in_stock'] ?? false,
      image: json['image'],
      brand: json['brand'],
      seller: json['seller'] != null
          ? ProductSeller.fromJson(json['seller'])
          : null,
    );
  }
}

class ProductSeller {
  final int id;
  final String name;
  final String slug;

  ProductSeller({required this.id, required this.name, required this.slug});

  factory ProductSeller.fromJson(Map<String, dynamic> json) => ProductSeller(
    id: json['id'],
    name: json['name'] ?? '',
    slug: json['slug'] ?? '',
  );
}
