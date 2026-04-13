class AddressModel {
  final int id;
  final String name;
  final String phone;
  final String line1;
  final String? line2;
  final String? landmark;
  final String city;
  final String state;
  final String? pincode;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.line1,
    this.line2,
    this.landmark,
    required this.city,
    required this.state,
    this.pincode,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json['id'],
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    line1: json['line1'] ?? '',
    line2: json['line2'],
    landmark: json['landmark'],
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    pincode: json['pincode'],
    isDefault: json['is_default'] ?? false,
  );

  String get fullAddress {
    final parts = [line1, if (line2 != null) line2, city, state, pincode];
    return parts.whereType<String>().join(', ');
  }
}
