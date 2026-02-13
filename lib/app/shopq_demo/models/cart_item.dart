import 'product.dart';

class CartItem {
  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  final int id;
  final Product product;
  final int quantity;
  final double unitPrice;

  double get lineTotal => unitPrice * quantity;
}
