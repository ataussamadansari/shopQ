class CartModel {
  final int id;
  final String? pincode;
  final int itemsCount;
  final CartTotals totals;
  final List<CartItemModel> items;

  CartModel({
    required this.id,
    this.pincode,
    required this.itemsCount,
    required this.totals,
    required this.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      pincode: json['pincode'],
      itemsCount: json['items_count'] ?? 0,
      totals: CartTotals.fromJson(json['totals'] ?? {}),
      items:
          (json['items'] as List?)
              ?.map((e) => CartItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CartTotals {
  final double items;
  final double itemTotal;
  final double deliveryFee;
  final double grandTotal;

  CartTotals({
    required this.items,
    required this.itemTotal,
    required this.deliveryFee,
    required this.grandTotal,
  });

  factory CartTotals.fromJson(Map<String, dynamic> json) => CartTotals(
    items: (json['items'] as num?)?.toDouble() ?? 0,
    itemTotal: (json['item_total'] as num?)?.toDouble() ?? 0,
    deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
    grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0,
  );
}

class CartItemModel {
  final int id;
  final int productId;
  final String? productTitle;
  final String? productSlug;
  final int? variantId;
  final int qty;
  final double price;
  final double subtotal;
  final int? sellerId;
  final String? image;

  CartItemModel({
    required this.id,
    required this.productId,
    this.productTitle,
    this.productSlug,
    this.variantId,
    required this.qty,
    required this.price,
    required this.subtotal,
    this.sellerId,
    this.image,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id: json['id'],
    productId: json['product_id'],
    productTitle: json['product_title'],
    productSlug: json['product_slug'],
    variantId: json['variant_id'],
    qty: json['qty'] ?? 1,
    price: (json['price'] as num).toDouble(),
    subtotal: (json['subtotal'] as num).toDouble(),
    sellerId: json['seller_id'],
    image: json['image'],
  );
}
