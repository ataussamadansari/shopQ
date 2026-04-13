class OrderModel {
  final int id;
  final String orderNo;
  final String paymentMode;
  final double itemTotal;
  final double deliveryFee;
  final double grandTotal;
  final dynamic address;
  final String? createdAt;
  final List<OrderGroupModel> groups;

  OrderModel({
    required this.id,
    required this.orderNo,
    required this.paymentMode,
    required this.itemTotal,
    required this.deliveryFee,
    required this.grandTotal,
    this.address,
    this.createdAt,
    required this.groups,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'],
    orderNo: json['order_no'] ?? '',
    paymentMode: json['payment_mode'] ?? 'COD',
    itemTotal: (json['item_total'] as num).toDouble(),
    deliveryFee: (json['delivery_fee'] as num).toDouble(),
    grandTotal: (json['grand_total'] as num).toDouble(),
    address: json['address'],
    createdAt: json['created_at'],
    groups:
        (json['groups'] as List?)
            ?.map((e) => OrderGroupModel.fromJson(e))
            .toList() ??
        [],
  );
}

class OrderGroupModel {
  final int id;
  final String status;
  final String? sellerName;
  final List<OrderItemModel> items;

  OrderGroupModel({
    required this.id,
    required this.status,
    this.sellerName,
    required this.items,
  });

  factory OrderGroupModel.fromJson(Map<String, dynamic> json) =>
      OrderGroupModel(
        id: json['id'],
        status: json['status'] ?? 'pending',
        sellerName: json['seller']?['shop_name'],
        items:
            (json['items'] as List?)
                ?.map((e) => OrderItemModel.fromJson(e))
                .toList() ??
            [],
      );
}

class OrderItemModel {
  final int id;
  final String? productTitle;
  final String? image;
  final int qty;
  final double price;
  final double subtotal;

  OrderItemModel({
    required this.id,
    this.productTitle,
    this.image,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    id: json['id'],
    productTitle: json['product_title'],
    image: json['image'],
    qty: json['qty'] ?? 1,
    price: (json['price'] as num).toDouble(),
    subtotal: (json['subtotal'] as num).toDouble(),
  );
}
