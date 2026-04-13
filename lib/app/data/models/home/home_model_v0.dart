class HomeModel {
  HomeModel({
      this.success, 
      this.message, 
      this.data, });

  HomeModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
      this.tabs, 
      this.sections,});

  Data.fromJson(dynamic json) {
    if (json['tabs'] != null) {
      tabs = [];
      json['tabs'].forEach((v) {
        tabs?.add(Tabs.fromJson(v));
      });
    }
    if (json['sections'] != null) {
      sections = [];
      json['sections'].forEach((v) {
        sections?.add(Sections.fromJson(v));
      });
    }
  }
  List<Tabs>? tabs;
  List<Sections>? sections;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (tabs != null) {
      map['tabs'] = tabs?.map((v) => v.toJson()).toList();
    }
    if (sections != null) {
      map['sections'] = sections?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Sections {
  Sections({
    this.id,
    this.type,
    this.title,
    this.subtitle,
    this.payload,
  });

  Sections.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'];

    if (json['payload'] != null) {
      if (json['payload'] is List) {
        payload = (json['payload'] as List)
            .map((e) => Payload.fromJson(e))
            .toList();
      } else if (json['payload'] is Map) {
        /// For offer_strip type
        payloadMap = Map<String, dynamic>.from(json['payload']);
      }
    }
  }

  String? id;
  String? type;
  String? title;
  String? subtitle;

  List<Payload>? payload;
  Map<String, dynamic>? payloadMap;   // 🔥 NEW

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['title'] = title;
    map['subtitle'] = subtitle;

    if (payload != null) {
      map['payload'] = payload!.map((e) => e.toJson()).toList();
    }

    if (payloadMap != null) {
      map['payload'] = payloadMap;
    }

    return map;
  }
}

class Payload {
  Payload({
    this.id,
    this.title,
    this.link,
    this.imageUrl,

    /// Category fields
    this.name,
    this.slug,
    this.featuredImage,
    this.parentId,
    this.children,
  });

  Payload.fromJson(dynamic json) {
    id = json['id'];

    /// Banner fields
    title = json['title'];
    link = json['link'];
    imageUrl = json['image_url'];

    /// Category fields
    name = json['name'];
    slug = json['slug'];
    featuredImage = json['featured_image'];
    parentId = json['parent_id'];

    if (json['children'] != null) {
      children = (json['children'] as List)
          .map((e) => Payload.fromJson(e))
          .toList();
    }
  }

  num? id;

  /// Banner
  String? title;
  dynamic link;
  String? imageUrl;

  /// Category
  String? name;
  String? slug;
  String? featuredImage;
  num? parentId;
  List<Payload>? children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['id'] = id;
    map['title'] = title;
    map['link'] = link;
    map['image_url'] = imageUrl;

    map['name'] = name;
    map['slug'] = slug;
    map['featured_image'] = featuredImage;
    map['parent_id'] = parentId;

    if (children != null) {
      map['children'] = children!.map((e) => e.toJson()).toList();
    }

    return map;
  }
}

class Tabs {
  Tabs({
      this.key, 
      this.label, 
      this.icon, 
      this.themeColor,});

  Tabs.fromJson(dynamic json) {
    key = json['key'];
    label = json['label'];
    icon = json['icon'];
    themeColor = json['themeColor'];
  }
  String? key;
  String? label;
  String? icon;
  String? themeColor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['label'] = label;
    map['icon'] = icon;
    map['themeColor'] = themeColor;
    return map;
  }

}