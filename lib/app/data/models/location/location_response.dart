class LocationResponse {
  LocationResponse({
      this.success, 
      this.message, 
      this.data, });

  LocationResponse.fromJson(dynamic json) {
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
      this.code, 
      this.city, 
      this.state,});

  Data.fromJson(dynamic json) {
    code = json['code'];
    city = json['city'];
    state = json['state'];
  }
  String? code;
  String? city;
  String? state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['city'] = city;
    map['state'] = state;
    return map;
  }

}