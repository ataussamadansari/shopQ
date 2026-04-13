import 'package:dio/dio.dart';
import '../../models/order/order_model.dart';
import '../../models/response_model.dart';
import '../../services/api/api_services.dart';
import '../../../core/constants/api_constants.dart';

class OrderRepository {
  final ApiServices _api = ApiServices();

  Future<ApiResponse<List<OrderModel>>> getOrders({int page = 1}) async {
    try {
      final res = await _api.get<Map<String, dynamic>>(
        ApiConstants.orders,
        (data) => data as Map<String, dynamic>,
        queryParameters: {'page': page},
      );
      if (res.success && res.data != null) {
        final list =
            (res.data!['data'] as List?)
                ?.map((e) => OrderModel.fromJson(e))
                .toList() ??
            [];
        return ApiResponse.success(list);
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<OrderModel>> getOrder(String orderNo) async {
    try {
      final endpoint = ApiConstants.orderByNo.replaceFirst(
        '{orderNo}',
        orderNo,
      );
      final res = await _api.get<Map<String, dynamic>>(
        endpoint,
        (data) => data as Map<String, dynamic>,
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(OrderModel.fromJson(res.data!['data']));
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<OrderModel>> placeOrder({
    required int addressId,
    String? notes,
  }) async {
    try {
      final res = await _api.post<Map<String, dynamic>>(
        ApiConstants.checkoutPlace,
        (data) => data as Map<String, dynamic>,
        data: {'address_id': addressId, if (notes != null) 'notes': notes},
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(OrderModel.fromJson(res.data!['data']));
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }
}
