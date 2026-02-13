import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopq/app/core/utils/helpers.dart';
import 'package:shopq/app/global_widgets/pin_code_helper.dart';
import 'package:shopq/app/routes/app_routes.dart';

class AuthController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  final isOtpSent = false.obs;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  // Observable strings to track input length for button enabling
  var phoneText = "".obs;
  var otpText = "".obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    // Sync controller text to our observables
    phoneController.addListener(() => phoneText.value = phoneController.text);
    otpController.addListener(() => otpText.value = otpController.text);
  }

  // Logic to determine if button should be enabled
  bool get isButtonEnabled {
    if (!isOtpSent.value) {
      return phoneText.value.length == 10;
    } else {
      return otpText.value.length == 6;
    }
  }

  void onContinuePressed() {
    if (!isButtonEnabled) return; // Guard clause

    if (!isOtpSent.value) {
      isOtpSent.value = true;
    } else {
      if (otpController.text == "123456") {
        Get.offNamed(Routes.location);
      } else {
        AppHelpers.showSnackBar(
          title: "Invalid OTP",
          message: "Please enter the correct 6-digit code (123456)",
          isError: true,
        );
      }
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
