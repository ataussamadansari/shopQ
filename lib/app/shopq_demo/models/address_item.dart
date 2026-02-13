class AddressItem {
  const AddressItem({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isDefault,
  });

  final int id;
  final String label;
  final String recipientName;
  final String phone;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;

  String get displayLabel {
    final parts = <String>[
      line1,
      if ((line2 ?? '').trim().isNotEmpty) line2!.trim(),
      city,
      state,
      postalCode,
    ];
    return '$label - ${parts.join(', ')}';
  }
}
