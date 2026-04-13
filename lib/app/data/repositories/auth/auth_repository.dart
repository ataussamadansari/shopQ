import 'package:dio/dio.dart';
import 'package:shopq/app/data/models/auth/me.dart';
import 'package:shopq/app/data/models/auth/send_otp_response.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/auth/verify_otp_response.dart';
import '../../models/response_model.dart';
import '../../services/api/api_services.dart';

class AuthRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  Future<ApiResponse<SendOtpResponse>> sendOtp(String phone) async {
    try {
      _cancelToken = CancelToken();
      final res = await _apiServices.post<SendOtpResponse>(
        ApiConstants.sendOtp,
        (data) => SendOtpResponse.fromJson(data),
        data: {"phone": phone},
        cancelToken: _cancelToken,
      );

      if(res.statusCode == 200 && res.data != null) {
        return ApiResponse.success(res.data!, message: res.message);
      } else {
        return ApiResponse.error(
          res.message,
          statusCode: res.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message!,
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<VerifyOtpResponse>> verifyOtp(
    String phone,
    String otp,
  ) async {
    try {
      _cancelToken = CancelToken();
      final response = await _apiServices.post<VerifyOtpResponse>(
        ApiConstants.verifyOtp,
        (data) => VerifyOtpResponse.fromJson(data),
        data: {"phone": phone, "otp": otp},
        cancelToken: _cancelToken,
      );
      if (response.statusCode == 200 && response.data != null) {
        return ApiResponse.success(response.data!, message: response.message);
      } else {
        return ApiResponse.error(
          response.message,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message!,
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Me
  Future<ApiResponse<Me>> me() async {
    try {
      _cancelToken = CancelToken();
      final response = await _apiServices.get(
        ApiConstants.me,
        (data) => Me.fromJson(data),
        cancelToken: _cancelToken,
      );

      if (response.statusCode == 200 && response.data != null) {
        return ApiResponse.success(response.data!, message: response.message);
      } else {
        return ApiResponse.error(
          response.message,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message!,
        statusCode: e.response?.statusCode,
      );
    }
  }
}
