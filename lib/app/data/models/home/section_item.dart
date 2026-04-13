import 'seller.dart';

class SectionItem {
  int? id;

  /// Banner
  String? title;
  String? imageUrl;
  dynamic link;

  /// Category
  String? name;
  String? slug;
  String? featuredImage;
  int? parentId;
  List<SectionItem>? children;

  /// Product
  double? price;
  double? mrp;
  int? discountPercent;
  int? stock;
  bool? inStock;
  String? image;
  Seller? seller;
  String? sellerName;

  SectionItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    title = json['title'];
    imageUrl = json['image_url'];
    link = json['link'];

    name = json['name'];
    slug = json['slug'];
    featuredImage = json['featured_image'];
    parentId = json['parent_id'];

    if (json['children'] != null) {
      children = (json['children'] as List)
          .map((e) => SectionItem.fromJson(e))
          .toList();
    }
    price = (json['price'] as num?)?.toDouble();
    mrp = (json['mrp'] as num?)?.toDouble();
    discountPercent = json['discount_percent'];
    stock = json['stock'];
    inStock = json['in_stock'];
    image = json['image'];
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    sellerName = json['seller_name'];
  }
}
