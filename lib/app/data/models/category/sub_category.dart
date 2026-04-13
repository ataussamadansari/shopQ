class SubCategory {
  SubCategory({this.success, this.message, this.data, this.meta});

  SubCategory.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  bool? success;
  String? message;
  Data? data;
  Meta? meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    return map;
  }
}

class Meta {
  Meta({this.currentPage, this.perPage, this.total, this.lastPage});

  Meta.fromJson(dynamic json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    map['total'] = total;
    map['last_page'] = lastPage;
    return map;
  }
}

class Data {
  Data({this.category, this.products});

  Data.fromJson(dynamic json) {
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }
  Category? category;
  List<Products>? products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (category != null) {
      map['category'] = category?.toJson();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Products {
  Products({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.mrp,
    this.discountPercent,
    this.stock,
    this.inStock,
    this.image,
    this.brand,
    this.seller,
    this.sellerName,
  });

  Products.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = (json['price'] as num?)?.toDouble();
    mrp = (json['mrp'] as num?)?.toDouble();
    discountPercent = json['discount_percent'];
    stock = json['stock'];
    inStock = json['in_stock'];
    image = json['image'];
    brand = json['brand'];
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    sellerName = json['seller_name'];
  }
  int? id;
  String? title;
  String? slug;
  double? price;
  double? mrp;
  int? discountPercent;
  int? stock;
  bool? inStock;
  String? image;
  dynamic brand;
  Seller? seller;
  String? sellerName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['slug'] = slug;
    map['price'] = price;
    map['mrp'] = mrp;
    map['discount_percent'] = discountPercent;
    map['stock'] = stock;
    map['in_stock'] = inStock;
    map['image'] = image;
    map['brand'] = brand;
    if (seller != null) {
      map['seller'] = seller?.toJson();
    }
    map['seller_name'] = sellerName;
    return map;
  }
}

class Seller {
  Seller({this.id, this.name, this.slug});

  Seller.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }
  int? id;
  String? name;
  String? slug;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['slug'] = slug;
    return map;
  }
}

class Category {
  Category({
    this.id,
    this.name,
    this.slug,
    this.featuredImage,
    this.parentId,
    this.children,
  });

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    featuredImage = json['featured_image'];
    parentId = json['parent_id'];
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children?.add(Children.fromJson(v));
      });
    }
  }
  int? id;
  String? name;
  String? slug;
  String? featuredImage;
  int? parentId;
  List<Children>? children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['slug'] = slug;
    map['featured_image'] = featuredImage;
    map['parent_id'] = parentId;
    if (children != null) {
      map['children'] = children?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Children {
  Children({this.id, this.name, this.slug, this.featuredImage, this.parentId});

  Children.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    featuredImage = json['featured_image'];
    parentId = json['parent_id'];
  }
  int? id;
  String? name;
  String? slug;
  String? featuredImage;
  int? parentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['slug'] = slug;
    map['featured_image'] = featuredImage;
    map['parent_id'] = parentId;
    return map;
  }
}
