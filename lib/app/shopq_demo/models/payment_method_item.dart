class PaymentMethodItem {
  const PaymentMethodItem({
    required this.id,
    required this.type,
    required this.label,
    required this.holderName,
    required this.upiId,
    required this.cardLastFour,
    required this.cardNetwork,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
    required this.isActive,
  });

  final int id;
  final String type;
  final String label;
  final String? holderName;
  final String? upiId;
  final String? cardLastFour;
  final String? cardNetwork;
  final int? expiryMonth;
  final int? expiryYear;
  final bool isDefault;
  final bool isActive;

  String get displaySubtitle {
    if (type == 'upi') {
      return upiId ?? 'UPI';
    }
    if (type == 'card') {
      final network = (cardNetwork ?? 'Card').trim();
      final suffix = cardLastFour == null ? '' : ' **** $cardLastFour';
      return '$network$suffix';
    }
    return 'Payment method';
  }
}
