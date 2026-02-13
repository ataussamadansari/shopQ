import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopq/app/core/utils/helpers.dart';
import 'package:shopq/app/routes/app_routes.dart';

class LocationController extends GetxController {
  final pinCodeController = TextEditingController();
  var pinCodeText = "".obs;

  @override
  void onInit() {
    super.onInit();
    pinCodeController.addListener(
      () => pinCodeText.value = pinCodeController.text,
    );
  }

  // PinCode is usually 6 digits in India
  bool get isValid => pinCodeText.value.length == 6;

  void onVerifyPinCode() {
    if (isValid) {
      // Logic to fetch area based on pincode or move to Home
      AppHelpers.showSnackBar(
        title: "Success",
        message: "Area detected for ${pinCodeText.value}",
        isError: false,
      );
      Get.offAllNamed(Routes.home);
    }
  }

  @override
  void onClose() {
    pinCodeController.dispose();
    super.onClose();
  }
}
