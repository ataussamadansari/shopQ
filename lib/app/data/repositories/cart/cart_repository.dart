import 'package:dio/dio.dart';
import '../../models/cart/cart_model.dart';
import '../../models/response_model.dart';
import '../../services/api/api_services.dart';
import '../../../core/constants/api_constants.dart';

class CartRepository {
  final ApiServices _api = ApiServices();

  Future<ApiResponse<CartModel>> getCart({String? pincode}) async {
    try {
      final res = await _api.get<Map<String, dynamic>>(
        ApiConstants.cart,
        (data) => data as Map<String, dynamic>,
        queryParameters: pincode != null ? {'pincode': pincode} : null,
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(CartModel.fromJson(res.data!['data']));
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<CartModel>> addItem({
    required int productId,
    required int qty,
    int? variantId,
    String? pincode,
  }) async {
    try {
      final res = await _api.post<Map<String, dynamic>>(
        ApiConstants.cartItems,
        (data) => data as Map<String, dynamic>,
        data: {
          'product_id': productId,
          'qty': qty,
          if (variantId != null) 'variant_id': variantId,
          if (pincode != null) 'pincode': pincode,
        },
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(CartModel.fromJson(res.data!['data']));
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<CartModel>> updateItem(int itemId, int qty) async {
    try {
      final endpoint = ApiConstants.cartItem.replaceFirst('{item}', '$itemId');
      final res = await _api.put<Map<String, dynamic>>(
        endpoint,
        (data) => data as Map<String, dynamic>,
        data: {'qty': qty},
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(CartModel.fromJson(res.data!['data']));
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<CartModel>> removeItem(int itemId) async {
    try {
      final endpoint = ApiConstants.cartItem.replaceFirst('{item}', '$itemId');
      final res = await _api.delete<Map<String, dynamic>>(
        endpoint,
        (data) => data as Map<String, dynamic>,
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(CartModel.fromJson(res.data!['data']));
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }
}
