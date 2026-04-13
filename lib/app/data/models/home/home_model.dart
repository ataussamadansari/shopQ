import 'home_model_data.dart';

class HomeModel {
  bool? success;
  String? message;
  HomeData? data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? HomeData.fromJson(json['data']) : null;
  }
}