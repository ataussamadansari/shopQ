class OfferPayload {
  String? cta;
  String? themeColor;

  OfferPayload.fromJson(Map<String, dynamic> json) {
    cta = json['cta'];
    themeColor = json['themeColor'];
  }
}