class VerifyOtpResponse {
  VerifyOtpResponse({
      this.status, 
      this.profileNeeded, 
      this.redirect, 
      this.token, 
      this.user,});

  VerifyOtpResponse.fromJson(dynamic json) {
    status = json['status'];
    profileNeeded = json['profile_needed'];
    redirect = json['redirect'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? status;
  bool? profileNeeded;
  dynamic redirect;
  String? token;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['profile_needed'] = profileNeeded;
    map['redirect'] = redirect;
    map['token'] = token;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

class User {
  User({
      this.id, 
      this.name, 
      this.phone, 
      this.email, 
      this.emailVerifiedAt, 
      this.role, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? name;
  String? phone;
  dynamic email;
  dynamic emailVerifiedAt;
  String? role;
  String? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['email'] = email;
    map['email_verified_at'] = emailVerifiedAt;
    map['role'] = role;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}