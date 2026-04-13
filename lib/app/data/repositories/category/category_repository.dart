import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shopq/app/data/models/category/sub_category.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/response_model.dart';
import '../../services/api/api_services.dart';

class CategoryRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  Future<ApiResponse<SubCategory>> home(String pinCode, String slug) async {
    try {
      cancel();
      _cancelToken = CancelToken();

      final res = await _apiServices.get<SubCategory>(
        ApiConstants.categorySlug.replaceAll("{slug}", slug),
        (data) => SubCategory.fromJson(data),
        queryParameters: {"pincode": pinCode},
        cancelToken: _cancelToken,
      );

      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300 &&
          res.data != null) {
        return ApiResponse.success(res.data!, message: res.message);
      }

      debugPrint("Error: ${res.message}");

      return ApiResponse.error(res.message, statusCode: res.statusCode);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return ApiResponse.error('Request cancelled');
      }

      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  void cancel() {
    if (_cancelToken?.isCancelled == false) {
      _cancelToken?.cancel('Cancelled by user');
    }
  }
}
