import 'package:dio/dio.dart';
import '../../models/address/address_model.dart';
import '../../models/response_model.dart';
import '../../services/api/api_services.dart';
import '../../../core/constants/api_constants.dart';

class AddressRepository {
  final ApiServices _api = ApiServices();

  Future<ApiResponse<List<AddressModel>>> getAddresses() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(
        ApiConstants.addresses,
        (data) => data as Map<String, dynamic>,
      );
      if (res.success && res.data != null) {
        final list =
            (res.data!['data'] as List?)
                ?.map((e) => AddressModel.fromJson(e))
                .toList() ??
            [];
        return ApiResponse.success(list);
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<AddressModel>> addAddress(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await _api.post<Map<String, dynamic>>(
        ApiConstants.addresses,
        (d) => d as Map<String, dynamic>,
        data: data,
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(AddressModel.fromJson(res.data!['data']));
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<AddressModel>> setDefault(int id) async {
    try {
      final endpoint = ApiConstants.addressDefault.replaceFirst('{id}', '$id');
      final res = await _api.post<Map<String, dynamic>>(
        endpoint,
        (d) => d as Map<String, dynamic>,
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(AddressModel.fromJson(res.data!['data']));
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<bool>> deleteAddress(int id) async {
    try {
      final endpoint = ApiConstants.addressById.replaceFirst('{id}', '$id');
      final res = await _api.delete<Map<String, dynamic>>(
        endpoint,
        (d) => d as Map<String, dynamic>,
      );
      return res.success
          ? ApiResponse.success(true)
          : ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }
}
