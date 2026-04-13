import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/services/storage/storage_services.dart';

class AuthController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthRepository _authRepo = AuthRepository();
  final StorageServices _storage = Get.find();

  // Background animation
  late AnimationController animationController;

  // State
  final isOtpSent = false.obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Resend OTP timer
  final resendSeconds = 0.obs;
  Timer? _resendTimer;

  // Input controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final phoneText = ''.obs;
  final otpText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    phoneController.addListener(() => phoneText.value = phoneController.text);
    otpController.addListener(() => otpText.value = otpController.text);
  }

  bool get isValidPhone => phoneText.value.length == 10;
  bool get isValidOtp => otpText.value.length == 6;
  bool get isButtonEnabled => !isOtpSent.value ? isValidPhone : isValidOtp;
  bool get canResend => resendSeconds.value == 0;

  Future<void> onContinuePressed() async {
    if (!isButtonEnabled || isLoading.value) return;
    isOtpSent.value ? await _verifyOtp() : await _sendOtp();
  }

  Future<void> _sendOtp() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await _authRepo.sendOtp(phoneController.text);

      if (response.success) {
        isOtpSent.value = true;
        _startResendTimer();
        AppHelpers.showSnackBar(
          title: 'OTP Sent',
          message: response.message,
          isError: false,
        );
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
        AppHelpers.showSnackBar(
          title: 'Error',
          message: response.message,
          isError: true,
        );
      }
    } on DioException catch (e) {
      hasError.value = true;
      errorMessage.value = e.message ?? 'Something went wrong';
      AppHelpers.showSnackBar(
        title: 'Error',
        message: e.message ?? 'Something went wrong',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _verifyOtp() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await _authRepo.verifyOtp(
        phoneController.text,
        otpController.text,
      );

      if (response.success && response.data != null) {
        _storage.setToken(response.data!.token!);
        Get.offAllNamed(Routes.location);
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
        AppHelpers.showSnackBar(
          title: 'Invalid OTP',
          message: response.message,
          isError: true,
        );
      }
    } on DioException catch (e) {
      hasError.value = true;
      errorMessage.value = e.message ?? 'Something went wrong';
      AppHelpers.showSnackBar(
        title: 'Error',
        message: e.message ?? 'Something went wrong',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend) return;
    otpController.clear();
    isOtpSent.value = false;
    await _sendOtp();
  }

  void goBackToPhone() {
    isOtpSent.value = false;
    otpController.clear();
    hasError.value = false;
    _resendTimer?.cancel();
    resendSeconds.value = 0;
  }

  void _startResendTimer() {
    resendSeconds.value = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendSeconds.value <= 0) {
        t.cancel();
      } else {
        resendSeconds.value--;
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    phoneController.dispose();
    otpController.dispose();
    _resendTimer?.cancel();
    super.onClose();
  }
}
