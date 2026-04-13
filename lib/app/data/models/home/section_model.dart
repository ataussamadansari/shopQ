import 'offer_payload.dart';
import 'section_item.dart';

class SectionModel {
  String? id;
  String? type;
  String? title;
  String? subtitle;

  /// For List payload
  List<SectionItem>? items;

  /// For Map payload (offer strip)
  OfferPayload? offer;

  SectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'];

    final payload = json['payload'];

    if (payload is List) {
      items = payload.map((e) => SectionItem.fromJson(e)).toList();
    } else if (payload is Map<String, dynamic>) {
      offer = OfferPayload.fromJson(payload);
    }
  }
}