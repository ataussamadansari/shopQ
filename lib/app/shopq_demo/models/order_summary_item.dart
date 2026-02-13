import 'order_status_step.dart';

class OrderSummaryItem {
  const OrderSummaryItem({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    required this.itemsCount,
    required this.placedAt,
    required this.tracking,
  });

  final int id;
  final String orderNumber;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double subtotal;
  final double shippingFee;
  final double total;
  final int itemsCount;
  final DateTime? placedAt;
  final List<OrderStatusStep> tracking;
}
