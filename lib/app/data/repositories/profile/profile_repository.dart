import 'package:dio/dio.dart';
import '../../models/auth/me.dart';
import '../../models/response_model.dart';
import '../../services/api/api_services.dart';
import '../../../core/constants/api_constants.dart';

class ProfileRepository {
  final ApiServices _api = ApiServices();

  Future<ApiResponse<Me>> getProfile() async {
    try {
      final res = await _api.get<Me>(
        ApiConstants.profile,
        (data) => Me.fromJson(data),
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(res.data!);
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }

  Future<ApiResponse<Me>> updateProfile(Map<String, dynamic> data) async {
    try {
      final res = await _api.patch<Me>(
        ApiConstants.profile,
        (d) => Me.fromJson(d),
        data: data,
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(res.data!);
      }
      return ApiResponse.error(res.message);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Something went wrong');
    }
  }
}
