import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shopq/app/data/models/home/home_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/response_model.dart';
import '../../services/api/api_services.dart';

class HomeRepository {

  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  Future<ApiResponse<HomeModel>> home(String pinCode) async {
    try {
      _cancelToken = CancelToken();

      final res = await _apiServices.get<HomeModel>(
        ApiConstants.home,
            (data) => HomeModel.fromJson(data),
        queryParameters: {
          "pincode": pinCode,
        },
        cancelToken: _cancelToken,
      );

      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300 &&
          res.data != null) {

        return ApiResponse.success(res.data!, message: res.message);
      }

      debugPrint("Error: ${res.message}");

      return ApiResponse.error(
        res.message,
        statusCode: res.statusCode,
      );

    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }
}
