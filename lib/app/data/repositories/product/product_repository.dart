import 'package:dio/dio.dart';
import '../../models/product/product_card_model.dart';
import '../../models/product/product_detail_model.dart';
import '../../models/response_model.dart';
import '../../services/api/api_services.dart';
import '../../../core/constants/api_constants.dart';

class ProductRepository {
  final ApiServices _api = ApiServices();
  CancelToken? _cancelToken;

  Future<ApiResponse<List<ProductCardModel>>> getProducts({
    String? pincode,
    String? categorySlug,
    String? search,
    String? sort,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      _cancelToken = CancelToken();
      final params = <String, dynamic>{
        'per_page': perPage,
        'page': page,
        if (pincode != null) 'pincode': pincode,
        if (categorySlug != null) 'category': categorySlug,
        if (search != null && search.isNotEmpty) 'q': search,
        if (sort != null) 'sort': sort,
      };

      final res = await _api.get<Map<String, dynamic>>(
        ApiConstants.products,
        (data) => data as Map<String, dynamic>,
        queryParameters: params,
        cancelToken: _cancelToken,
      );

      if (res.success && res.data != null) {
        final list =
            (res.data!['data'] as List?)
                ?.map((e) => ProductCardModel.fromJson(e))
                .toList() ??
            [];
        return ApiResponse.success(list);
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<ProductDetailModel>> getProduct(
    String slug, {
    String? pincode,
  }) async {
    try {
      _cancelToken = CancelToken();
      final endpoint = ApiConstants.productSlug.replaceFirst('{slug}', slug);
      final res = await _api.get<Map<String, dynamic>>(
        endpoint,
        (data) => data as Map<String, dynamic>,
        queryParameters: pincode != null ? {'pincode': pincode} : null,
        cancelToken: _cancelToken,
      );

      if (res.success && res.data != null) {
        final product = ProductDetailModel.fromJson(res.data!['data']);
        return ApiResponse.success(product);
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  void cancel() => _cancelToken?.cancel();
}
